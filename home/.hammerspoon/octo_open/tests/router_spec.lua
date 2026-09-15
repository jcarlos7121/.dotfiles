local T = require "octo_open.tests.harness"
local router = require "octo_open.router"

local A = { socket = "/sock/a", cwd = "/code/octo.nvim", pid = 1, ppid = 0, mtime = 1 }
local B = { socket = "/sock/b", cwd = "/code/octo.nvim", pid = 2, ppid = 0, mtime = 2 }

--- Replaces every collaborator so no real process is ever spawned.
local function stub(opts)
  opts = opts or {}
  local calls = { sent = {}, browser = {}, focused = {}, activated = 0, offered = nil }
  local restore = {
    nvim = router.nvim,
    herdr = router.herdr,
    browser = router.browser,
    activate = router.activate,
    choose = router.choose,
  }

  router.nvim = {
    discover = function()
      return opts.instances or { A }
    end,
    matches = function(instances)
      return opts.matches or instances
    end,
    pick = function(instances)
      return instances[1]
    end,
    send = function(socket, target_url)
      calls.sent[#calls.sent + 1] = { socket = socket, url = target_url }
      return opts.send_fails ~= true
    end,
  }
  router.herdr = {
    focus = function(instance)
      calls.focused[#calls.focused + 1] = instance
      return opts.focus_fails ~= true
    end,
  }
  router.browser = function(target_url)
    calls.browser[#calls.browser + 1] = target_url
  end
  router.activate = function()
    calls.activated = calls.activated + 1
  end
  router.choose = opts.choose
      and function(candidates, callback)
        calls.offered = candidates
        opts.choose(candidates, callback)
      end
    or nil

  return calls, function()
    router.nvim, router.herdr = restore.nvim, restore.herdr
    router.browser, router.activate, router.choose = restore.browser, restore.activate, restore.choose
  end
end

--- route reports through a callback now, so every test collects it the same way.
local function route(raw, opts)
  local calls, restore = stub(opts)
  local outcome
  router.route(raw, function(result)
    outcome = result
  end)
  restore()
  return outcome, calls
end

-- the single-instance path -----------------------------------------------

T.test("sends a pull request link to the matching neovim instance", function()
  local outcome, calls = route "https://github.com/pwntester/octo.nvim/pull/1547"
  T.eq(outcome, "neovim")
  T.eq(calls.sent, { { socket = "/sock/a", url = "https://github.com/pwntester/octo.nvim/pull/1547" } })
  T.eq(#calls.browser, 0)
end)

T.test("sends the canonical url, not the slack wrapper", function()
  local _, calls = route "https://slack-redir.net/link?url=https%3A%2F%2Fgithub.com%2Fo%2Fr%2Fissues%2F7%3Fref%3Dslack"
  T.eq(calls.sent[1].url, "https://github.com/o/r/issues/7")
end)

T.test("opens an unrelated link in the browser untouched", function()
  local outcome, calls = route "https://example.com/some/page"
  T.eq(outcome, "browser")
  T.eq(calls.browser, { "https://example.com/some/page" })
  T.eq(#calls.sent, 0)
end)

T.test("leaves unsupported github paths to the browser", function()
  local _, calls = route "https://github.com/o/r/pull/7/files"
  T.eq(calls.browser, { "https://github.com/o/r/pull/7/files" })
  T.eq(#calls.sent, 0)
end)

T.test("falls back to the browser when no neovim is running", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", { instances = {} })
  T.eq(outcome, "browser")
  T.eq(calls.browser, { "https://github.com/o/r/pull/7" })
end)

T.test("falls back to the browser when the send fails", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", { send_fails = true })
  T.eq(outcome, "browser")
  T.eq(calls.browser, { "https://github.com/o/r/pull/7" })
end)

T.test("focuses the pane and the terminal after a successful send", function()
  local _, calls = route "https://github.com/o/r/pull/7"
  T.eq(calls.focused, { A })
  T.eq(calls.activated, 1)
end)

T.test("still counts as delivered when the pane cannot be focused", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", { focus_fails = true })
  T.eq(outcome, "neovim")
  T.eq(calls.activated, 1)
  T.eq(#calls.browser, 0)
end)

T.test("never drops a link when handed nil", function()
  local outcome, calls = route(nil)
  T.eq(outcome, "browser")
  T.eq(#calls.browser, 0) -- nothing to open, but nothing crashes either
end)

-- choosing between instances sharing a repo ------------------------------

T.test("asks which instance when several share the repo", function()
  local _, calls = route("https://github.com/o/r/pull/7", {
    instances = { A, B },
    choose = function(candidates, callback)
      callback(candidates[2])
    end,
  })
  T.eq(calls.offered, { A, B })
end)

T.test("sends to the instance chosen from the picker", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", {
    instances = { A, B },
    choose = function(candidates, callback)
      callback(candidates[2])
    end,
  })
  T.eq(outcome, "neovim")
  T.eq(calls.sent, { { socket = "/sock/b", url = "https://github.com/o/r/pull/7" } })
  T.eq(calls.focused, { B })
end)

T.test("does nothing at all when the choice is cancelled", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", {
    instances = { A, B },
    choose = function(_, callback)
      callback(nil) -- escape
    end,
  })
  T.eq(outcome, "cancelled")
  T.eq(#calls.sent, 0)
  T.eq(#calls.browser, 0)
  T.eq(calls.activated, 0)
end)

T.test("does not ask when only one instance matches", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", {
    instances = { A, B },
    matches = { A },
    choose = function(_, callback)
      callback(nil)
    end,
  })
  T.eq(calls.offered, nil)
  T.eq(outcome, "neovim")
end)

T.test("does not ask when no instance matches the repo", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", {
    instances = { A, B },
    matches = {},
    choose = function(_, callback)
      callback(nil)
    end,
  })
  T.eq(calls.offered, nil)
  T.eq(outcome, "neovim") -- newest-instance fallback still delivers
end)

T.test("picks a match itself when no picker is wired", function()
  local outcome, calls = route("https://github.com/o/r/pull/7", { instances = { A, B } })
  T.eq(outcome, "neovim")
  T.eq(calls.sent, { { socket = "/sock/a", url = "https://github.com/o/r/pull/7" } })
end)

T.report()
