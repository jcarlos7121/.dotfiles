-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })

-- ---------------------------------------------------------------------------
-- Mac (yabai + skhd) window management, ported onto ALT (Option).
-- Omarchy's SUPER bindings are left untouched; these sit alongside them.
-- Source: ~/.dotfiles/home/.config/skhd/skhdrc
-- ---------------------------------------------------------------------------

local dirs = { H = "l", J = "d", K = "u", L = "r" }
local names = { H = "left", J = "down", K = "up", L = "right" }
local resize_step = {
  H = { x = -40, y = 0 },
  J = { x = 0, y = 40 },
  K = { x = 0, y = -40 },
  L = { x = 40, y = 0 },
}

for key, dir in pairs(dirs) do
  -- alt - hjkl : focus window
  o.bind("ALT + " .. key, "Focus window " .. names[key], hl.dsp.focus({ direction = dir }))
  -- alt + shift + ctrl - hjkl : swap window
  o.bind("ALT + SHIFT + CTRL + " .. key, "Swap window " .. names[key], hl.dsp.window.swap({ direction = dir }))
  -- alt + shift - hjkl : resize window
  local step = resize_step[key]
  o.bind("ALT + SHIFT + " .. key, "Resize window " .. names[key],
    hl.dsp.window.resize({ x = step.x, y = step.y, relative = true }), { repeating = true })
end

-- alt + shift - d : zoom-fullscreen (window fills the workspace, bar stays)
o.bind("ALT + SHIFT + D", "Zoom window (full width)", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- alt + shift - t : toggle float, centered
o.bind("ALT + SHIFT + T", "Toggle float (centered)", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  local window = hl.get_active_window()
  if window and window.floating then
    hl.dispatch(hl.dsp.window.center())
  end
end)

-- alt - z : minimize (Omarchy's dock minimize)
o.bind("ALT + Z", "Minimize window", "omarchy-hyprland-window-minimize")
-- alt - x : toggle split direction
o.bind("ALT + X", "Toggle window split", hl.dsp.layout("togglesplit"))
-- alt + shift - a : mirror (swap the two halves of the split)
o.bind("ALT + SHIFT + A", "Swap split halves", hl.dsp.layout("swapsplit"))

-- alt - d / alt - f : scratchpad (send window / summon-dismiss)
o.bind("ALT + D", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
o.bind("ALT + F", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))

-- alt + shift - 1..7 : send window to workspace (SUPER + 1..9 still switches)
for workspace = 1, 7 do
  o.bind("ALT + SHIFT + code:" .. tostring(workspace + 9), "Move window to workspace " .. workspace,
    o.workspaces.move_window(workspace))
end

-- alt + shift + ctrl - n/m : previous/next workspace
o.bind("ALT + SHIFT + CTRL + N", "Previous workspace", hl.dsp.focus({ workspace = "m-1" }))
o.bind("ALT + SHIFT + CTRL + M", "Next workspace", hl.dsp.focus({ workspace = "m+1" }))

-- cmd + shift - j/k : focus previous/next display
o.bind("SUPER + SHIFT + K", "Focus next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + SHIFT + J", "Focus previous monitor", hl.dsp.focus({ monitor = "-1" }))
-- cmd + ctrl + shift - o : send window to next display
o.bind("SUPER + CTRL + SHIFT + O", "Move window to next monitor", hl.dsp.window.move({ monitor = "+1" }))

-- Reconnect AirPods Max (after the iPhone takes them)
o.bind("SUPER + ALT + A", "Connect AirPods", "airpods-connect")

-- ctrl - left/right : previous/next workspace (macOS Mission Control habit).
-- Takes Ctrl+arrow word-jumping away from apps, as on the Mac.
-- Steps through your spaces (see spaces.lua) including empty ones, stopping
-- at the first and last instead of wrapping.
local spaces = require("hypr.spaces")

local function step_workspace(delta)
  return function()
    local workspace = hl.get_active_workspace()
    if not workspace or workspace.id < 1 then
      return
    end
    local slot = (workspace.id - 1) % 10 + 1 + delta
    if slot >= 1 and slot <= spaces.last_slot() then
      o.workspaces.focus(slot)()
    end
  end
end
o.bind("CTRL + LEFT", "Previous workspace", step_workspace(-1))
o.bind("CTRL + RIGHT", "Next workspace", step_workspace(1))

-- ctrl - 1..0 : switch to workspace (same as SUPER + number, Mac-style).
-- Keycodes keep it layout-independent; browsers lose Ctrl+number tab switching.
for workspace = 1, 10 do
  o.bind("CTRL + code:" .. tostring(workspace + 9), "Switch to workspace " .. workspace, o.workspaces.focus(workspace))
end

-- alt + shift - m / n : add a space at the end / remove the last one
-- (Hammerspoon hotkeys on the Mac; see spaces.lua)
o.bind("ALT + SHIFT + M", "Add space", spaces.add)
o.bind("ALT + SHIFT + N", "Remove last space", spaces.remove)

-- Contexts-style switcher: alt - tab opens a j/k list of every window (most
-- recent first); repeated alt - tab / alt + shift - tab move through it.
-- Replaces Omarchy's cycle-one-window-per-press. Script: ~/.local/bin/window-switcher
o.rebind("ALT + TAB", "Window switcher", os.getenv("HOME") .. "/.local/bin/window-switcher next")
o.rebind("ALT + SHIFT + TAB", "Window switcher (up)", os.getenv("HOME") .. "/.local/bin/window-switcher prev")
o.window("org.dotfiles.window-switcher", { float = true, center = true, size = { 1000, 520 } })
-- Toggle AirPods Max between music mode and call mode (mic)
o.bind("SUPER + CTRL + ALT + A", "Toggle AirPods call mode", "airpods-mode")

-- Shortcat replacement: hints labels the buttons/links apps expose through
-- accessibility (AT-SPI); type a label to click it, Esc cancels. Shift+label
-- right-clicks, Ctrl+label hovers. Replaces the Super+D -> Ctrl+D app shortcut.
o.rebind("SUPER + D", "Click by keyboard (hints)", os.getenv("HOME") .. "/.local/bin/hints")

-- Fallback for apps that expose no accessibility tree: wl-kbptr finds the
-- buttons/links on screen by image detection (OpenCV) instead.
o.bind("SUPER + ALT + D", "Click by keyboard (wl-kbptr)",
  "wl-kbptr -o modes=floating,click -o mode_floating.source=detect")

-- ctrl + shift - n : dismiss notifications (was Hammerspoon on the Mac)
o.bind("CTRL + SHIFT + N", "Dismiss all notifications", { ipc = "notifications.dismissAll" })

-- Keybindings menu moved from SUPER + K to SUPER + F1; SUPER + K left free
hl.unbind("SUPER + K")
o.bind("SUPER + F1", "Keybindings", "omarchy-menu-keybindings")

-- ---------------------------------------------------------------------------
-- Cmd-style app shortcuts: SUPER + key sends CTRL + key to the focused app,
-- the way Omarchy's universal copy/paste does for SUPER + C/V/X
-- (default/hypr/bindings/clipboard.lua).
-- ---------------------------------------------------------------------------

local function send_ctrl(key, mods)
  mods = mods or "CTRL"
  hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end

-- Terminals carry Omarchy's "terminal" tag (default/hypr/apps/terminals.lua)
local function active_window_is_terminal()
  local window = hl.get_active_window()
  for _, tag in ipairs(window and window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end
  return false
end

-- Super keys Omarchy leaves free: Cmd+K in Slack, Cmd+B bold, Cmd+Z undo, ...
-- Skipped in terminals, where Ctrl+K/D/R/Z mean something else entirely.
-- D is left out: Super+D is hints (click by keyboard).
for _, key in ipairs({ "B", "E", "H", "K", "N", "R", "Y", "Z" }) do
  o.bind("SUPER + " .. key, "App shortcut (Ctrl + " .. key .. ")", function()
    if not active_window_is_terminal() then
      send_ctrl(key)
    end
  end)
end

-- SUPER + T (Cmd+T): new tab in browsers, like the Mac. Everywhere else it
-- keeps Omarchy's float toggle.
local browser_classes = {
  "^google%-chrome", "^chromium$", "^brave%-browser", "^vivaldi", "^microsoft%-edge",
  "^zen", "^firefox$", "^librewolf$",
}

local function active_window_is_browser()
  local window = hl.get_active_window()
  local class = window and window.class or ""
  for _, pattern in ipairs(browser_classes) do
    if class:find(pattern) then
      return true
    end
  end
  return false
end

-- Cmd-style browser shortcuts: in a browser SUPER + key acts as CTRL + key;
-- every other window keeps Omarchy's action (the last field).
local browser_keys = {
  { "SUPER + T", "CTRL", "T", "New tab / toggle floating", hl.dsp.window.float({ action = "toggle" }) },
  { "SUPER + W", "CTRL", "W", "Close tab / close window", hl.dsp.window.close() },
  { "SUPER + F", "CTRL", "F", "Find / full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }) },
  { "SUPER + L", "CTRL", "L", "Address bar / cycle workspace layout", "omarchy-hyprland-workspace-layout-toggle" },
  { "SUPER + G", "CTRL", "G", "Find next / toggle window grouping", hl.dsp.group.toggle() },
  { "SUPER + SHIFT + T", "CTRL SHIFT", "T", "Reopen closed tab / Activity", "omarchy-launch-tui btop" },
  { "SUPER + SHIFT + G", "CTRL SHIFT", "G", "Find previous / Signal", "omarchy-launch-signal" },
}

for _, entry in ipairs(browser_keys) do
  local keys, mods, key, description, fallback = table.unpack(entry)
  if type(fallback) == "string" then
    fallback = hl.dsp.exec_cmd(fallback)
  end
  o.rebind(keys, description, function()
    if active_window_is_browser() then
      send_ctrl(key, mods)
    else
      hl.dispatch(fallback)
    end
  end)
end

-- SUPER + S in Zen: toggle compact mode (hides/shows the sidebar), which this
-- Zen profile has on Ctrl+S. Zen only: Ctrl+S is "save page" in other browsers.
-- Everywhere else it keeps Omarchy's scratchpad toggle.
local scratchpad = hl.dsp.workspace.toggle_special("scratchpad")
o.rebind("SUPER + S", "Zen sidebar (compact mode) / toggle scratchpad", function()
  local window = hl.get_active_window()
  if window and window.class == "zen" then
    send_ctrl("S")
  else
    hl.dispatch(scratchpad)
  end
end)

-- alt - i : 1Password Quick Access, from anywhere (1Password can't register
-- global shortcuts itself under Wayland)
o.bind("ALT + I", "1Password Quick Access", "1password --quick-access")

-- Omarchy menu moved from SUPER + SPACE to ALT + SPACE (Alfred habit);
-- SUPER + SPACE left free
hl.unbind("SUPER + SPACE")
o.bind("ALT + SPACE", "Omarchy menu", { menu = "root" })

-- cmd + ctrl + shift - 4 : smart screenshot (pick an area or window; saved to
-- ~/Pictures/Screenshots and copied to the clipboard). The MacBook keyboard
-- has no Print key. code:13 is the 4 key.
o.bind("SUPER + CTRL + SHIFT + code:13", "Smart screenshot", "omarchy-capture-screenshot")

-- cmd + ctrl - hjkl : move the mouse pointer from the keyboard (hold to keep
-- going). Takes over Omarchy's Super+Ctrl+L (lock), +H (hardware menu) and
-- +K (herdr keybindings); the menus are still in the Omarchy menu.
local function nudge_pointer(dx, dy)
  return function()
    local pos = hl.get_cursor_pos()
    if pos then
      hl.dispatch(hl.dsp.cursor.move({ x = pos.x + dx, y = pos.y + dy }))
    end
  end
end

local pointer_step = 25
o.rebind("SUPER + CTRL + H", "Move pointer left", nudge_pointer(-pointer_step, 0), { repeating = true })
o.rebind("SUPER + CTRL + J", "Move pointer down", nudge_pointer(0, pointer_step), { repeating = true })
o.rebind("SUPER + CTRL + K", "Move pointer up", nudge_pointer(0, -pointer_step), { repeating = true })
o.rebind("SUPER + CTRL + L", "Move pointer right", nudge_pointer(pointer_step, 0), { repeating = true })

-- cmd + ctrl - q : lock the screen (the macOS chord), moved off Super+Ctrl+L
o.bind("SUPER + CTRL + Q", "Lock system", "omarchy-system-lock")

-- cmd + ctrl - n / r : left / right click at the pointer (pairs with the
-- Super+Ctrl+hjkl pointer keys). Hyprland can't click by itself, so this goes
-- through ydotool (needs `systemctl --user enable --now ydotool`). Releasing
-- Ctrl/Super on ydotool's virtual keyboard first stops apps from seeing a
-- Ctrl+click. Takes over Omarchy's Super+Ctrl+N (network) and +R (reminder).
o.rebind("SUPER + CTRL + N", "Left click at pointer", "ydotool key 29:0 97:0 125:0 126:0 && ydotool click 0xC0")
o.rebind("SUPER + CTRL + R", "Right click at pointer", "ydotool key 29:0 97:0 125:0 126:0 && ydotool click 0xC1")

-- cmd - 1..9 in Discord: switch servers like the Mac app, by sending Ctrl +
-- number. Works in Vesktop (the desktop client here); the Chrome web app
-- swallows Ctrl + number for tab switching. Everywhere else it keeps switching
-- workspaces (and Ctrl + number still switches workspaces from inside Discord).
local function active_window_is_discord()
  local window = hl.get_active_window()
  local class = window and window.class or ""
  return class == "vesktop" or class:find("discord") ~= nil
end

for slot = 1, 9 do
  local focus_workspace = o.workspaces.focus(slot)
  o.rebind("SUPER + code:" .. tostring(slot + 9), "Discord server " .. slot .. " / switch to workspace " .. slot, function()
    if active_window_is_discord() then
      send_ctrl(tostring(slot))
    else
      focus_workspace()
    end
  end)
end
