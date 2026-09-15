local T = require "octo_open.tests.harness"
local nvim = require "octo_open.nvim"

local function target(host, owner, repo)
  return { host = host, owner = owner, repo = repo }
end

-- remote url parsing -----------------------------------------------------

T.test("parses an ssh remote", function()
  T.eq(nvim.repo_from_remote "git@github.com:pwntester/octo.nvim.git", {
    host = "github.com",
    owner = "pwntester",
    repo = "octo.nvim",
  })
end)

T.test("parses an https remote with and without the .git suffix", function()
  local expected = { host = "github.com", owner = "pwntester", repo = "octo.nvim" }
  T.eq(nvim.repo_from_remote "https://github.com/pwntester/octo.nvim.git", expected)
  T.eq(nvim.repo_from_remote "https://github.com/pwntester/octo.nvim", expected)
end)

T.test("parses an ssh:// remote", function()
  T.eq(nvim.repo_from_remote "ssh://git@github.com/o/r.git", { host = "github.com", owner = "o", repo = "r" })
end)

T.test("parses a remote carrying credentials", function()
  T.eq(
    nvim.repo_from_remote "https://x-access-token:secret@github.com/o/r.git",
    { host = "github.com", owner = "o", repo = "r" }
  )
end)

T.test("parses an enterprise host remote", function()
  T.eq(nvim.repo_from_remote "git@github.acme.dev:o/r.git", { host = "github.acme.dev", owner = "o", repo = "r" })
end)

T.test("ignores trailing whitespace from git output", function()
  T.eq(nvim.repo_from_remote "git@github.com:o/r.git\n", { host = "github.com", owner = "o", repo = "r" })
end)

T.test("returns nil for junk remotes", function()
  T.eq(nvim.repo_from_remote "not a url", nil)
  T.eq(nvim.repo_from_remote "", nil)
  T.eq(nvim.repo_from_remote(nil), nil)
end)

-- instance picking -------------------------------------------------------

T.test("picks nothing when no instance is running", function()
  T.eq(nvim.pick({}, target("github.com", "o", "r")), nil)
end)

T.test("picks the instance whose repo matches the link", function()
  local match = { socket = "/s/b", mtime = 1, remote = target("github.com", "o", "r") }
  local instances = {
    { socket = "/s/a", mtime = 9, remote = target("github.com", "other", "thing") },
    match,
  }
  T.eq(nvim.pick(instances, target("github.com", "o", "r")), match)
end)

T.test("falls back to the newest instance when no repo matches", function()
  local newest = { socket = "/s/b", mtime = 9, remote = target("github.com", "x", "y") }
  local instances = {
    { socket = "/s/a", mtime = 3, remote = target("github.com", "other", "thing") },
    newest,
  }
  T.eq(nvim.pick(instances, target("github.com", "o", "r")), newest)
end)

T.test("prefers the newest instance among several repo matches", function()
  local newest = { socket = "/s/b", mtime = 9, remote = target("github.com", "o", "r") }
  local instances = {
    { socket = "/s/a", mtime = 3, remote = target("github.com", "o", "r") },
    newest,
  }
  T.eq(nvim.pick(instances, target("github.com", "o", "r")), newest)
end)

T.test("matches repo names case-insensitively", function()
  local match = { socket = "/s/a", mtime = 1, remote = target("github.com", "PwnTester", "Octo.nvim") }
  T.eq(nvim.pick({ match }, target("github.com", "pwntester", "octo.nvim")), match)
end)

T.test("does not match across hosts", function()
  local enterprise = { socket = "/s/a", mtime = 1, remote = target("github.acme.dev", "o", "r") }
  local other = { socket = "/s/b", mtime = 2, remote = target("github.com", "z", "z") }
  -- no host match, so this is the newest-instance fallback rather than a repo match
  T.eq(nvim.pick({ enterprise, other }, target("github.com", "o", "r")), other)
end)

T.test("still offers an instance that is not in a git repo", function()
  local no_repo = { socket = "/s/a", mtime = 1, remote = nil }
  T.eq(nvim.pick({ no_repo }, target("github.com", "o", "r")), no_repo)
end)

-- discovery --------------------------------------------------------------

--- One probe returns "<pid>\t<cwd>"; a second call resolves the parent pid.
local function stub_probe(cwd, pid, ppid, remote)
  return {
    glob = function()
      return { "/sock/dead", "/sock/live" }
    end,
    mtime = function()
      return 42
    end,
    parents = function()
      return { [pid] = ppid, [ppid] = 1 }
    end,
    capture = function(argv)
      if argv[1] == "nvim" and argv[3] == "/sock/live" then
        return string.format("%d\t%s\n", pid, cwd)
      elseif argv[1] == "nvim" then
        return nil -- dead socket: nvim exits non-zero
      elseif argv[1] == "git" then
        return remote
      end
    end,
  }
end

T.test("builds instances from live sockets, skipping dead ones", function()
  local restore = nvim.system
  nvim.system = stub_probe("/Users/me/code/octo.nvim", 44904, 44903, "git@github.com:pwntester/octo.nvim.git\n")
  local instances = nvim.discover()
  nvim.system = restore

  T.eq(#instances, 1)
  T.eq(instances[1].socket, "/sock/live")
  T.eq(instances[1].cwd, "/Users/me/code/octo.nvim")
  T.eq(instances[1].remote, { host = "github.com", owner = "pwntester", repo = "octo.nvim" })
  T.eq(instances[1].mtime, 42)
end)

T.test("captures the neovim pid and its parent so a pane can be located", function()
  local restore = nvim.system
  nvim.system = stub_probe("/code", 44904, 44903, nil)
  local instances = nvim.discover()
  nvim.system = restore

  T.eq(instances[1].pid, 44904)
  T.eq(instances[1].ppid, 44903)
end)

T.test("keeps an instance whose directory has no git remote", function()
  local restore = nvim.system
  nvim.system = stub_probe("/tmp", 7, 6, nil)
  local instances = nvim.discover()
  nvim.system = restore

  T.eq(#instances, 1)
  T.eq(instances[1].remote, nil)
end)

--- socket_globs reads the environment, so tests hand it one instead of the real thing.
local function with_env(vars, fn)
  local restore = nvim.env
  nvim.env = function(name)
    return vars[name]
  end
  local ok, result = pcall(fn)
  nvim.env = restore
  if not ok then
    error(result, 0)
  end
  return result
end

T.test("searches the run directories of both environments", function()
  -- The GUI app doing the globbing does not share the terminal's environment:
  -- Hammerspoon gets a TMPDIR, the terminal that started nvim may not.
  local patterns = with_env({ USER = "me", TMPDIR = "/var/folders/xy/T/" }, nvim.socket_globs)
  T.eq(patterns, { "/var/folders/xy/T/nvim.me/*/nvim.*", "/tmp/nvim.me/*/nvim.*" })
end)

T.test("searches /tmp when the app has no TMPDIR at all", function()
  T.eq(with_env({ USER = "me" }, nvim.socket_globs), { "/tmp/nvim.me/*/nvim.*" })
end)

T.test("uses the xdg runtime dir directly, without a per-user directory", function()
  -- nvim's stdpath("run") IS $XDG_RUNTIME_DIR when set, not a subdirectory of it.
  local patterns = with_env({ USER = "me", XDG_RUNTIME_DIR = "/run/user/501" }, nvim.socket_globs)
  T.eq(patterns, { "/run/user/501/nvim.*", "/tmp/nvim.me/*/nvim.*" })
end)

T.test("does not repeat a directory when TMPDIR is already /tmp", function()
  T.eq(with_env({ USER = "me", TMPDIR = "/tmp" }, nvim.socket_globs), { "/tmp/nvim.me/*/nvim.*" })
end)

T.test("keeps any extra globs that were configured", function()
  local restore = nvim.extra_socket_globs
  nvim.extra_socket_globs = { "/custom/nvim.*" }
  local patterns = with_env({ USER = "me" }, nvim.socket_globs)
  nvim.extra_socket_globs = restore
  T.eq(patterns, { "/tmp/nvim.me/*/nvim.*", "/custom/nvim.*" })
end)

T.test("every socket pattern still matches neovim socket names", function()
  for _, pattern in ipairs(nvim.socket_globs()) do
    T.eq(pattern:find "/nvim%.%*$" ~= nil, true)
  end
end)

-- process ancestry -------------------------------------------------------
-- A neovim in a herdr pane sits several processes below that pane's shell:
-- nvim -> nvim -> fish -> fish -> herdr. Matching needs the whole chain.

local PARENTS = { [42147] = 42133, [42133] = 2938, [2938] = 2844, [2844] = 2842, [2842] = 1 }

T.test("walks the process chain from the instance outwards", function()
  T.eq(nvim.ancestry(42147, PARENTS), { 42147, 42133, 2938, 2844, 2842 })
end)

T.test("stops the chain at the init process", function()
  T.eq(nvim.ancestry(5, { [5] = 1 }), { 5 })
end)

T.test("stops the chain when the parent is unknown", function()
  T.eq(nvim.ancestry(5, {}), { 5 })
end)

T.test("does not loop forever on a parent cycle", function()
  T.eq(nvim.ancestry(5, { [5] = 6, [6] = 5 }), { 5, 6 })
end)

T.test("records the whole ancestry on each discovered instance", function()
  local restore = nvim.system
  nvim.system = {
    glob = function()
      return { "/sock/live" }
    end,
    mtime = function()
      return 1
    end,
    parents = function()
      return PARENTS
    end,
    capture = function(argv)
      if argv[1] == "nvim" then
        return "42147\t/code\n"
      end
      return nil
    end,
  }
  local instances = nvim.discover()
  nvim.system = restore

  T.eq(instances[1].pid, 42147)
  T.eq(instances[1].pids, { 42147, 42133, 2938, 2844, 2842 })
end)

T.report()
