-- Multi-window scratchpad selector.
--
-- yabai holds one window per scratchpad label and can hide or show each on
-- demand. Showing brings the window to the space you are currently on, which
-- is what makes summon-reply-dismiss work without a space switch --
-- hs.application:unhide() cannot do that, it restores a window to its own
-- space and drags you there. This module adds the part yabai has no UI for:
-- choosing which one.
--
-- All state lives in yabai's per-window `scratchpad` field. This module keeps
-- no registry of its own, so it cannot disagree with reality.

local M = {}

-- Hammerspoon's PATH is minimal; call yabai by absolute path.
local YABAI = "/opt/homebrew/bin/yabai"

-- Size a summoned window is given, as a FRACTION of the display it lands on.
-- Fixed pixels do not work here: a size that leaves comfortable margin on a
-- 3840x1600 external is near-fullscreen on a 1512x982 laptop screen. Wider
-- than tall, and well clear of the screen edges on both.
--
-- Apps still enforce their own minimum widths (Discord 800, Superhuman 780),
-- so this is a request, not a guarantee.
local PAD_W_RATIO, PAD_H_RATIO = 0.55, 0.70

local function windows()
  local out = hs.execute(YABAI .. " -m query --windows")
  local ok, decoded = pcall(hs.json.decode, out)
  if not ok or type(decoded) ~= "table" then return {} end
  return decoded
end

-- Every window currently carrying a scratchpad label.
function M.tagged()
  local out = {}
  for _, w in ipairs(windows()) do
    if w.scratchpad and w.scratchpad ~= "" then out[#out + 1] = w end
  end
  return out
end

-- Tagged windows that are on screen right now. A window sitting on another
-- space also reports is-visible=false, but showing a scratchpad always brings
-- it to the current space, so this is accurate for the windows this module
-- manages.
function M.visible()
  local out = {}
  for _, w in ipairs(M.tagged()) do
    if w["is-visible"] then out[#out + 1] = w end
  end
  return out
end

-- Strip every non-ASCII byte. Rendering a colour emoji in a chooser row
-- crashes Hammerspoon outright: emoji are PNG bitmap glyphs and the crash lands
-- in ImageIO (EXC_BAD_ACCESS / SIGBUS). Verified -- an ASCII subText renders
-- fine, the same row with an emoji takes the process down. Window titles
-- routinely contain emoji (a Discord channel called "#<emoji>-hardware-lab"
-- found this), so everything shown in a row is sanitised first.
local function ascii(str)
  if type(str) ~= "string" then return "" end
  local out = str:gsub("[\128-\255]", "")
  out = out:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
  return out
end

function M.toggleLabel(label)
  hs.execute(YABAI .. " -m window --toggle " .. label)
end

-- Resize the labelled window and centre it on the display in use. Called after
-- summoning from the chooser so the window lands somewhere predictable instead
-- of wherever it happened to be last.
function M.center(label)
  local id
  for _, w in ipairs(M.tagged()) do
    if w.scratchpad == label then id = w.id break end
  end
  if not id then return end

  -- Capture each command's output into a local FIRST. hs.execute returns four
  -- values (output, status, type, rc); passing the call straight into pcall
  -- splats all four into hs.json.decode, which then fails and silently skips
  -- the rest.
  local draw = hs.execute(YABAI .. " -m query --displays --display")
  local dok, disp = pcall(hs.json.decode, draw)
  if not dok or type(disp) ~= "table" or not disp.frame then return end

  hs.execute(string.format("%s -m window %d --resize abs:%d:%d", YABAI, id,
    math.floor(disp.frame.w * PAD_W_RATIO), math.floor(disp.frame.h * PAD_H_RATIO)))

  -- Re-read the frame rather than assuming the resize was honoured: centring on
  -- the requested size would put a window that refused to shrink off-centre.
  local wraw = hs.execute(string.format("%s -m query --windows --window %d", YABAI, id))
  local wok, win = pcall(hs.json.decode, wraw)
  if not wok or type(win) ~= "table" or not win.frame then return end

  local x = math.floor(disp.frame.x + (disp.frame.w - win.frame.w) / 2)
  local y = math.floor(disp.frame.y + (disp.frame.h - win.frame.h) / 2)
  hs.execute(string.format("%s -m window %d --move abs:%d:%d", YABAI, id, x, y))
end

-- Windows already given a size, keyed by window id. A scratchpad is sized and
-- centred the FIRST time it is summoned and left alone afterwards, so a window
-- you resized by hand keeps that size on later summons.
--
-- Keyed by window id rather than label so a different window taking over a
-- label gets sized. Reset when Hammerspoon reloads, which means the first
-- summon after a reload sizes once more -- cheap and predictable. Releasing and
-- re-adding the same window does NOT reset it.
M.sized = M.sized or {}

-- Centre the labelled window unless it has already been sized once.
function M.centerOnce(label)
  local id
  for _, w in ipairs(M.tagged()) do
    if w.scratchpad == label then id = w.id break end
  end
  if not id or M.sized[id] then return end
  M.sized[id] = true
  M.center(label)
end

function M.toggle()
  local shown = M.visible()
  if #shown > 0 then
    -- Loop rather than assume one: this module never shows two at once, but
    -- clicking a notification can surface another behind its back, so hiding
    -- has to clear whatever is actually on screen.
    for _, w in ipairs(shown) do M.toggleLabel(w.scratchpad) end
    return
  end

  local pads = M.tagged()
  if #pads == 0 then
    hs.alert.show("No scratchpad windows")
    return
  end

  local choices = {}
  for _, w in ipairs(pads) do
    local title = ascii(w.title)
    choices[#choices + 1] = {
      text = ascii(w.app),
      subText = title ~= "" and title or w.scratchpad,
      label = w.scratchpad,
    }
  end

  -- The chooser MUST be retained. An anonymous `hs.chooser.new(...):show()` is
  -- garbage collected while still on screen and takes Hammerspoon down with it
  -- (EXC_BAD_ACCESS / SIGBUS inside ImageIO while it renders). Keeping it on
  -- the module table also means it is built once and only re-populated.
  if not M.chooser then
    M.chooser = hs.chooser.new(function(choice)
      if not choice then return end
      M.toggleLabel(choice.label)
      -- yabai needs a beat to actually surface the window; positioning inline
      -- lands on the frame it had before it was shown.
      hs.timer.doAfter(0.25, function() M.centerOnce(choice.label) end)
    end)
    M.chooser:placeholderText("scratchpad")
  end
  M.chooser:choices(choices)
  M.chooser:show()
end

hs.hotkey.bind({ "alt" }, "f", M.toggle)

return M
