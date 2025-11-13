return {
  "https://github.com/nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  event = 'VeryLazy',
  dependencies = {
    '3rd/image.nvim',
    "https://github.com/nvim-lua/plenary.nvim",
    {
      "https://github.com/ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup {
          show_hidden = true,
          detection_methods = { "pattern" },
          patterns = { ".git" }
        }
      end,
    },
    "xiyaowong/telescope-emoji.nvim",
    {
      "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    }
  },
  config = function()
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "projects")
    pcall(require("telescope").load_extension, "harpoon")

    local actions = require("telescope.actions")
    local action_layout = require("telescope.actions.layout")
    local telescope = require('telescope')
    local image_preview = require("utils.telescope-preview").setup()

    telescope.setup({
      extensions = {
        file_browser = { hijack_netrw = true },
      },
      defaults = {
        file_previewer = image_preview.file_previewer,
        buffer_previewer_maker = image_preview.buffer_previewer_maker,
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
          ".mp4",
          ".keep",
          ".woff2",
          ".woff",
          ".ttf"
        },
        layout_strategy = 'bottom_pane',
        sorting_strategy = 'ascending',
        layout_config = { },
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        preview = {
          hide_on_startup = true -- hide previewer when picker starts
        },
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
  end
}
