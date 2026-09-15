local T = require "octo_open.tests.harness"
local url = require "octo_open.url"

T.test("parses a pull request url", function()
  T.eq(url.parse "https://github.com/pwntester/octo.nvim/pull/1547", {
    host = "github.com",
    owner = "pwntester",
    repo = "octo.nvim",
    kind = "pull",
    number = "1547",
    canonical = "https://github.com/pwntester/octo.nvim/pull/1547",
  })
end)

T.test("parses an issue url", function()
  T.eq(url.parse "https://github.com/pwntester/octo.nvim/issues/42", {
    host = "github.com",
    owner = "pwntester",
    repo = "octo.nvim",
    kind = "issues",
    number = "42",
    canonical = "https://github.com/pwntester/octo.nvim/issues/42",
  })
end)

T.test("tolerates a trailing slash", function()
  T.eq(url.parse("https://github.com/o/r/pull/7/").canonical, "https://github.com/o/r/pull/7")
end)

T.test("strips a query string", function()
  T.eq(url.parse("https://github.com/o/r/pull/7?utm_source=slack").canonical, "https://github.com/o/r/pull/7")
end)

T.test("strips a comment anchor", function()
  T.eq(url.parse("https://github.com/o/r/issues/7#issuecomment-12345").canonical, "https://github.com/o/r/issues/7")
end)

T.test("rejects deeper pull request paths", function()
  T.eq(url.parse "https://github.com/o/r/pull/7/files", nil)
  T.eq(url.parse "https://github.com/o/r/pull/7/commits", nil)
end)

T.test("rejects discussions and releases", function()
  T.eq(url.parse "https://github.com/o/r/discussions/9", nil)
  T.eq(url.parse "https://github.com/o/r/releases/tag/v1.0.0", nil)
end)

T.test("rejects a repo url with no pull or issue", function()
  T.eq(url.parse "https://github.com/pwntester/octo.nvim", nil)
end)

T.test("rejects a non-numeric number", function()
  T.eq(url.parse "https://github.com/o/r/pull/abc", nil)
end)

T.test("rejects hosts that are not configured", function()
  T.eq(url.parse "https://gitlab.com/o/r/pull/7", nil)
  T.eq(url.parse "https://example.com/o/r/issues/7", nil)
end)

T.test("accepts a configured github enterprise host", function()
  local restore = url.hosts
  url.hosts = { "github.com", "github.acme.dev" }
  local parsed = url.parse "https://github.acme.dev/o/r/pull/7"
  url.hosts = restore
  T.eq(parsed.host, "github.acme.dev")
  T.eq(parsed.canonical, "https://github.acme.dev/o/r/pull/7")
end)

T.test("keeps dots and dashes in owner and repo names", function()
  local parsed = url.parse "https://github.com/my-org/some.repo-name/pull/3"
  T.eq(parsed.owner, "my-org")
  T.eq(parsed.repo, "some.repo-name")
end)

T.test("unwraps a slack redirect", function()
  T.eq(
    url.unwrap "https://slack-redir.net/link?url=https%3A%2F%2Fgithub.com%2Fo%2Fr%2Fpull%2F7",
    "https://github.com/o/r/pull/7"
  )
end)

T.test("leaves a plain url untouched when unwrapping", function()
  T.eq(url.unwrap "https://github.com/o/r/pull/7", "https://github.com/o/r/pull/7")
end)

T.test("parses a slack-wrapped pull request url", function()
  local parsed = url.parse "https://slack-redir.net/link?url=https%3A%2F%2Fgithub.com%2Fo%2Fr%2Fpull%2F7&v=3"
  T.eq(parsed.canonical, "https://github.com/o/r/pull/7")
end)

T.test("returns nil for nil or empty input", function()
  T.eq(url.parse(nil), nil)
  T.eq(url.parse "", nil)
end)

T.report()
