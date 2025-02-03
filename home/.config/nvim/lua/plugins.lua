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
  'zaldih/themery.nvim', -- Theme toggler
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
  { 'rose-pine/neovim', name = 'rose-pine' }, -- Rose pine colorscheme

  -- Commands
  'danro/rename.vim', -- :Rename filename
  'mileszs/ack.vim', -- :Ack to find word appearances on project
  'tpope/vim-bundler', -- :Bundle command
  'tpope/vim-dispatch', -- :Dispatch command
  'jcarlos7121/vim-fugitive', -- Adds git commits :Gbranch :Gblame, and others and my own reset commands
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
  require 'plugins.yazi', -- Adds yazi for fuzzy search

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
  'bling/vim-bufferline', -- Displays the buffer in the status bar
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
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
  }, -- Minimalistic status line
  'stevearc/dressing.nvim', -- Gives a better UI for nvim select and inputs

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
  'matbme/JABS.nvim',  -- Browse between buffers
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

  -- Treesitter for better syntax highlighting
  -- and navigating inside the syntax tree
  { 'nvim-treesitter/nvim-treesitter' }, -- Treesitter for syntax highlighting in neovim
  { 'nvim-treesitter/nvim-treesitter-textobjects' }, -- Allows to cic (change around class) cam (change around method)
  { 'nvim-treesitter/nvim-treesitter-context' }, -- Set sticky scrolling context
  { 'RRethy/nvim-treesitter-textsubjects' }, -- Select context visually with , ; and i;
  { 'HiPhish/rainbow-delimiters.nvim' }, -- Adds rainbow colors to delimiters
  'RRethy/nvim-treesitter-endwise', -- Adds automatic end for if, do, class in Ruby, Elixir

  -- Autocompletion and LSP
  'neovim/nvim-lspconfig', -- Adds LSP support for Neovim
  'mfussenegger/nvim-lint', -- Adds linting support for neovim
  {
    'nvimdev/lspsaga.nvim',
    dependencies = { 'nvim-lspconfig' }
  }, -- Adds LSP displays UI for LSP actions
  -- {
  --   'kevinhwang91/nvim-ufo',
  --   dependencies = 'kevinhwang91/promise-async'
  -- }, -- Adds UFO for folding
  'hrsh7th/nvim-cmp', -- Adds completion for nvim
  'hrsh7th/cmp-nvim-lsp', -- Adds LSP support to cmp
  'hrsh7th/cmp-nvim-lua', -- Adds lua completion for cmp
  'hrsh7th/cmp-path', -- Adds Paths automatically to cmp
  'hrsh7th/cmp-buffer', -- Adds LSP autocompletion for buffers
  'onsails/lspkind-nvim', -- Adds LSP pictograms like VSCode to autocomplete
  {
    "petertriho/cmp-git",
    dependencies = { 'hrsh7th/nvim-cmp' },
    opts = {
        -- options go here
    },
    init = function()
        table.insert(require("cmp").get_config().sources, { name = "git" })
    end
  }, -- Adds git completion to nvim-cmp
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  }, -- Adds lsp installer for neovim
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' }
  }, -- Snippets engine for Lua, compatible with VSCode
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      require("typescript-tools").setup {
        settings = {
          complete_function_calls = true,
          include_completions_with_insert_text = true
        }
      }
    end
  }, -- Adds typescript tools for nvim
  'saadparwaiz1/cmp_luasnip', -- Adds lua snippets to cmp

  -- Debuggers
  {
    "mfussenegger/nvim-dap",
    dependencies = { "jcarlos7121/nvim-dap-ruby-minitest" },
    config = function()
      require('dap-ruby').setup()
    end
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {"mfussenegger/nvim-dap"}
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end
  },

  -- AI
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        edit_with_instructions = {
          keymaps = {
            close = "<ESC>",
          },
        },
        chat = {
          keymaps = {
            close = "<ESC>",
          },
        },
        openai_params = {
          model = "gpt-4o",
          max_tokens = 3000
        }
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  'github/copilot.vim', -- Enables copilot for vim
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
      provider = "claude",
      vendors = {
        deepseek = {
          __inherited_from = 'openai',
          endpoint = 'https://api.deepseek.com',
          model = 'deepseek-coder',
          api_key_name = 'DEEPSEEK_API_KEY',
        },
      },
      mappings = {
        ask = "<leader>4", -- ask
        edit = "<leader>3", -- edit
        refresh = "<leader>2", -- refresh
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
    opts = {
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        }
      }
    }
  }
})
