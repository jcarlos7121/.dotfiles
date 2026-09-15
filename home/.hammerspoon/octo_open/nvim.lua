--- Finds the running Neovim instance that should receive a GitHub link, and sends it there.
--- All shell access goes through `M.system`, so the logic is exercised by plain `lua` in tests.
local M = {}

M.system = require "octo_open.sh"

--- Environment lookup, replaced in tests so socket_globs can be checked deterministically.
M.env = os.getenv

--- Extra socket glob patterns, e.g. stable per-project sockets from `vim.fn.serverstart()`.
M.extra_socket_globs = {}

local function trim(str)
  return (str:match "^%s*(.-)%s*$")
end

--- Every place Neovim might have put a socket. nvim's stdpath("run") is
--- $XDG_RUNTIME_DIR, else $TMPDIR/nvim.<user>/<random>, else /tmp/nvim.<user>/<random>
--- — and the app doing the globbing does not necessarily share the environment of the
--- terminal that started nvim, so all of them are searched rather than just ours.
--- @return string[] glob patterns
function M.socket_globs()
  local user = M.env "USER" or M.env "LOGNAME" or ""

  local patterns, seen = {}, {}
  local function add(pattern)
    if not seen[pattern] then
      seen[pattern] = true
      patterns[#patterns + 1] = pattern
    end
  end

  local function run_dir(path)
    return (path:gsub("/+$", "")) .. "/nvim." .. user .. "/*/nvim.*"
  end

  local xdg = M.env "XDG_RUNTIME_DIR"
  if xdg and xdg ~= "" then
    -- stdpath("run") is that directory itself, with no per-user directory inside it
    add((xdg:gsub("/+$", "")) .. "/nvim.*")
  end
  local tmpdir = M.env "TMPDIR"
  if tmpdir and tmpdir ~= "" then
    add(run_dir(tmpdir))
  end
  add(run_dir "/tmp")

  for _, extra in ipairs(M.extra_socket_globs) do
    add(extra)
  end
  return patterns
end

--- Turns any git remote url into the host/owner/repo it points at.
---@param remote string?
---@return table? { host, owner, repo }
function M.repo_from_remote(remote)
  if type(remote) ~= "string" then
    return nil
  end
  local rest = trim(remote)
  if rest == "" then
    return nil
  end

  rest = rest:gsub("^%a[%w+.%-]*://", "") -- scheme
  rest = rest:gsub("^[^/@]*@", "") -- user[:password]@

  local host, path = rest:match "^([^/:]+)[:/](.+)$"
  if not host then
    return nil
  end

  local owner, repo = path:gsub("%.git$", ""):match "^([^/]+)/([^/]+)$"
  if not owner then
    return nil
  end

  return { host = host, owner = owner, repo = repo }
end

local function same_repo(remote, target)
  if not remote or not target then
    return false
  end
  return remote.host:lower() == target.host:lower()
    and remote.owner:lower() == target.owner:lower()
    and remote.repo:lower() == target.repo:lower()
end

--- Every instance whose origin remote is the link's repo, in discovery order.
---@param instances table[]
---@param target table parsed url
---@return table[]
function M.matches(instances, target)
  local found = {}
  for _, instance in ipairs(instances) do
    if same_repo(instance.remote, target) then
      found[#found + 1] = instance
    end
  end
  return found
end

--- The instance already sitting in the link's repo wins; otherwise the most recent one.
---@param instances table[]
---@param target table parsed url
---@return table? instance
function M.pick(instances, target)
  local best_match, newest
  for _, instance in ipairs(instances) do
    local mtime = instance.mtime or 0
    if same_repo(instance.remote, target) and (not best_match or mtime > (best_match.mtime or 0)) then
      best_match = instance
    end
    if not newest or mtime > (newest.mtime or 0) then
      newest = instance
    end
  end
  return best_match or newest
end

--- The process chain from an instance outwards, nearest first. A neovim started in a
--- herdr pane sits several links below that pane's shell, so the whole chain is needed
--- to recognise where it lives.
---@param pid number
---@param parents table<number, number>
---@return number[]
function M.ancestry(pid, parents)
  local chain, seen, current = {}, {}, pid
  while current and current > 1 and not seen[current] and #chain < 8 do
    seen[current] = true
    chain[#chain + 1] = current
    current = parents[current]
  end
  return chain
end

--- Asks an instance for its pid and cwd in a single round trip.
local PROBE = [[printf("%d\t%s", getpid(), getcwd())]]

--- @return table[] live instances: { socket, cwd, pid, ppid, remote, mtime }
function M.discover()
  local instances, seen = {}, {}
  local parents = M.system.parents()
  for _, pattern in ipairs(M.socket_globs()) do
    for _, socket in ipairs(M.system.glob(pattern)) do
      if not seen[socket] then
        seen[socket] = true
        local probe = M.system.capture { "nvim", "--server", socket, "--remote-expr", PROBE }
        local pid, cwd = (probe and trim(probe) or ""):match "^(%d+)\t(.+)$"
        if cwd then
          local chain = M.ancestry(tonumber(pid), parents)
          instances[#instances + 1] = {
            socket = socket,
            cwd = cwd,
            pid = tonumber(pid),
            pids = chain,
            ppid = chain[2],
            remote = M.repo_from_remote(M.system.capture { "git", "-C", cwd, "remote", "get-url", "origin" }),
            mtime = M.system.mtime(socket) or 0,
          }
        end
      end
    end
  end
  return instances
end

--- @return boolean whether Neovim accepted the command
function M.send(socket, target_url)
  local keys = "<C-\\><C-N>:Octo " .. target_url .. "<CR>"
  return M.system.capture { "nvim", "--server", socket, "--remote-send", keys } ~= nil
end

return M
