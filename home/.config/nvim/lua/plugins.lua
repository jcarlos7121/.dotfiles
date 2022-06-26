-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Programming languages
  use 'dag/vim-fish'
  use 'elixir-lang/vim-elixir'
  use 'plasticboy/vim-markdown'
  use 'kchmck/vim-coffee-script'

  -- Commands
  use 'danro/rename.vim' -- :Rename filename
  use 'mileszs/ack.vim' -- :Ack to find word appearances on project
  use 'tpope/vim-bundler' -- :Bundle command
  use 'tpope/vim-dispatch' -- :Dispatch command
  use 'tpope/vim-fugitive' -- Adds git commits :Gbranch :Gblame, and others
  use 'tpope/vim-rails' -- Adds :Rails command
  use 'tpope/vim-rbenv' -- Adds :Rbenv command
  use 'tpope/vim-rake' -- Adds :Rake command
  use 'ain/vim-capistrano' -- Adds :Cap command
  use 'mattreduce/vim-mix' -- Adds :Mix elixir command
  use 'rizzatti/dash.vim' -- Adds :Dash command to search on Dash docs
  use 'adelarsq/vim-matchit' --TOUSE: % to match closing tag on xml/html

  -- File search
  use 'kien/ctrlp.vim'
  use 'tpope/vim-vinegar' -- Type - and go to nerdtree
  use 'ivalkeen/vim-ctrlp-tjump' -- TOUSE: Be able to jump to ctags declarations
  use 'jasoncodes/ctrlp-modified.vim' -- TOUSE: Use ctrl-p to display ONLY modified git-tracked files
  use 'scrooloose/nerdtree' -- Filesearcher File tree
  use 'airblade/vim-rooter' -- Keeps the root of ctrl-p and nerdtree to the root .gitignore
  use 'justinmk/vim-gtfo' -- TOUSE: opens a file opener on the file opened on vim
  use { 'iurifq/ctrlp-rails.vim', after = 'kien/ctrlp.vim' }

  -- Code editing
  use 'junegunn/vim-easy-align' -- Press Enter and character to align multiple lines
  use 'easymotion/vim-easymotion' -- use double leader key and w or up and down to move
  use 'scrooloose/nerdcommenter' -- Comment and uncomment with <leader>ci
  use 'tpope/vim-endwise' -- Automatically adds end word whenever def, or each opens
  use 'tpope/vim-ragtag' -- Adds autoclose for things like <% %> and <%= %>
  use 'kana/vim-smartinput' -- Automatically closes ([{}])
  use 'tpope/vim-surround' -- Adds mechanigs for surrownding words for example: csw)
  use 'ap/vim-css-color' -- Previews color on CSS while editing
  use 'MattesGroeger/vim-bookmarks' -- Allows to bookmark lines to come back
  use 'ntpeters/vim-better-whitespace' -- Displays whitespaces and strips them on save
  use 'jgdavey/vim-blockle' -- Allows to toggle between do end and { }
  use 'bkad/CamelCaseMotion' -- Allows you to move word by word

  -- UI Utilities
  --use 'bling/vim-airline'
  --use 'vim-airline/vim-airline-themes'
  use 'bling/vim-bufferline'
  use 'yggdroot/indentline' -- displays identation lines
  use { 'airblade/vim-gitgutter', commit = "faa1e953deae2da2b0df45f71a8ce8d931766c28" } -- displays which lines where added, modified, deleted
  use { 'terryma/vim-multiple-cursors', commit = "13232e4b544775cf2b039571537b0e630406f801" } -- Allows to use multiple cursors, not working

  -- Utilities
  use 'thoughtbot/vim-rspec' -- Adds leader commands for automatically running Rspec Tests
  use 'christoomey/vim-tmux-navigator' -- For moving between vim and tmux panes
  use 'KabbAmine/vCoolor.vim' -- Adds color selector for CSS
  use 'ervandew/supertab' -- Use tab for all completion suggestions (USE WITH CAUTION)

  -- Terminal
  use {"akinsho/toggleterm.nvim", tag = 'v1.*', config = function()
    require("toggleterm").setup()
  end}

  -- NEOVIM configuration
  use 'nvim-lua/plenary.nvim'
  use 'b0o/mapx.nvim' -- Better key mappings on LUA

  -- Colorschemes
  use 'frenzyexists/aquarium-vim'
  use 'cocopon/iceberg.vim'
  use 'stillwwater/vim-nebula'
  use 'w0ng/vim-hybrid'
  use 'flazz/vim-colorschemes'

  -- Autocompletion
  use 'neovim/nvim-lspconfig'
  use 'tami5/lspsaga.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'onsails/lspkind-nvim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
      {
        'nvim-treesitter/playground',
        config = function ()
          vim.keymap.set('n', '<leader>tp', '<Cmd>TSPlaygroundToggle<CR>')
        end
      }
    },
    -- Config in after/plugin/treesitter.lua
  }

  use {
    'L3MON4D3/LuaSnip',
    requires = { 'rafamadriz/friendly-snippets' }
  }

  use { 'saadparwaiz1/cmp_luasnip' }
end)
