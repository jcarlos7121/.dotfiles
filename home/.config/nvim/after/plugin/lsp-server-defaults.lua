-- Setups the configurations for the LSP servers

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- if client.server_capabilities.documentFormattingProvider then
  --   vim.api.nvim_command [[augroup Format]]
  --   vim.api.nvim_command [[autocmd! * <buffer>]]
  --   vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
  --   vim.api.nvim_command [[augroup END]]
  -- end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    completions = {
      completeFunctionCalls = true
    }
  }
}

local lsp_server_configurations = {
  solargraph = {
    solargraph = {
      autoformat = true,
      completion = true,
      diagnostics = true,
      folding = true,
      references = true,
      rename = true,
      symbols = true
    },
    cmd = { "asdf", "exec", "solargraph", "stdio" },
  },
  ruby_lsp = {
    cmd = { "asdf", "exec", "ruby-lsp" },
  },
  elixirls = {
    cmd = { "elixir-ls" },
  }
}

return {
  default_config = default_config,
  lsp_server_configurations = lsp_server_configurations
}
