local opt = vim.opt
opt.termguicolors = true

--vim.cmd [[colorscheme iceberg]]
vim.cmd [[
  colorscheme aquarium
  hi Normal guibg=#111111
  hi LineNr guibg=#111111
  hi PMenu guifg=#d0d0d0 guibg=#151515
  hi NormalFloat guifg=#d0d0d0 guibg=#151515
  hi VertSplit guibg=NONE guifg=#141414
]]

opt.tabstop=2
opt.shell = "/opt/homebrew/bin/fish"
opt.wrap = false
opt.number = true
opt.showcmd = true
opt.showmode = false -- Don't display -- INSERT -- in status line
opt.textwidth = 80
opt.cursorline = false
opt.scrolloff = 5
opt.sidescroll = 1
opt.sidescrolloff = 10
opt.formatoptions = "qcrn1"
opt.clipboard = { 'unnamed' }
opt.visualbell = false
opt.errorbells = false
opt.lazyredraw = true
opt.autoread = true
opt.autowrite = true
opt.ruler = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.shiftwidth = 2
opt.expandtab = true
opt.autochdir = true
opt.foldlevel = 2
opt.laststatus = 2
opt.showtabline = 0
opt.mmp = 5000

-- Treesitter folding
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- Disable nvim-tree folder icon
vim.g.nvim_tree_show_icons = {
  files = 1,
  git = 1,
  folder_arrows = 1,
  folders = 0
}

--Hybrid
--vim.cmd [[
  --colorscheme hybrid
  --set background=light
--]]

-- Highlight for GitGutter
vim.highlight.create('GitGutterAdd', {guifg='#009900'}, false)
vim.highlight.create('GitGutterChange', {guifg='#bbbb00'}, false)
vim.highlight.create('GitGutterDelete', {guifg='#b73434' }, false)

-- Highlight for search matches
vim.highlight.create('Search', {guibg='#3466b7', guifg=white}, false)

-- Highlight for rainbow brackets on treesitter
vim.highlight.create('rainbowcol1', {guifg='#f73e7f'}, false)

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*" },
  command = "GitGutter",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  command = "EnableStripWhitespaceOnSave",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.*" },
  command = "set noro",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*" },
  command = "set bufhidden=delete",
})

-- Bookmarks configuration
vim.g.bookmark_sign = '₪'
vim.g.bookmark_highlight_lines = 1

-- Vim rspec command
vim.g.rspec_command = "Dispatch rspec {spec}"

-- Silver searcher configuration
vim.g.ackprg = 'ag -S --nocolor --nogroup --column --ignore dist --ignore public/vite-test --ignore public/vite-dev --ignore public/packs-test --ignore public/assets --ignore public/packs --ignore tmp --ignore "./_build" --ignore coverage --ignore node_modules --ignore webclient/node_modules --ignore "./frontend/node_modules/*" --ignore "./frontend/tmp/*" --ignore "./app/build/*" --ignore="*.png" --ignore="*.jpg" --ignore="*.svg" --ignore="*.gz"'

vim.cmd [[source ~/.vim/config/ntfinder.vim]]
vim.cmd [[source ~/.vim/config/envcommands.vim]]

-- Configuration
vim.cmd[[
  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  match ErrorMsg '\s\+$'

  " Set ibeam on exit of vim
  augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver10-blinkoff0
  augroup END
]]
