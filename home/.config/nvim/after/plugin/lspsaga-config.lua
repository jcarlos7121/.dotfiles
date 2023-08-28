require'mapx'.setup { global = "force" }

require('lspsaga').setup({
  symbol_in_winbar = {
    enable = false,
  },
  rename = {
    keys = {
      quit = {'q', '<ESC>'}
    }
  },
  code_action = {
    keys = {
      quit = {'q', '<ESC>'}
    }
  },
  finder = {
    keys = {
      quit = {'q', '<ESC>'}
    }
  },
  diagnostic = {
    keys = {
      quit = {'q', '<ESC>'}
    }
  },
  definition = {
    keys = {
      quit = {'q', '<ESC>'}
    }
  }
})

nnoremap("<C-y>", ":Lspsaga diagnostic_jump_next<CR>", "silent")
nnoremap("<C-b>", ":Lspsaga diagnostic_jump_prev<CR>", "silent")
nnoremap("ga",  ":Lspsaga code_action<CR>" ,  "silent")
nnoremap("gr",  ":Lspsaga rename<CR>" ,  "silent")
nnoremap("gh",  ":Lspsaga finder<CR>" ,  "silent")
nnoremap("gb",  ":Lspsaga hover_doc<cr>" ,  "silent")
