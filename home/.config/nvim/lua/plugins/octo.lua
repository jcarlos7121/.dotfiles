return {
  'jcarlos7121/octo.nvim',
  branch = 'stacked-prs-all',
  event = "VeryLazy",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
  },
  config = function()
    require("octo").setup({
      -- Hammerspoon is the system http handler and sends PR/issue links back
      -- into Octo, which would make "view in browser" a no-op. Naming Safari
      -- explicitly bypasses the handler, so this command still reaches the web.
      gh_env = {
        BROWSER = "open -b com.apple.Safari",
      },
      default_to_projects_v2 = true,
      -- Two-column PR and issue buffers: a main column with a metadata sidebar
      -- beside it (jcarlos7121/octo.nvim#26 and #27). Upstream default is
      -- "classic", the flat `Label: value` list.
      ui = {
        -- layout = "columns",
        sidebar_width = 0.5, -- a share of the window, so both columns are the same size
        min_main_width = 40, -- an even split halves the window: allow a smaller main column
        check_rows = 0, -- list every workflow instead of folding the rest into "+N more"
      },
    })

    -- pwntester/octo.nvim#1491 (2026-05-18) started concatenating
    -- review_thread_information and review_thread_comment onto
    -- update_pull_request_state without ever spreading them. GitHub rejects the
    -- whole document with `useAndDefineFragment`, so `:Octo pr close` and
    -- `:Octo pr reopen` fail -- they are the only consumers of that mutation.
    -- Still unfixed on master @37a4168 (2026-08-24); the #1520 follow-up only
    -- removed duplicate definitions, not unused ones.
    local mutations = require "octo.gh.mutations"
    local fragments = require "octo.gh.fragments"
    mutations.update_pull_request_state = mutations.update_pull_request_state
      :gsub(vim.pesc(fragments.review_thread_information), "", 1)
      :gsub(vim.pesc(fragments.review_thread_comment), "", 1)
  end
}
