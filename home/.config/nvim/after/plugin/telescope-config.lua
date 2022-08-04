local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local telescope = require('telescope')

telescope.load_extension('projects')

-- ----------------------------------------------------------------------------
-- Setup
-- ----------------------------------------------------------------------------
telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    entry_prefix = " ",
    file_ignore_patterns = {
      "./node_modules/*",
      "node_modules",
      "^node_modules/*",
      "node_modules/*",
      "public/packs/*",
      "doc/*",
      "log/*",
      "dist/*",
      ".yardoc/*",
      "tmp/*",
      "deps/*",
      "coverage/*",
      "webclient/node_modules/*",
      "client/node_modules/*",
      "app/build/*",
      "storage/*",
      ".git/*",
      ".svn/*",
      ".hg/*",
      ".jpeg",
      ".jpg",
      ".png",
      ".svg"
    },
    layout_strategy = 'bottom_pane',
    sorting_strategy = 'ascending',
    layout_config = { },
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    preview = false,
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    winblend = 10,
    mappings = {
      i = {
        ["<Esc>"] = actions.close,
        ['<C-x>'] = actions.file_split,
        ['<Tab>'] = action_layout.toggle_preview,
        ['<C-y>'] = actions.preview_scrolling_up,
        ['<C-e>'] = actions.preview_scrolling_down,
        ['<PageUp>'] = actions.preview_scrolling_up,
        ['<PageDown>'] = actions.preview_scrolling_down,
      },
    },
    pickers = {
      find_files = {
        hidden = true
      }
    }
  }
})

vim.cmd [[cabbrev t Telescope]]
