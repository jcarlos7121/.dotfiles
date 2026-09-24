--- Brings the herdr pane hosting a Neovim instance to the front.
--- Pane selection is pure; the CLI and JSON decoding are injectable so tests stay offline.
local M = {}

M.system = require "octo_open.sh"
M.bin = "herdr"

--- Hammerspoon runs outside any herdr pane, so HERDR_SESSION is not in its environment
--- and the CLI would look for a server at the default socket instead of the session's.
--- Every command therefore names the session. nil means: find it on disk.
M.session_name = nil

--- Hammerspoon supplies the JSON decoder; under plain `lua` tests stub this out.
M.json = (type(hs) == "table" and hs.json) or {
  decode = function()
    return nil
  end,
}

local function decode(out)
  if not out then
    return nil
  end
  local ok, value = pcall(M.json.decode, out)
  return ok and value or nil
end

--- @param paths string[] session socket paths
--- @return string? session name
function M.session_from_paths(paths)
  for _, path in ipairs(paths) do
    local name = path:match "/sessions/([^/]+)/herdr%.sock$"
    if name then
      return name
    end
  end
  return nil
end

local function session()
  if M.session_name then
    return M.session_name
  end
  local home = os.getenv "HOME" or ""
  local found = M.session_from_paths(M.system.glob(home .. "/.config/herdr/sessions/*/herdr.sock"))
  -- Remember it. argv() runs for every herdr command, so re-globbing here costs
  -- an io.popen -- about 90ms in Hammerspoon's environment -- on every one of
  -- them: 30 subprocesses to list 14 panes instead of 16. A nil result is not
  -- cached, and clearing the field (as the tests do) forces a fresh lookup.
  M.session_name = found
  return found
end

--- Builds a herdr command line with the session flag in front of the subcommand.
--- @return string[] argv
function M.argv(...)
  local argv = { M.bin }
  local name = session()
  if name then
    argv[#argv + 1] = "--session"
    argv[#argv + 1] = name
  end
  for _, part in ipairs { ... } do
    argv[#argv + 1] = part
  end
  return argv
end

local function pids_of(instance)
  if instance.pids then
    return instance.pids
  end
  local pids = {}
  if instance.pid then
    pids[#pids + 1] = instance.pid
  end
  if instance.ppid then
    pids[#pids + 1] = instance.ppid
  end
  return pids
end

--- Paths under $HOME read better as ~/... in a picker row.
local function shorten(path)
  local home = os.getenv "HOME"
  if home and home ~= "" and path:sub(1, #home) == home then
    return "~" .. path:sub(#home + 1)
  end
  return path
end

local function hosts_pid(pane, wanted)
  for _, found in ipairs(pane.pids or {}) do
    if found == wanted then
      return true
    end
  end
  return false
end

--- Only the pane actually running the instance counts. Matching on directory instead
--- looks helpful but lies: several instances share one repo, and detached ones belong to
--- no pane at all, so every one of them would be handed the same unrelated pane.
--- Walks the chain outwards and stops at the first ancestor that names exactly one
--- pane. An ancestor shared by several panes — every pane descends from the herdr
--- process — identifies nothing, so the search gives up rather than guessing.
---@param panes table[]
---@param pids number[] the instance's process chain, nearest first
---@return table? pane
function M.pick_pane(panes, pids)
  for _, pid in ipairs(pids) do
    local found
    for _, pane in ipairs(panes) do
      if hosts_pid(pane, pid) then
        if found then
          return nil
        end
        found = pane
      end
    end
    if found then
      return found
    end
  end
  return nil
end

--- @return table[] argv lists; the workspace has to come first or the tab focus lands off-screen
function M.focus_commands(pane)
  return {
    M.argv("workspace", "focus", pane.workspace_id),
    M.argv("tab", "focus", pane.tab_id),
  }
end

--- @return table[] panes with the pids of whatever is running in them
function M.panes()
  local listing = decode(M.system.capture(M.argv("pane", "list")))
  local listed = listing and listing.result and listing.result.panes
  if not listed then
    return {}
  end

  -- Ask for every pane's process info in one subprocess. One call per pane is
  -- the single slowest thing octo_open does: 14 panes meant 14 io.popens, about
  -- 90ms each, before the chooser could be built.
  local queries = {}
  for index, pane in ipairs(listed) do
    queries[index] = M.argv("pane", "process-info", "--pane", pane.pane_id)
  end
  local answers = M.system.capture_all(queries)

  local panes = {}
  for index, pane in ipairs(listed) do
    local info = decode(answers[index])
    local process_info = info and info.result and info.result.process_info
    local pids = {}
    if process_info then
      if process_info.shell_pid then
        pids[#pids + 1] = process_info.shell_pid
      end
      if process_info.foreground_process_group_id then
        pids[#pids + 1] = process_info.foreground_process_group_id
      end
      for _, process in ipairs(process_info.foreground_processes or {}) do
        if process.pid then
          pids[#pids + 1] = process.pid
        end
      end
    end
    panes[#panes + 1] = {
      pane_id = pane.pane_id,
      tab_id = pane.tab_id,
      workspace_id = pane.workspace_id,
      cwd = pane.cwd,
      foreground_cwd = pane.foreground_cwd,
      title = pane.terminal_title_stripped or pane.terminal_title,
      pids = pids,
    }
  end
  return panes
end

--- @return table<string, table> workspace_id -> { label, number }
function M.workspaces()
  local listing = decode(M.system.capture(M.argv("workspace", "list")))
  local listed = listing and listing.result and listing.result.workspaces
  if not listed then
    return {}
  end
  local by_id = {}
  for _, workspace in ipairs(listed) do
    by_id[workspace.workspace_id] = { label = workspace.label, number = workspace.number }
  end
  return by_id
end

--- Where an instance lives, in herdr's terms.
---@return table? { pane_id, tab_id, workspace_id, workspace_label, workspace_number, title }
function M.locate(panes, workspaces, instance)
  local pane = M.pick_pane(panes, pids_of(instance))
  if not pane then
    return nil
  end
  local workspace = workspaces[pane.workspace_id]
  return {
    pane_id = pane.pane_id,
    tab_id = pane.tab_id,
    workspace_id = pane.workspace_id,
    workspace_label = workspace and workspace.label,
    workspace_number = workspace and workspace.number,
    title = pane.title,
  }
end

--- Two lines for a picker row. Instances that share a repo share a cwd too, and two
--- panes of one workspace share the label, so the top line carries workspace *and*
--- pane title, and the pane id backs it up: no two rows can come out identical.
---@return string primary, string secondary
function M.describe(located, instance)
  local cwd = shorten(instance.cwd or "")
  if not located then
    return "Neovim " .. tostring(instance.pid or "?"), cwd
  end

  local parts = {}
  if located.workspace_number and located.workspace_label then
    parts[#parts + 1] = located.workspace_number .. " · " .. located.workspace_label
  end
  if located.title then
    parts[#parts + 1] = located.title
  end
  if #parts == 0 then
    parts[#parts + 1] = located.pane_id or "Neovim"
  end

  local secondary = located.pane_id and (located.pane_id .. " · " .. cwd) or cwd
  return table.concat(parts, " · "), secondary
end

--- @param instance table { pid, ppid, cwd }
--- @return boolean whether a pane was found and focused
function M.focus(instance)
  local pane = M.pick_pane(M.panes(), pids_of(instance))
  if not pane then
    return false
  end
  for _, argv in ipairs(M.focus_commands(pane)) do
    M.system.capture(argv)
  end
  return true
end

return M
