local opt= vim.opt
opt.completeopt = 'menuone,noinsert,noselect'

local cmp = require'cmp'
local lspkind = require'lspkind'

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    }),
  }),
  sources = cmp.config.sources({
    { name = 'orgmode' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'buffer', keyword_length = 6 },
  }),
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      menu = {
        treesitter = "[tree]",
        path = "[path]",
        spell = "[spell]",
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[lua]",
        luasnip = "[snip]"
      }
    }),
  },
})

vim.cmd [[
  highlight link CmpItemAbbr Normal
  highlight link CmpItemAbbrDeprecated Error
  highlight link CmpItemAbbrMatchFuzzy MatchParen
  highlight link CmpItemKind GruvBoxFg2
  highlight link CmpItemMenu Comment
]]
