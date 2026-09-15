--- Recognizes the GitHub URLs that octo.nvim can open as a buffer.
--- Pure string handling: no Hammerspoon, no IO, so it runs under plain `lua` in tests.
local M = {}

--- Hosts whose PR/issue links are routed to Neovim. Add GitHub Enterprise hosts here.
M.hosts = { "github.com" }

--- The only two path kinds we claim; every other GitHub path falls through to the browser.
local KINDS = { pull = true, issues = true }

local function percent_decode(str)
  local decoded = str:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end)
  return decoded
end

--- Slack rewrites shared links as slack-redir.net/link?url=<percent-encoded>.
---@param raw string?
---@return string?
function M.unwrap(raw)
  if type(raw) ~= "string" then
    return nil
  end
  local inner = raw:match "^https?://slack%-redir%.net/link%?.-url=([^&]+)"
  if inner then
    return percent_decode(inner)
  end
  return raw
end

local function is_allowed_host(host)
  for _, allowed in ipairs(M.hosts) do
    if host == allowed then
      return true
    end
  end
  return false
end

---@param raw string?
---@return table? parsed { host, owner, repo, kind, number, canonical }
function M.parse(raw)
  local target = M.unwrap(raw)
  if not target or target == "" then
    return nil
  end

  target = target:gsub("#.*$", ""):gsub("%?.*$", ""):gsub("/+$", "")

  local host, owner, repo, kind, number = target:match "^https?://([^/]+)/([^/]+)/([^/]+)/([^/]+)/([^/]+)$"
  if not host or not is_allowed_host(host) or not KINDS[kind] or not number:match "^%d+$" then
    return nil
  end

  return {
    host = host,
    owner = owner,
    repo = repo,
    kind = kind,
    number = number,
    canonical = string.format("https://%s/%s/%s/%s/%s", host, owner, repo, kind, number),
  }
end

return M
