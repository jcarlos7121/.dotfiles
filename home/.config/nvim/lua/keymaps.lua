-- Attempt to require 'mapx' and 'nvim-tmux-navigation'
local status_mapx, mapx = pcall(require, 'mapx')
local status_tmux_nav, tmux_nav = pcall(require, 'nvim-tmux-navigation')
-- Check if both libraries are successfully loaded
if not status_mapx then
  print("Error: 'mapx' library is not installed.")
  return
end
if not status_tmux_nav then
  print("Error: 'nvim-tmux-navigation' library is not installed.")
  return
end

require'mapx'.setup { global = "force" }
require('nvim-tmux-navigation')

vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- Camel Case
map("<S-W>", "<Plug>CamelCaseMotion_w")
map("<S-B>", "<Plug>CamelCaseMotion_b")
map("<S-E>", "<Plug>CamelCaseMotion_e")

-- Preview closed folds
-- nmap("<Tab>", ':lua require("ufo.preview"):peekFoldedLinesUnderCursor()<CR>', "silent")

-- Preview Buffers
map("<Leader>v", ":JABSOpen<CR>", "silent")

-- Debugging
map("mb", ":lua require('dap').toggle_breakpoint()<CR>", "silent")
map("mc", ":lua require('dap').continue()<CR>", "silent")
map("mo", ":lua require('dap').step_over()<CR>", "silent")
map("mi", ":lua require('dap').step_into()<CR>", "silent")

-- Octo mappings
map("<Leader>op", ":Octo pr ")
map("<Leader>ol", ":Octo pr search draft:false is:open review:required -author:jcarlos7121<CR>", "silent")
map("<Leader>om", ":Octo pr search is:open author:jcarlos7121<CR>", "silent")
map("<Leader>on", ":Octo pr create draft<CR>", "silent")
map("<Leader>ov", ":Octo pr checks<CR>", "silent")
map("<Leader>os", ":Octo review submit<CR>", "silent")

-- Telescope
map("<C-P>", "<cmd>Telescope find_files hidden=true<CR>")
map("<C-S>", "<cmd>Telescope live_grep<CR>")
map("<C-C>", "<cmd>Telescope lsp_dynamic_workspace_symbols symbols=class<CR>")
map("<C-T>", "<cmd>Telescope projects hidden=true<CR>")
map("<C-E>", "<cmd>Telescope emoji<CR>")

-- Harpoon
nmap("<C-q>", ":lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>", "silent")
nmap("<Leader>k", ":lua require('harpoon'):list():prev()<CR>", "silent")
nmap("<Leader>j", ":lua require('harpoon'):list():next()<CR>", "silent")

-- Tabs
map("<Leader>z", ":tab split<CR>")
map("<Leader>q", ":tabclose<CR>")

-- AI
map("<Leader>0", ":ChatGPT<CR>", 'silent')
map("<Leader>9", ":ChatGPTEditWithInstructions<CR>", 'silent')
map("<Leader>8", ":ChatGPTRun<Space>")
map("<Leader>7", ":ChatGPTActAs<Space>")
map("<Leader>5", ":AvanteChat<CR>", 'silent')
map("<Leader>4", ":AvanteAsk<CR>", 'silent')

-- Yank filepath
map("<Leader>p", ":let @+ = expand('%:p')<CR>", "silent")

-- Hop
nmap("S", "<cmd>HopPattern<CR>")
nmap("s", "<cmd>HopChar2<CR>")
map(",,w", "<cmd>HopWordAC<CR>")
map(",,b", "<cmd>HopWordBC<CR>")
map(",,k", "<cmd>HopLineBC<CR>")
map(",,j", "<cmd>HopLineAC<CR>")

-- ToggleTerm
map("<Leader>3", ":ToggleTerm size=15 direction=float<CR>", "silent")
-- map("<Leader>4", ":ToggleTerm size=15 direction=horizontal<CR>", "silent")

-- Vim mappings
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- Mappings for switching between vim and tmux panes
nnoremap("<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>")
nnoremap("<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>")
nnoremap("<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>")
nnoremap("<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>")

-- Nerdtree Finder and CtrlP
nnoremap("<F5>", ":NvimTreeFindFileToggle<CR>", "silent")

-- For editing init.liat
nmap("<leader>ei", ":e ~/.config/nvim/init.lua<CR>", "silent")
nmap("<leader>ev", ":e ~/.config/nvim/lua/options.lua<CR>", "silent")
nmap("<leader>ep", ":e ~/.config/nvim/lua/plugins.lua<CR>", "silent")
nmap("<leader>ek", ":e ~/.config/nvim/lua/keymaps.lua<CR>", "silent")
nmap("<leader>eo", ":e ~/.config/nvim/lua/overrides.lua<CR>", "silent")
nmap("<leader>el", ":Lazy<CR>", "silent")

-- Move multiple lines
noremap("<A-Down>", ":m .+1<CR>==")
noremap("<A-Up>", ":m .-2<CR>==")
noremap("<A-Down>", "<Esc>:m .+1<CR>==gi")
noremap("<A-Up>", "<Esc>:m .-2<CR>==gi")
noremap("<A-Down>", ":m '>+1<CR>gv=gv")
vnoremap("<A-Up>", " :m '<-2<CR>gv=gv")

-- Vim Rspec
map("<Leader>w", ":TestSuite<CR>", "silent")
map("<Leader>e", ":TestNearest<CR>", "silent")
map("<Leader>t", ":TestFile<CR>", "silent")

-- Easyalign
vmap("<Enter>", "<Plug>(EasyAlign)", "silent")

-- Removes search highlighting
map("<esc>", ":noh <CR>", "silent")

-- Git push with fugitive
nnoremap("<Leader>gp", ":Neogit push<CR>", "silent")
nnoremap("<Leader>gu", ":Neogit pull<CR>", "silent")
nnoremap("<Leader>gf", ":Neogit push --force<CR>", "silent")
nnoremap("<Leader>gi", ":Neogit kind=split<CR>", "silent")
nnoremap("<Leader>gl", ":Neogit log<CR>", "silent")
nnoremap("<Leader>gd", ":DiffviewOpen<CR>", "silent")
nnoremap("<Leader>gb", ":BlameToggle<CR>", "silent")
nnoremap("<Leader>gq", ":DiffviewClose<CR>", "silent")

-- Resize
nnoremap("<Leader>+", ':exe "resize " . (winheight(0) * 3/2)<CR>', "silent")
nnoremap("<Leader>-", ':exe "resize " . (winheight(0) * 2/3)<CR>', "silent")

vim.cmd[[
  " configuration for to exit Toggleterm
  tnoremap <Esc> <C-\><C-n>

  " configuration for Ack Vim Plugin
  cnoreabbrev Ack Ack!
  nnoremap <Leader>a :Ack!<Space>

  " Luasnip
  imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
  inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
  snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
  snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
]]
