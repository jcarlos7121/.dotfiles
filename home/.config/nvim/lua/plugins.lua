vim.g.package_home = vim.fn.stdpath("data") .. "/site/pack/packer/"
local packer_install_dir = vim.g.package_home .. "/opt/packer.nvim"

local plug_url_format = ""
if vim.g.is_linux then
  plug_url_format = "https://hub.fastgit.xyz/%s"
else
  plug_url_format = "https://github.com/%s"
end

local packer_repo = string.format(plug_url_format, "wbthomason/packer.nvim")
local install_cmd = string.format("10split |term git clone --depth=1 %s %s", packer_repo, packer_install_dir)

-- Auto-install packer in case it hasn't been installed.
if vim.fn.glob(packer_install_dir) == "" then
  vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})
  vim.cmd(install_cmd)
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'bling/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'dag/vim-fish'
  use 'danro/rename.vim'
  use 'adelarsq/vim-matchit'
  use 'elixir-lang/vim-elixir'
  use 'godlygeek/tabular'
  use 'junegunn/vim-easy-align'
  use 'easymotion/vim-easymotion'
  use 'ivalkeen/vim-ctrlp-tjump'
  use 'jasoncodes/ctrlp-modified.vim'
  use 'justinmk/vim-gtfo'
  use 'kana/vim-smartinput'
  use 'kchmck/vim-coffee-script'
  use 'kien/ctrlp.vim'
  use 'plasticboy/vim-markdown'
  use 'mileszs/ack.vim'
  use 'honza/vim-snippets'
  use 'scrooloose/nerdcommenter'
  use 'sjl/gundo.vim'
  use 'tpope/vim-bundler'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-endwise'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-ragtag'
  use 'tpope/vim-rails'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'
  use 'thoughtbot/vim-rspec'
  use 'vim-ruby/vim-ruby'
  use 'w0ng/vim-hybrid'
  use 'rodjek/vim-puppet'
  use 'bling/vim-bufferline'
  use 'Valloric/YouCompleteMe'
  use 'Shougo/neosnippet'
  use 'Shougo/neosnippet-snippets'
  use 'tpope/vim-rbenv'
  use 'scrooloose/nerdtree'
  use 'flazz/vim-colorschemes'
  use 'airblade/vim-rooter'
  use 'pangloss/vim-javascript'
  use 'briancollins/vim-jst'
  use 'ngmy/vim-rubocop'
  use 'ap/vim-css-color'
  use 'MattesGroeger/vim-bookmarks'
  use 'chrisbra/NrrwRgn'
  use 'danchoi/ri.vim'
  use 'mtscout6/vim-cjsx'
  use 'ntpeters/vim-better-whitespace'
  use 'tpope/vim-rake'
  use 'jgdavey/vim-blockle'
  use 'bkad/CamelCaseMotion'
  use 'ain/vim-capistrano'
  use 'BjRo/vim-extest'
  use 'mattreduce/vim-mix'
  use 'christoomey/vim-tmux-navigator'
  use 'isRuslan/vim-es6'
  use 'rizzatti/dash.vim'
  use 'KabbAmine/vCoolor.vim'
  use 'wakatime/vim-wakatime'
  use 'SirVer/ultisnips'
  use 'ervandew/supertab'
  use 'stillwwater/vim-nebula'
  use 'grvcoelho/vim-javascript-snippets'

  use {"akinsho/toggleterm.nvim", tag = 'v1.*', config = function()
    require("toggleterm").setup()
  end}
end)