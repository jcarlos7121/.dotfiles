--- Shell access for the octo_open modules.
--- Hammerspoon inherits a bare launchd PATH, so `nvim`, `git` and `herdr` are only
--- reachable once we put the usual homebrew/user bin directories back on it.
local M = {}

M.path_prefix = "/opt/homebrew/bin:" .. (os.getenv "HOME" or "") .. "/.local/bin:/usr/local/bin:/usr/bin:/bin"

local function trim(str)
  return (str:match "^%s*(.-)%s*$")
end

local function shell_quote(arg)
  return "'" .. (tostring(arg):gsub("'", "'\\''")) .. "'"
end

--- Marks the boundary between batched command outputs. Letters, digits and
--- underscores only, so it is safe to search for as plain text.
local SEPARATOR = "__octo_open_sep_7f3a91__"

--- `PATH=x cmd` applies only to that one command, so a batch chained with `;`
--- would run everything after the first with Hammerspoon's bare launchd PATH and
--- fail to find nvim or herdr at all. Export it instead, so it holds for every
--- command in the string.
local function with_path(command)
  return "export PATH=" .. M.path_prefix .. ':"$PATH"; ' .. command
end

--- @return string[] paths matching the glob (empty when nothing matches)
function M.glob(pattern)
  local paths = {}
  local pipe = io.popen(with_path("ls -1d " .. pattern .. " 2>/dev/null"))
  if not pipe then
    return paths
  end
  for line in pipe:lines() do
    paths[#paths + 1] = line
  end
  pipe:close()
  return paths
end

--- Every pattern in one `ls`, rather than one subprocess per pattern.
--- @return string[] paths matching any of the patterns (empty when none match)
function M.glob_all(patterns)
  if #patterns == 0 then
    return {}
  end
  -- Patterns go in unquoted on purpose: the shell has to expand them.
  return M.glob(table.concat(patterns, " "))
end

--- @return number? unix mtime
function M.mtime(path)
  local pipe = io.popen(with_path("stat -f %m " .. shell_quote(path) .. " 2>/dev/null"))
  if not pipe then
    return nil
  end
  local out = pipe:read "a"
  pipe:close()
  return tonumber(trim(out or ""))
end

--- The whole process table in one call, rather than one `ps` per pid.
--- @return table<number, number> pid -> parent pid
function M.parents()
  local parents = {}
  local pipe = io.popen(with_path "ps -ax -o pid=,ppid= 2>/dev/null")
  if not pipe then
    return parents
  end
  for line in pipe:lines() do
    local pid, ppid = line:match "^%s*(%d+)%s+(%d+)"
    if pid then
      parents[tonumber(pid)] = tonumber(ppid)
    end
  end
  pipe:close()
  return parents
end

--- Several paths in one `stat`. The name is printed alongside each time and the
--- result keyed by it, because `stat` simply omits a path it cannot read -- with
--- bare times, one unreadable socket would shift every later path onto the wrong
--- number.
--- @return table<string, number> path -> unix mtime
function M.mtimes(paths)
  local times = {}
  if #paths == 0 then
    return times
  end
  local quoted = {}
  for i, path in ipairs(paths) do
    quoted[i] = shell_quote(path)
  end
  local pipe = io.popen(with_path("stat -f '%m %N' " .. table.concat(quoted, " ") .. " 2>/dev/null"))
  if not pipe then
    return times
  end
  for line in pipe:lines() do
    local mtime, path = line:match "^%s*(%d+)%s+(.+)$"
    if path then
      times[trim(path)] = tonumber(mtime)
    end
  end
  pipe:close()
  return times
end

--- Runs every argv in a single subprocess. Each `io.popen` costs roughly 90ms in
--- Hammerspoon's environment, so a loop of them is the difference between a
--- chooser that appears at once and one that takes seconds. A separator is
--- printed after every command, failures included, so the outputs stay aligned
--- with the argv list.
--- @param argvs table[] list of argv lists
--- @return string[] stdout per argv, in order; "" where a command produced none
function M.capture_all(argvs)
  local results = {}
  if #argvs == 0 then
    return results
  end

  local commands = {}
  for index, argv in ipairs(argvs) do
    local quoted = {}
    for i, arg in ipairs(argv) do
      quoted[i] = shell_quote(arg)
    end
    commands[index] = table.concat(quoted, " ") .. " 2>/dev/null; printf '\n" .. SEPARATOR .. "\n'"
  end

  local pipe = io.popen(with_path(table.concat(commands, "; ")))
  if not pipe then
    return results
  end
  local out = pipe:read "a" or ""
  pipe:close()

  local needle, start = "\n" .. SEPARATOR .. "\n", 1
  for _ = 1, #argvs do
    local from, to = out:find(needle, start, true) -- plain find: no pattern escaping
    if not from then
      break
    end
    results[#results + 1] = out:sub(start, from - 1)
    start = to + 1
  end
  -- A shell that died early leaves the tail unfilled; keep the list the length
  -- callers expect so results still line up with the argvs they asked for.
  for i = #results + 1, #argvs do
    results[i] = ""
  end
  return results
end

--- @return string? stdout, or nil when the command exits non-zero
function M.capture(argv)
  local quoted = {}
  for i, arg in ipairs(argv) do
    quoted[i] = shell_quote(arg)
  end
  local pipe = io.popen(with_path(table.concat(quoted, " ") .. " 2>/dev/null"))
  if not pipe then
    return nil
  end
  local out = pipe:read "a"
  local ok = pipe:close()
  if not ok then
    return nil
  end
  return out
end

return M
