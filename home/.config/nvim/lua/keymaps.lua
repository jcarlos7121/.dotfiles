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

-- CtrlP
map("<Leader>gm", ":CtrlPModified<CR>")
map("<Leader>gM", ":CtrlPBranch<CR>")
map("<Leader>z", ":tab split<CR>")
map("<Leader>q", ":tabclose<CR>")

-- Easymotion
nmap("s", "<Plug>(easymotion-overwin-f2)")

-- ToggleTerm

map("<Leader>3", ":ToggleTerm size=15 direction=float<CR>")
-- Vim mappings
vmap("<Tab>", ":'<,'>><CR>")

nnoremap("<C-J>", "<C-W><C-J>")
nnoremap("<C-K>", "<C-W><C-K>")
nnoremap("<C-L>", "<C-W><C-L>")
nnoremap("<C-H>", "<C-W><C-H>")

-- Nerdtree Finder and CtrlP
nnoremap("<F5>", ":call NTFinderP()<CR>")
nnoremap("<leader>.", ":CtrlPTag<cr>")

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
map("<Leader>w", ":call RunAllSpecs()<CR>")
map("<Leader>e", ":call RunNearestSpec()<CR>")
map("<Leader>t", ":call RunCurrentSpecFile()<CR>")

-- Easyalign
vmap("<Enter>", "<Plug>(EasyAlign)")
nmap("<Leader>a", "<Plug>(EasyAlign)")

-- Removes search highlighting
map("<esc>", ":noh <CR>", "silent")

-- Git push with fugitive
nnoremap("<Leader>gp", ":G push<CR>", "silent")
nnoremap("<Leader>gf", ":G push --force<CR>", "silent")
nnoremap("<Leader>gi", ":Git<CR>", "silent")
nnoremap("<Leader>gl", ":Git log<CR>", "silent")

vim.cmd[[
  " configuration for Toggleterm
  tnoremap <Esc> <C-\><C-n>

  " Luasnip
  imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
  inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
  snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
  snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

  "LSP saga exit configuration
  augroup lspsaga_filetypes
    autocmd!
    autocmd FileType LspsagaHover nnoremap <buffer><nowait><silent> <Esc> :q<cr>
    autocmd FileType LspsagaDiagnostic nnoremap <buffer><nowait><silent> <Esc> :q<cr>
    autocmd FileType LspsagaFinder nnoremap <buffer><nowait><silent> <Esc> :q<cr>
    autocmd FileType LspsagaRename nnoremap <buffer><nowait><silent> <Esc> :q<cr>
    autocmd FileType LspsagaFloaterm nnoremap <buffer><nowait><silent> <Esc> :q<cr>
    autocmd FileType LspsagaSignatureHelp nnoremap <buffer><nowait><silent> <Esc> :q<cr>
    autocmd FileType LspSagaFinderSelection nnoremap <buffer><nowait><silent> <Esc> :q<cr>
  augroup END
]]
