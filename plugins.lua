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

 local plugins = {
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
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  }, -- Adds :Telescope command replacement for ctrl-p
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },-- Faster telescope fuzzy search
  'tpope/vim-vinegar', -- Type - and go to nerdtree
  'kyazdani42/nvim-web-devicons', -- Adds icons to nvim-tree
  'kyazdani42/nvim-tree.lua', -- File explorer

   -- Lua
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        show_hidden = true,
        detection_methods = { "pattern" },
        patterns = { ".git" }
      }
    end
  }, -- Project management and rooter
  'justinmk/vim-gtfo', -- TOUSE: opens a file opener on the file opened on vim typing 'gof'
  'matbme/JABS.nvim',  -- Browse between buffers

  -- Code editing
  'junegunn/vim-easy-align', -- Press Enter and character to align multiple lines
  {
    'aznhe21/hop.nvim',
    branch = 'fix-some-bugs',
    config = function()
      require'hop'.setup()
    end
  }, -- Adds hop motion for jumping between words
  'scrooloose/nerdcommenter', -- Comment and uncomment with <leader>ci
  'RRethy/nvim-treesitter-endwise', -- Adds automatic end for if, do, class in Ruby, Elixir
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
  { 'terryma/vim-multiple-cursors', commit = '13232e4b544775cf2b039571537b0e630406f801' }, -- Allows to use multiple cursors
  {
    'lewis6991/gitsigns.nvim',
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
  'christoomey/vim-tmux-navigator', -- For moving between vim and tmux panes
  'KabbAmine/vCoolor.vim', -- Adds color selector for CSS
  'MattesGroeger/vim-bookmarks', -- Allows to bookmark lines to come back
  'kristijanhusak/vim-carbon-now-sh', -- create snipper of code
  'dhruvasagar/vim-table-mode', -- Allows to edit tables with orgmode
  {
    'nvim-orgmode/orgmode',
    config = function()
      require('orgmode').setup{}
    end
  }, -- Add org mode for nvim
  {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup()
    end,
  }, -- Quicker line search for neovim
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function ()
      require"octo".setup({ssh_aliases = {["github.com-cratebind"] = "github.com"}}
      )
    end
  }, -- UI for Github
  'ThePrimeagen/harpoon', -- Move between most used files

   -- Terminal
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup {
        shell = '/Users/juanhinojo/.fig/bin/figterm -- fish',
      }
    end
  }, -- Toggles between terminal and vim

   -- NEOVIM configuration
  'nvim-lua/plenary.nvim',
  'b0o/mapx.nvim', -- Better key mappings on LUA

   -- Colorschemes
  'zaldih/themery.nvim', -- Theme toggler
  'FrenzyExists/aquarium-vim', -- Aquarium colorscheme i mostly use
  { 'rose-pine/neovim', name = 'rose-pine' }, -- Rose pine colorscheme

    -- Treesitter for better syntax highlighting
  -- and navigating inside the syntax tree
  { 'nvim-treesitter/nvim-treesitter' }, -- Treesitter for syntax highlighting in neovim
  { 'nvim-treesitter/nvim-treesitter-textobjects' }, -- Allows to cic (change around class) cam (change around method)
  { 'nvim-treesitter/nvim-treesitter-context' }, -- Set sticky scrolling context
  { 'RRethy/nvim-treesitter-textsubjects' }, -- Select context visually with , ; and i;
  { 'HiPhish/rainbow-delimiters.nvim' }, -- Adds rainbow colors to delimiters

  -- Autocompletion
  'neovim/nvim-lspconfig', -- Adds LSP support for Neovim
  'mfussenegger/nvim-lint', -- Adds linting support for neovim
  {
    'nvimdev/lspsaga.nvim',
    dependencies = { 'nvim-lspconfig' }
  }, -- Adds LSP displays UI for LSP actions
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async'
  },
  'hrsh7th/nvim-cmp', -- Adds completion for nvim
  'hrsh7th/cmp-nvim-lsp', -- Adds LSP support to cmp
  'hrsh7th/cmp-nvim-lua', -- Adds lua completion for cmp
  'hrsh7th/cmp-path', -- Adds Paths automatically to cmp
  'hrsh7th/cmp-buffer', -- Adds LSP autocompletion for buffers
  'onsails/lspkind-nvim', -- Adds LSP pictograms like VSCode to autocomplete
  {
    "williamboman/mason.nvim",
  }, -- Adds lsp installer for neovim
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' }
  }, -- Snippets engine for Lua, compatible with VSCode
  'saadparwaiz1/cmp_luasnip', -- Adds lua snippets to cmp

   -- AI
  {
  "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    } -- Integrate ChatGPT
  },
  'github/copilot.vim' -- Enables copilot for vim
}

local opts = {}

require("lazy").setup(plugins, opts)
