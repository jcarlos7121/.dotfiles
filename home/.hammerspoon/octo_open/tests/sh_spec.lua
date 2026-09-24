local T = require "octo_open.tests.harness"
local sh = require "octo_open.sh"

--- A throwaway directory holding one executable with a name nothing else has,
--- so it can only be found through sh's own path_prefix and never the real PATH.
local function with_fake_bin(fn)
  local dir = os.tmpname() .. ".d"
  os.execute("mkdir -p '" .. dir .. "'")
  local script = io.open(dir .. "/octo_open_fake_bin", "w")
  script:write "#!/bin/sh\necho ran\n"
  script:close()
  os.execute("chmod +x '" .. dir .. "/octo_open_fake_bin'")

  local restore = sh.path_prefix
  sh.path_prefix = dir
  local ok, result = pcall(fn)
  sh.path_prefix = restore
  os.execute("rm -rf '" .. dir .. "'")
  if not ok then
    error(result, 0)
  end
  return result
end

-- batching ---------------------------------------------------------------

T.test("gives every command in a batch the configured PATH, not just the first", function()
  -- `PATH=x cmd1; cmd2` applies the assignment to cmd1 alone. A batch built that
  -- way ran everything after the first command with Hammerspoon's bare launchd
  -- PATH, where neither nvim nor herdr exists -- so five of six neovim instances
  -- silently vanished and the chooser stopped appearing.
  local answers = with_fake_bin(function()
    return sh.capture_all { { "octo_open_fake_bin" }, { "octo_open_fake_bin" }, { "octo_open_fake_bin" } }
  end)
  T.eq(#answers, 3)
  for index = 1, 3 do
    T.eq(answers[index]:find "ran" ~= nil, true)
  end
end)

T.test("keeps later answers aligned when a command in the middle fails", function()
  local answers = sh.capture_all { { "echo", "alpha" }, { "false" }, { "echo", "gamma" } }
  T.eq(#answers, 3)
  T.eq((answers[1]:gsub("%s+$", "")), "alpha")
  T.eq((answers[2]:gsub("%s+$", "")), "")
  T.eq((answers[3]:gsub("%s+$", "")), "gamma")
end)

T.test("passes arguments through untouched, spaces and quotes included", function()
  local answers = sh.capture_all { { "echo", "two words" }, { "echo", "it's quoted" } }
  T.eq((answers[1]:gsub("%s+$", "")), "two words")
  T.eq((answers[2]:gsub("%s+$", "")), "it's quoted")
end)

T.test("answers an empty batch with an empty list", function()
  T.eq(sh.capture_all {}, {})
end)

-- mtimes -----------------------------------------------------------------

T.test("keys times by path and simply omits one it cannot read", function()
  -- stat skips an unreadable path rather than reporting it, so times read
  -- positionally would shift every later path onto the wrong number.
  local times = sh.mtimes { "/etc/hosts", "/octo_open/definitely/not/here" }
  T.eq(type(times["/etc/hosts"]), "number")
  T.eq(times["/octo_open/definitely/not/here"], nil)
end)

T.test("answers an empty path list with no times", function()
  T.eq(sh.mtimes {}, {})
end)

-- globbing ---------------------------------------------------------------

T.test("matches every pattern in one call", function()
  T.eq(#sh.glob_all { "/etc/hosts", "/etc/passwd" }, 2)
end)

T.test("answers an empty pattern list without shelling out", function()
  T.eq(sh.glob_all {}, {})
end)

T.report()
