-- Mac-style "spaces": a fixed row of numbered workspaces per monitor that stay
-- around while empty, so you can add one at the end and remove the last one
-- (ported from the Hammerspoon alt+shift+M / alt+shift+N hotkeys).
--
-- Hyprland normally destroys empty workspaces; each space here is kept alive
-- with a persistent workspace rule. The count per monitor is saved to
-- ~/.local/state/hypr-spaces so it survives config reloads and logins.

local M = {}

local SLOTS = 10
local state_file = (os.getenv("HOME") or "") .. "/.local/state/hypr-spaces"

local counts = {} -- monitor name -> number of spaces
local rules = {} -- monitor name -> slot -> HL.WorkspaceRule

local function load_counts()
  local file = io.open(state_file, "r")
  if not file then
    return
  end
  for line in file:lines() do
    local name, count = line:match("^(%S+)%s+(%d+)$")
    if name then
      counts[name] = tonumber(count)
    end
  end
  file:close()
end

local function save_counts()
  local file = io.open(state_file, "w")
  if not file then
    return
  end
  for name, count in pairs(counts) do
    file:write(name, " ", count, "\n")
  end
  file:close()
end

local function slot_of(id)
  return (id - 1) % SLOTS + 1
end

local function workspace_id(monitor_name, slot)
  return o.workspaces.workspace_id({ name = monitor_name }, slot)
end

local function set_persistent(monitor_name, slot, persistent)
  rules[monitor_name] = rules[monitor_name] or {}
  local rule = rules[monitor_name][slot]
  if rule then
    rule:set_enabled(persistent)
  elseif persistent then
    rules[monitor_name][slot] = hl.workspace_rule({
      workspace = tostring(workspace_id(monitor_name, slot)),
      monitor = monitor_name,
      persistent = true,
    })
  end
end

-- The highest slot in use on a monitor: its saved spaces, or any higher
-- workspace that has windows on it.
local function last_slot(monitor)
  local last = counts[monitor.name] or 1
  for _, workspace in ipairs(hl.get_workspaces()) do
    if not workspace.special and workspace.id >= 1 and workspace.monitor and workspace.monitor.name == monitor.name then
      last = math.max(last, slot_of(workspace.id))
    end
  end
  return last
end

function M.last_slot()
  local monitor = hl.get_active_monitor()
  return monitor and last_slot(monitor) or SLOTS
end

-- alt + shift - m : add a space after the last one (focus stays where it is)
function M.add()
  local monitor = hl.get_active_monitor()
  if not monitor then
    return
  end

  local slot = last_slot(monitor) + 1
  if slot > SLOTS then
    hl.exec_cmd(o.notify("Already at " .. SLOTS .. " spaces"))
    return
  end

  for s = 1, slot do
    set_persistent(monitor.name, s, true)
  end
  counts[monitor.name] = slot
  save_counts()
  hl.exec_cmd(o.notify("Added space " .. slot))
end

-- alt + shift - n : remove the last space; its windows move to the one before
function M.remove()
  local monitor = hl.get_active_monitor()
  if not monitor then
    return
  end

  local slot = last_slot(monitor)
  if slot <= 1 then
    hl.exec_cmd(o.notify("No additional spaces to remove"))
    return
  end

  local from = workspace_id(monitor.name, slot)
  local to = workspace_id(monitor.name, slot - 1)
  for _, window in ipairs(hl.get_windows()) do
    if window.workspace and window.workspace.id == from then
      hl.dispatch(hl.dsp.window.move({ workspace = tostring(to), follow = false, window = "address:" .. window.address }))
    end
  end

  local active = hl.get_active_workspace()
  if active and active.id == from then
    hl.dispatch(hl.dsp.focus({ workspace = tostring(to) }))
  end

  set_persistent(monitor.name, slot, false)
  counts[monitor.name] = slot - 1
  save_counts()
  hl.exec_cmd(o.notify("Removed space " .. slot))
end

load_counts()
for name, count in pairs(counts) do
  for slot = 1, count do
    set_persistent(name, slot, true)
  end
end

return M
