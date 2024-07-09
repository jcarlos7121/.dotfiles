require'mapx'.setup { global = "force" }

vim.g.mapleader = ","

vim.g.multi_cursor_next_key = '<C-d>'
vim.g.multi_cursor_prev_key = '<C-p>'
vim.g.multi_cursor_skip_key = '<C-x>'
vim.g.multi_cursor_quit_key = '<Esc>'

-- Camel Case
map("<S-W>", "<Plug>CamelCaseMotion_w")
map("<S-B>", "<Plug>CamelCaseMotion_b")
map("<S-E>", "<Plug>CamelCaseMotion_e")

-- Preview closed folds
nmap("<Tab>", ':lua require("ufo.preview"):peekFoldedLinesUnderCursor()<CR>', "silent")

-- Preview Buffers
map("<Leader>v", ":JABSOpen<CR>", "silent")

-- Debugging
map("mb", ":lua require('dap').toggle_breakpoint()<CR>", "silent")
map("mc", ":lua require('dap').continue()<CR>", "silent")
map("md", ":lua require('dap').step_over()<CR>", "silent")
map("mi", ":lua require('dap').step_into()<CR>", "silent")

-- Octo mappings
map("<Leader>op", ":Octo pr list<CR>", "silent")
map("<Leader>on", ":Octo pr create<CR>", "silent")
map("<Leader>od", ":Octo pr diff<CR>", "silent")
map("<Leader>os", ":Octo review submit<CR>", "silent")

-- Telescope
map("<C-P>", "<cmd>Telescope find_files hidden=true<CR>")
map("<C-S>", "<cmd>Telescope live_grep<CR>")
map("<C-C>", "<cmd>Telescope lsp_dynamic_workspace_symbols symbols=class<CR>")
map("<C-T>", "<cmd>Telescope projects hidden=true<CR>")
map("<C-E>", "<cmd>Telescope emoji<CR>")

-- Harpoon
map("<C-Q>", ':lua require("harpoon.ui").toggle_quick_menu()<CR>', 'silent')
map("<Leader>k", ':lua require("harpoon.ui").nav_next()<CR>', 'silent')
map("<Leader>j", ':lua require("harpoon.ui").nav_prev()<CR>', 'silent')

-- Tabs
map("<Leader>z", ":tab split<CR>")
map("<Leader>q", ":tabclose<CR>")

-- AI
map("<Leader>0", ":ChatGPT<CR>", 'silent')
map("<Leader>9", ":ChatGPTEditWithInstructions<CR>", 'silent')
map("<Leader>8", ":ChatGPTRun<Space>")
map("<Leader>7", ":ChatGPTActAs<Space>")

-- VCoolor
-- nmap("<leader>c", ":VCoolor<CR>")

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
map("<Leader>4", ":ToggleTerm size=15 direction=horizontal<CR>", "silent")

-- Carbon.sh integration
vnoremap("<F7>", ":CarbonNowSh<CR>", "silent")

-- Vim mappings
vmap("<Tab>", ":'<,'>><CR>", "silent")

-- Mappings for switching between vim and tmux panes
nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")

-- Nerdtree Finder and CtrlP
nnoremap("<F5>", ":NvimTreeFindFileToggle<CR>", "silent")

-- For editing init.liat
nmap("<leader>ei", ":e ~/.config/nvim/init.lua<CR>", "silent")
nmap("<leader>ev", ":e ~/.config/nvim/lua/options.lua<CR>", "silent")
nmap("<leader>ep", ":e ~/.config/nvim/lua/plugins.lua<CR>", "silent")
nmap("<leader>ek", ":e ~/.config/nvim/lua/keymaps.lua<CR>", "silent")

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
nnoremap("<Leader>gp", ":G push<CR>", "silent")
nnoremap("<Leader>gu", ":G pull<CR>", "silent")
nnoremap("<Leader>gf", ":G push --force<CR>", "silent")
nnoremap("<Leader>gi", ":Git<CR>", "silent")
nnoremap("<Leader>gl", ":Git log<CR>", "silent")

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
