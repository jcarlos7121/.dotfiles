local T = require "octo_open.tests.harness"
local herdr = require "octo_open.herdr"

-- Hammerspoon runs outside any herdr pane, so the session is always named explicitly.
herdr.session_name = "test"

--- Same located shape, different pane id.
local function vim_like(shape, pane_id)
  local copy = { pane_id = pane_id }
  for key, value in pairs(shape) do
    copy[key] = value
  end
  return copy
end

local function pane(id, tab, ws, cwd, pids)
  return { pane_id = id, tab_id = tab, workspace_id = ws, foreground_cwd = cwd, pids = pids }
end

-- pane selection ---------------------------------------------------------

T.test("picks the pane whose foreground process is the neovim instance", function()
  local wanted = pane("wW:p1", "wW:t1", "wW", "/code/rails", { 44903 })
  local panes = { pane("w12:p1", "w12:t1", "w12", "/code/rails", { 999 }), wanted }
  T.eq(herdr.pick_pane(panes, { 44904, 44903 }), wanted)
end)

T.test("refuses to name a pane that only shares the directory", function()
  -- Several neovim instances live in one repo, and detached ones live in no pane at
  -- all. Matching on directory hands them all the same pane and mislabels every row.
  local same_dir = pane("w19:pE", "w19:t1", "w19", "/code/rails", { 63543 })
  T.eq(herdr.pick_pane({ same_dir }, { 44904, 44903 }), nil)
end)

T.test("gives up when nothing matches", function()
  T.eq(herdr.pick_pane({ pane("wW:p1", "wW:t1", "wW", "/other", { 111 }) }, { 44904 }), nil)
  T.eq(herdr.pick_pane({}, { 44904 }), nil)
end)

T.test("focuses the workspace before the tab", function()
  T.eq(herdr.focus_commands { workspace_id = "w12", tab_id = "w12:t1" }, {
    { "herdr", "--session", "test", "workspace", "focus", "w12" },
    { "herdr", "--session", "test", "tab", "focus", "w12:t1" },
  })
end)

-- reading panes and workspaces from the cli ------------------------------

local PANE_LIST = {
  result = {
    panes = {
      {
        pane_id = "wW:p1",
        tab_id = "wW:t1",
        workspace_id = "wW",
        foreground_cwd = "/code/rails",
        cwd = "/home",
        terminal_title_stripped = "v ~",
      },
      {
        pane_id = "w12:p1",
        tab_id = "w12:t1",
        workspace_id = "w12",
        foreground_cwd = "/code/octo",
        cwd = "/code/octo",
        terminal_title_stripped = "octo.nvim stack PR visibility",
      },
    },
  },
}

local PROCESS_INFO = {
  ["wW:p1"] = {
    result = {
      process_info = {
        shell_pid = 2844,
        foreground_process_group_id = 44903,
        foreground_processes = { { pid = 44903 } },
      },
    },
  },
  ["w12:p1"] = {
    result = { process_info = { foreground_process_group_id = 700, foreground_processes = { { pid = 700 }, { pid = 701 } } } },
  },
}

local WORKSPACE_LIST = {
  result = {
    workspaces = {
      { workspace_id = "wW", label = "Embryology", number = 1 },
      { workspace_id = "w12", label = "Calendar View", number = 2 },
    },
  },
}

local function stub_cli()
  -- The stub answers with the command line itself and decode() reads it back.
  -- Remembering only the last argv would not survive capture_all, where several
  -- answers come back at once and each has to be told apart from the others.
  herdr.system = {
    capture = function(argv)
      return table.concat(argv, " ")
    end,
    capture_all = function(argvs)
      local answers = {}
      for index, argv in ipairs(argvs) do
        answers[index] = table.concat(argv, " ")
      end
      return answers
    end,
  }
  herdr.json = {
    decode = function(command)
      if command:find "pane list" then
        return PANE_LIST
      elseif command:find "workspace list" then
        return WORKSPACE_LIST
      end
      return PROCESS_INFO[command:match "%-%-pane (%S+)"]
    end,
  }
end

T.test("reads panes with their pids and titles from the herdr cli", function()
  local restore_system, restore_json = herdr.system, herdr.json
  stub_cli()
  local panes = herdr.panes()
  herdr.system, herdr.json = restore_system, restore_json

  T.eq(#panes, 2)
  T.eq(panes[1].pane_id, "wW:p1")
  T.eq(panes[1].foreground_cwd, "/code/rails")
  T.eq(panes[1].title, "v ~")
  T.eq(panes[1].pids, { 2844, 44903, 44903 })
  T.eq(panes[2].pids, { 700, 700, 701 })
end)

T.test("returns no panes when herdr is not running", function()
  local restore = herdr.system
  herdr.system = {
    capture = function()
      return nil
    end,
  }
  local panes = herdr.panes()
  herdr.system = restore
  T.eq(panes, {})
end)

T.test("maps workspace ids to their label and number", function()
  local restore_system, restore_json = herdr.system, herdr.json
  stub_cli()
  local workspaces = herdr.workspaces()
  herdr.system, herdr.json = restore_system, restore_json

  T.eq(workspaces.wW, { label = "Embryology", number = 1 })
  T.eq(workspaces.w12, { label = "Calendar View", number = 2 })
end)

T.test("returns no workspaces when herdr is not running", function()
  local restore = herdr.system
  herdr.system = {
    capture = function()
      return nil
    end,
  }
  local workspaces = herdr.workspaces()
  herdr.system = restore
  T.eq(workspaces, {})
end)

-- locating an instance ---------------------------------------------------

T.test("locates the workspace and tab hosting an instance", function()
  local panes = { pane("wW:p1", "wW:t1", "wW", "/code/rails", { 44903 }) }
  panes[1].title = "v ~"
  local workspaces = { wW = { label = "Embryology", number = 1 } }
  T.eq(herdr.locate(panes, workspaces, { pid = 44904, ppid = 44903, cwd = "/code/rails" }), {
    pane_id = "wW:p1",
    tab_id = "wW:t1",
    workspace_id = "wW",
    workspace_label = "Embryology",
    workspace_number = 1,
    title = "v ~",
  })
end)

T.test("locates nothing when no pane hosts the instance", function()
  T.eq(herdr.locate({}, {}, { pid = 1, ppid = 2, cwd = "/code" }), nil)
end)

T.test("locates nothing for an instance running outside every pane", function()
  local elsewhere = pane("w19:pE", "w19:t1", "w19", "/code/rails", { 63543 })
  T.eq(herdr.locate({ elsewhere }, {}, { pid = 42147, ppid = 42133, cwd = "/code/rails" }), nil)
end)

T.test("keeps unlocated instances of one directory distinct from each other", function()
  local first = herdr.describe(nil, { pid = 42147, cwd = "/code/rails" })
  local second = herdr.describe(nil, { pid = 85347, cwd = "/code/rails" })
  T.eq(first, "Neovim 42147")
  T.eq(second, "Neovim 85347")
end)

-- describing an instance for the picker ----------------------------------

T.test("leads with the workspace, then the pane title", function()
  local primary, secondary = herdr.describe(
    { workspace_number = 2, workspace_label = "Calendar View", title = "nvim", pane_id = "w12:p1" },
    { cwd = "/code/octo.nvim" }
  )
  T.eq(primary, "2 · Calendar View · nvim")
  T.eq(secondary, "w12:p1 · /code/octo.nvim")
end)

T.test("keeps two panes of one workspace apart", function()
  local left = herdr.describe(
    { workspace_number = 1, workspace_label = "Embryology", title = "v ~", pane_id = "wW:p1Y" },
    { cwd = "/code/rails" }
  )
  local right = herdr.describe(
    { workspace_number = 1, workspace_label = "Embryology", title = "v ~/D/f/r/master", pane_id = "wW:p28" },
    { cwd = "/code/rails" }
  )
  T.eq(left, "1 · Embryology · v ~")
  T.eq(right, "1 · Embryology · v ~/D/f/r/master")
end)

T.test("still separates two panes that share a workspace and a title", function()
  local shape = { workspace_number = 1, workspace_label = "Embryology", title = "v ~" }
  local _, left = herdr.describe(vim_like(shape, "wW:p1Y"), { cwd = "/code/rails" })
  local _, right = herdr.describe(vim_like(shape, "wW:p28"), { cwd = "/code/rails" })
  T.eq(left, "wW:p1Y · /code/rails")
  T.eq(right, "wW:p28 · /code/rails")
end)

T.test("shortens a home-relative path in the description", function()
  local home = os.getenv "HOME"
  local _, secondary = herdr.describe({ title = "nvim" }, { cwd = home .. "/code/x" })
  T.eq(secondary, "~/code/x")
end)

T.test("falls back to the pane id when herdr gives no label or title", function()
  local primary, secondary = herdr.describe({ pane_id = "w13:p1" }, { cwd = "/x" })
  T.eq(primary, "w13:p1")
  T.eq(secondary, "w13:p1 · /x")
end)

T.test("still describes an instance that herdr knows nothing about", function()
  local primary, secondary = herdr.describe(nil, { pid = 44904, cwd = "/x" })
  T.eq(primary, "Neovim 44904")
  T.eq(secondary, "/x")
end)

-- focusing ---------------------------------------------------------------

T.test("runs the focus commands for the matching pane", function()
  local restore_system, restore_json = herdr.system, herdr.json
  stub_cli()
  local outer_capture = herdr.system.capture
  local ran = {}
  herdr.system = {
    capture = function(argv)
      if argv[#argv - 1] == "focus" then
        ran[#ran + 1] = argv
        return ""
      end
      return outer_capture(argv)
    end,
    -- panes() batches its process-info calls; keep the stub's version.
    capture_all = herdr.system.capture_all,
  }
  local ok = herdr.focus { pid = 44904, ppid = 44903, cwd = "/code/rails" }
  herdr.system, herdr.json = restore_system, restore_json

  T.eq(ok, true)
  T.eq(ran, {
    { "herdr", "--session", "test", "workspace", "focus", "wW" },
    { "herdr", "--session", "test", "tab", "focus", "wW:t1" },
  })
end)

T.test("reports no focus when no pane hosts the instance", function()
  local restore_system, restore_json = herdr.system, herdr.json
  stub_cli()
  local ok = herdr.focus { pid = 5, ppid = 6, cwd = "/nowhere" }
  herdr.system, herdr.json = restore_system, restore_json
  T.eq(ok, false)
end)

-- naming the session ----------------------------------------------------
-- Hammerspoon is not inside a herdr pane, so HERDR_SESSION is absent and the CLI
-- would talk to the wrong socket without an explicit --session.

T.test("reads the session name out of a session socket path", function()
  T.eq(herdr.session_from_paths { "/Users/me/.config/herdr/sessions/filial/herdr.sock" }, "filial")
end)

T.test("has no session name when none is on disk", function()
  T.eq(herdr.session_from_paths {}, nil)
end)

T.test("puts the session flag ahead of the subcommand", function()
  T.eq(herdr.argv("pane", "list"), { "herdr", "--session", "test", "pane", "list" })
end)

T.test("omits the session flag when no session can be found", function()
  local restore_name, restore_system = herdr.session_name, herdr.system
  herdr.session_name = nil
  herdr.system = {
    glob = function()
      return {}
    end,
  }
  local argv = herdr.argv("pane", "list")
  herdr.session_name, herdr.system = restore_name, restore_system
  T.eq(argv, { "herdr", "pane", "list" })
end)

T.test("discovers the session from disk when not configured", function()
  local restore_name, restore_system = herdr.session_name, herdr.system
  herdr.session_name = nil
  herdr.system = {
    glob = function()
      return { (os.getenv "HOME") .. "/.config/herdr/sessions/filial/herdr.sock" }
    end,
  }
  local argv = herdr.argv("pane", "list")
  herdr.session_name, herdr.system = restore_name, restore_system
  T.eq(argv, { "herdr", "--session", "filial", "pane", "list" })
end)

-- matching through the ancestry ------------------------------------------

T.test("matches a pane through the shell several processes up", function()
  local shell_pane = pane("wW:p1Y", "wW:t1", "wW", "/code/rails", { 2844 })
  local other = pane("w19:p1", "w19:t1", "w19", "/code/rails", { 2848 })
  -- the instance's own pids match nothing; its pane's shell is the fourth link
  T.eq(herdr.pick_pane({ other, shell_pane }, { 42147, 42133, 2938, 2844 }), shell_pane)
end)

T.test("prefers the nearest ancestor when both would match", function()
  local near = pane("w1X:p1", "w1X:t1", "w1X", "/code", { 42133 })
  local far = pane("wW:p1Y", "wW:t1", "wW", "/code", { 2844 })
  T.eq(herdr.pick_pane({ far, near }, { 42147, 42133, 2938, 2844 }), near)
end)

T.test("treats an ancestor shared by several panes as no evidence", function()
  -- every pane descends from the herdr process, so that pid identifies nothing
  local first = pane("wW:p1Y", "wW:t1", "wW", "/code", { 2842 })
  local second = pane("w19:p1", "w19:t1", "w19", "/code", { 2842 })
  T.eq(herdr.pick_pane({ first, second }, { 42147, 2842 }), nil)
end)

T.report()
