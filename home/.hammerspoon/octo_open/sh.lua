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

local function with_path(command)
  return "PATH=" .. M.path_prefix .. ':"$PATH" ' .. command
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
