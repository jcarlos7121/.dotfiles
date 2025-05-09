local opt = vim.opt
opt.termguicolors = true

opt.tabstop=2
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
opt.autoread = true
opt.autowrite = true
opt.ruler = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.shiftwidth = 2
opt.expandtab = true
opt.autochdir = true
opt.laststatus = 3
opt.showtabline = 0
opt.mmp = 5000

-- Folding
-- vim.o.foldcolumn = '0' -- '0' is not bad
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = 2
-- vim.o.foldenable = false

-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- vim.keymap.set('n', 'zr', require('ufo').openAllFolds)
-- vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)

-- Disable nvim-tree folder icon
vim.g.nvim_tree_show_icons = {
  files = 1,
  git = 1,
  folder_arrows = 1,
  folders = 0
}

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.*" },
  command = "set noro",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    local ok_harpoon, harpoon = pcall(require, "harpoon")
    if ok_harpoon then
      harpoon:list():add()
    end

    local ok_lint, lint = pcall(require, "lint")
    if ok_lint then
      lint.try_lint()
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*" },
  command = "set bufhidden=delete",
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "wincmd =",
})

-- Bookmarks configuration
vim.g.bookmark_sign = '₪'
vim.g.bookmark_highlight_lines = 1

-- Silver searcher configuration
vim.g.ackprg = 'ag -S --nocolor --nogroup --column --ignore dist --ignore public/vite-test --ignore public/vite-dev --ignore public/packs-test --ignore public/assets --ignore public/packs --ignore tmp --ignore "./_build" --ignore coverage --ignore node_modules --ignore webclient/node_modules --ignore "./frontend/node_modules/*" --ignore "./frontend/tmp/*" --ignore "./app/build/*" --ignore="*.png" --ignore="*.jpg" --ignore="*.svg" --ignore="*.gz"'

vim.cmd [[source ~/.config/nvim/vimscript/envcommands.vim]]
