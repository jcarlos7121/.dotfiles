--- Decides whether a clicked link belongs in Neovim or in the browser.
--- Every collaborator is a field so the decision can be tested without spawning anything.
local url = require "octo_open.url"

local M = {}

M.nvim = require "octo_open.nvim"
M.herdr = require "octo_open.herdr"

--- Replaced by init.lua with the real browser and terminal handles.
M.browser = function(_) end
M.activate = function() end

--- Asks the user which instance should take the link: choose(candidates, callback),
--- where callback(nil) means they cancelled. Left unset, the router decides on its own.
M.choose = nil

local function to_browser(raw, done)
  if raw then
    M.browser(raw)
  end
  done "browser"
end

local function deliver(instance, target, raw, done)
  if not M.nvim.send(instance.socket, target.canonical) then
    return to_browser(raw, done)
  end
  M.herdr.focus(instance)
  M.activate()
  done "neovim"
end

--- @param raw string? the url as clicked, Slack wrapper and all
--- @param done fun(outcome: "neovim"|"browser"|"cancelled")? called once, when the link has landed
function M.route(raw, done)
  done = done or function(_) end

  local target = url.parse(raw)
  if not target then
    return to_browser(raw, done)
  end

  local instances = M.nvim.discover()
  local matches = M.nvim.matches(instances, target)

  -- Instances sharing a repo are genuinely ambiguous; anything else the router settles.
  if #matches > 1 and M.choose then
    return M.choose(matches, function(chosen)
      if not chosen then
        return done "cancelled"
      end
      deliver(chosen, target, raw, done)
    end)
  end

  local instance = M.nvim.pick(instances, target)
  if not instance then
    return to_browser(raw, done)
  end
  deliver(instance, target, raw, done)
end

return M
