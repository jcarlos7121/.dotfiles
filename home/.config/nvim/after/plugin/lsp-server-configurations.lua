-- Setups the configurations for the LSP servers

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
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
      commandPath = '/Users/juanhinojo/.asdf/shims/solargraph',
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
  elixirls = {
    cmd = { "elixir-ls" },
  }
}

return {
  default_config = default_config,
  lsp_server_configurations = lsp_server_configurations
}
