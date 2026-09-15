--- Opens GitHub pull request and issue links in a running Neovim (octo.nvim) instead of the browser.
---
--- Wire it up from ~/.hammerspoon/init.lua:
---
---     require("octo_open").setup()                              -- hotkey only, browser untouched
---     require("octo_open").setup { become_default_browser = true } -- intercept every click
---
--- Only /pull/<n> and /issues/<n> are claimed. Everything else — including /pull/<n>/files,
--- discussions and releases — goes to the browser exactly as before.
local url = require "octo_open.url"
local router = require "octo_open.router"
local herdr = require "octo_open.herdr"

local M = {}

M.router = router
M.browser_bundle = "com.apple.Safari"
M.terminal_bundle = "net.kovidgoyal.kitty"

local function open_in_browser(target)
  hs.urlevent.openURLWithBundle(target, M.browser_bundle)
end

local function activate_terminal()
  hs.application.launchOrFocusByBundleID(M.terminal_bundle)
end

--- Held only so the live chooser is not collected while the user is reading it.
local chooser

--- Asks which Neovim should take the link. Rows are labelled by herdr workspace,
--- because instances sharing a repo also share a directory. Escape picks nothing.
local function choose_instance(candidates, callback)
  local panes, workspaces = herdr.panes(), herdr.workspaces()

  local choices = {}
  for index, instance in ipairs(candidates) do
    local primary, secondary = herdr.describe(herdr.locate(panes, workspaces, instance), instance)
    choices[#choices + 1] = { text = primary, subText = secondary, index = index }
  end

  chooser = hs.chooser.new(function(choice)
    chooser = nil
    callback(choice and candidates[choice.index] or nil)
  end)
  chooser:placeholderText "Which Neovim should open this?"
  chooser:searchSubText(true)
  chooser:rows(math.min(#choices, 8))
  chooser:choices(choices)
  chooser:show()
end

--- Routes one url. Asynchronous: a link that needs a choice lands once the user makes it.
--- A link that could not reach Neovim is logged to the Hammerspoon console only —
--- it already opened in the browser, so there is nothing to interrupt anyone about.
---@param raw string?
function M.open(raw)
  router.route(raw, function(outcome)
    if outcome == "browser" and url.parse(raw) then
      print("octo_open: no Neovim took " .. raw .. ", opened in the browser")
    end
  end)
end

---@param opts table? { become_default_browser, hotkey, hosts, terminal_bundle, browser_bundle, chooser, herdr_session }
function M.setup(opts)
  opts = opts or {}

  M.browser_bundle = opts.browser_bundle or M.browser_bundle
  M.terminal_bundle = opts.terminal_bundle or M.terminal_bundle
  if opts.hosts then
    url.hosts = opts.hosts
  end
  if opts.herdr_session then
    herdr.session_name = opts.herdr_session
  end

  router.browser = open_in_browser
  router.activate = activate_terminal
  -- `chooser = false` keeps the old behaviour: the newest matching instance wins silently.
  router.choose = opts.chooser ~= false and choose_instance or nil

  hs.urlevent.httpCallback = function(_, _, _, full_url)
    M.open(full_url)
  end

  -- Try a link without handing over the default browser first: copy it, then press the hotkey.
  -- Pass `hotkey = false` to bind nothing.
  local hotkey = opts.hotkey
  if hotkey == nil then
    hotkey = { mods = { "ctrl", "shift" }, key = "O" }
  end
  if hotkey then
    hs.hotkey.bind(hotkey.mods, hotkey.key, function()
      M.open(hs.pasteboard.getContents())
    end)
  end

  if opts.become_default_browser then
    hs.urlevent.setDefaultHandler "http"
  end

  return M
end

return M
