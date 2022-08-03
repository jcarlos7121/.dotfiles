-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim' -- Speedup startup time of plugins

  -- Languages
  use 'slim-template/vim-slim'
  use 'bfontaine/Brewfile.vim'

  -- Commands
  use 'danro/rename.vim' -- :Rename filename
  use 'mileszs/ack.vim' -- :Ack to find word appearances on project
  use 'tpope/vim-bundler' -- :Bundle command
  use 'tpope/vim-dispatch' -- :Dispatch command
  use 'jcarlos7121/vim-fugitive' -- Adds git commits :Gbranch :Gblame, and others and my own reset commands
  use 'tpope/vim-rails' -- Adds :Rails command
  use 'tpope/vim-rbenv' -- Adds :Rbenv command
  use 'tpope/vim-rake' -- Adds :Rake command
  use 'mattreduce/vim-mix' -- Adds :Mix elixir command
  use 'rizzatti/dash.vim' -- Adds :Dash command to search on Dash docs
  use 'adelarsq/vim-matchit' --% to match closing tag on xml/html

  -- File search
  --use 'ctrlpvim/ctrlp.vim' -- :CtrlP to search files

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }

  use 'tpope/vim-vinegar' -- Type - and go to nerdtree
  use 'scrooloose/nerdtree' -- Filesearcher File tree
  use 'flw-cn/vim-nerdtree-l-open-h-close'
  use 'Xuyuanp/nerdtree-git-plugin' -- Filesearcher Git display for files
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'

  use 'airblade/vim-rooter' -- Keeps the root of ctrl-p and nerdtree to the root .gitignore
  use 'justinmk/vim-gtfo' -- TOUSE: opens a file opener on the file opened on vim
  use 'matbme/JABS.nvim'  -- Browse between buffers

  -- Code editing
  use 'junegunn/vim-easy-align' -- Press Enter and character to align multiple lines
  use 'phaazon/hop.nvim'
  use 'scrooloose/nerdcommenter' -- Comment and uncomment with <leader>ci
  use 'tpope/vim-endwise' -- Automatically adds end word whenever def, or each opens
  use 'tpope/vim-ragtag' -- Adds autoclose for things like <% %> and <%= %>
  use 'kana/vim-smartinput' -- Automatically closes ([{}])
  use 'tpope/vim-surround' -- Adds mechanigs for surrownding words for example: csw)
  use { 'ntpeters/vim-better-whitespace', commit = 'c5afbe91d29c5e3be81d5125ddcdc276fd1f1322' } -- Displays whitespaces and strips them on save
  use 'jgdavey/vim-blockle' -- Allows to toggle between do end and { }
  use 'bkad/CamelCaseMotion' -- Allows you to move word by word

  -- UI Utilities
  use 'bling/vim-bufferline' -- Displays the buffer in the status bar
  use 'yggdroot/indentline' -- displays identation lines
  use { 'airblade/vim-gitgutter', commit = 'faa1e953deae2da2b0df45f71a8ce8d931766c28' } -- displays which lines where added, modified, deleted
  use { 'terryma/vim-multiple-cursors', commit = '13232e4b544775cf2b039571537b0e630406f801' } -- Allows to use multiple cursors
  --use 'ryanoasis/vim-devicons' -- Adds icons to files
  --use 'jcarlos7121/vim-colorscheme-icons' -- Adds icons color for devicons
  use 'ap/vim-css-color' -- Previews color on CSS while editing

  -- Utilities
  use 'thoughtbot/vim-rspec' -- Adds leader commands for automatically running Rspec Tests
  use 'christoomey/vim-tmux-navigator' -- For moving between vim and tmux panes
  use 'KabbAmine/vCoolor.vim' -- Adds color selector for CSS
  use 'MattesGroeger/vim-bookmarks' -- Allows to bookmark lines to come back
  use 'kristijanhusak/vim-carbon-now-sh'
  use 'dhruvasagar/vim-table-mode' -- Allows to edit tables with orgmode
  use {'nvim-orgmode/orgmode', config = function()
    require('orgmode').setup{}
  end
  }

  -- Terminal
  use {'akinsho/toggleterm.nvim', tag = 'v1.*', config = function()
    require('toggleterm').setup()
  end} -- Toggles between terminal and vim

  -- NEOVIM configuration
  use 'nvim-lua/plenary.nvim'
  use 'b0o/mapx.nvim' -- Better key mappings on LUA
  use 'nathom/filetype.nvim' -- Filetype speedup support for neovim
  use {
    'nacro90/numb.nvim',
    config = function()
      require('numb').setup()
    end,
  } -- Quicker line search for neovim

  -- Colorschemes
  use 'FrenzyExists/aquarium-vim'
  use 'jcarlos7121/iceberg.vim' -- My own modified iceberg color config
  use 'w0ng/vim-hybrid' -- Adds colors to vim for better readability on light scheme
  use {'shaunsingh/oxocarbon.nvim', run = './install.sh'}

  use {
    'mcchrish/zenbones.nvim',
    requires = 'rktjmp/lush.nvim'
  } -- Adds zenbones colorscheme

  -- Treesitter for better syntax highlighting
  -- and navigating inside the syntax tree
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' } -- Treesitter for syntax highlighting in neovim
  use { 'nvim-treesitter/nvim-treesitter-textobjects' }
  use { 'p00f/nvim-ts-rainbow' }
  use { 'RRethy/nvim-treesitter-textsubjects' }

  -- Autocompletion
  use 'neovim/nvim-lspconfig' -- Adds LSP support for Neovim
  use 'tami5/lspsaga.nvim' -- Adds LSP actions with lightweight UI
  use 'hrsh7th/nvim-cmp' -- Adds completion for nvim
  use 'hrsh7th/cmp-nvim-lsp' -- Adds LSP support to cmp
  use 'hrsh7th/cmp-nvim-lua' -- Adds lua completion for cmp
  use 'hrsh7th/cmp-path' -- Adds Paths automatically to cmp
  use 'hrsh7th/cmp-buffer' -- Adds LSP autocompletion for buffers
  use 'onsails/lspkind-nvim' -- Adds LSP pictograms like VSCode to autocomplete
  use 'github/copilot.vim' -- Enables copilot for vim
  use 'williamboman/nvim-lsp-installer' -- Adds LSP Installer to nvim

  use {
    'L3MON4D3/LuaSnip',
    requires = { 'rafamadriz/friendly-snippets' }
  } -- Snippets engine for Lua, compatible with VSCode

   use { 'saadparwaiz1/cmp_luasnip' } -- Adds lua snippets to cmp
end)
