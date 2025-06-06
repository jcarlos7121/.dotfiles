local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorschemes
  require 'plugins.themery', -- Themery for colorschemes
  'FrenzyExists/aquarium-vim', -- Aquarium colorscheme i mostly use
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require 'nordic' .load()
      require 'nordic'.setup {
        swap_backgrounds = true
      }
    end
  },
  {
    'olivercederborg/poimandres.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('poimandres').setup {
        -- leave this setup function empty for default config
        -- or refer to the configuration section
        -- for configuration options
      }
    end,
  }, -- Poimandres
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim"
  },
  require 'plugins.rosepine', -- Rosepine colorscheme

  -- Commands
  'danro/rename.vim', -- :Rename filename
  'mileszs/ack.vim', -- :Ack to find word appearances on project
  'tpope/vim-dispatch', -- :Dispatch command
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
    },
    config = function()
      require('neogit').setup {
        integrations = {
          diffview = false
        }
      }
    end
  }, -- Adds :Neogit command
  {
    {
      "FabijanZulj/blame.nvim",
      lazy = false,
      config = function()
        require('blame').setup {}
      end,
      opts = {
        blame_options = { '-w' },
      },
    },
  }, -- Adds :Blame command
  'tpope/vim-rails', -- Adds :Rails command
  'tpope/vim-rbenv', -- Adds :Rbenv command
  'tpope/vim-rake', -- Adds :Rake command
  'mattreduce/vim-mix', -- Adds :Mix elixir command
  'rizzatti/dash.vim', -- Adds :Dash command to search on Dash docs
  'adelarsq/vim-matchit', --% to match closing tag on xml/html

  -- FileSearch
  'tpope/vim-vinegar', -- Type - and go to folder up
  'kyazdani42/nvim-web-devicons', -- Adds icons to nvim-tree
  'justinmk/vim-gtfo', -- TOUSE: opens a file opener on the file opened on vim typing 'gof'
  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  require 'plugins.nvim-tree', -- Adds nvim-tree for file navigation
  require 'plugins.image-preview', -- Adds image preview for nvim
  require 'plugins.telescope', -- Adds telescope for file search

  -- Code editing
  'junegunn/vim-easy-align', -- Press Enter and character to align multiple lines
  {
    'akinsho/git-conflict.nvim',
    event = "VeryLazy",
    version = "*",
    config = true
  }, -- Resolve git conflicts from within nvim
  {
    'aznhe21/hop.nvim',
    branch = 'fix-some-bugs',
    config = function()
      require'hop'.setup()
    end
  }, -- Adds hop motion for jumping between words
  { 'numToStr/Comment.nvim' }, -- Comment and uncomment with gc
  'tpope/vim-ragtag', -- Adds autoclose for things like <% %> and <%= %>
  'kana/vim-smartinput', -- Automatically closes ([{}])
  'tpope/vim-surround', -- Adds mechanigs for surrownding words for example: csw)
  {
    "cappyzawa/trim.nvim",
    config = function()
      require("trim").setup({
        patterns = {
          [[%s/\(\n\n\)\n\+/\1/]]
        }
      })
    end
  }, -- replace multiple blank lines with a single line
  'jgdavey/vim-blockle', -- Allows to toggle between do end and { }
  'bkad/CamelCaseMotion', -- Allows you to move word by word
  'mg979/vim-visual-multi', -- Allows to select multiple lines with Ctrl + N
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup { }
    end
  }, -- Adds colors to todo comments

  -- UI Utilities
  'yggdroot/indentline', -- displays identation lines
  {
    'lewis6991/gitsigns.nvim',
    event = "VeryLazy",
    config = function()
      require('gitsigns').setup()
    end
  }, -- Add Git visual symbols for changes in the file
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end
  },
  require 'plugins.lualine', -- Adds lualine for status line
  require 'plugins.noice', -- Adds noice for notifications and better UI

  -- Utilities
  'vim-test/vim-test', -- Adds leader commands for automatically running Rspec Tests
  { "alexghergh/nvim-tmux-navigation" }, -- Allows to navigate between tmux panes
  'MattesGroeger/vim-bookmarks', -- Allows to bookmark lines to come back
  {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup()
    end,
  }, -- Quicker line search for neovim
  {
    'pwntester/octo.nvim',
    event = "VeryLazy",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function ()
      require"octo".setup(
        {
          ssh_aliases = {["github.com-cratebind"] = "github.com"},
          suppress_missing_scope = {
            projects_v2 = true
          }
        }
      )
    end
  }, -- Github UI for nvim
  {
    'matbme/JABS.nvim',  -- Browse between buffers
    config = function()
      require 'jabs'.setup {
        position = 'center',
        border = 'single', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default shadow

        preview = {
          border = 'single' -- none, single, double, rounded, solid, shadow, (or an array or chars). Default double
        },

        keymap = {
          preview = "p", -- Jump to buffer. Default <cr>
          jump = "o" -- Jump to buffer. Default <cr>
        }
      }
    end
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
    end
  }, -- Move between most used files

   -- Terminal
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup {
        shell = '/Users/juanhinojo/.local/bin/qterm -- fish',
      }
    end
  }, -- Toggles between terminal and vim

  -- NEOVIM configuration
  'nvim-lua/plenary.nvim',
  'b0o/mapx.nvim', -- Better key mappings on LUA

  'HiPhish/rainbow-delimiters.nvim', -- Adds rainbow colors to delimiters

  require 'plugins.treesitter', -- Treesitter configurations

  -- Autocompletion and LSP
  require 'plugins.lsp_configurations',

  -- Debuggers
  require 'plugins.dap-debuggers',

  -- AI
  require 'plugins.chatgpt', -- Adds chatgpt for vim
  'github/copilot.vim', -- Enables copilot for vim
  require 'plugins.avante', -- Adds Avante for vim
  require 'plugins.mcphub' -- Adds MCPHub for vim
})
