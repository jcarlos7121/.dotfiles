local saga = require 'lspsaga'
require'mapx'.setup { global = "force" }

saga.init_lsp_saga()

nnoremap("gh",  ":Lspsaga lsp_finder<CR>" ,  "silent")
nnoremap("gp",  ":Lspsaga preview_definition<CR>" ,  "silent")
nnoremap("gr",  ":Lspsaga rename<CR>" ,  "silent")
