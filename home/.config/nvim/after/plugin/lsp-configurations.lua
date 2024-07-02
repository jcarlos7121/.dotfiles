local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

require("mason").setup()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
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

mason_lspconfig.setup_handlers {
  function(server_name)
    local setup_params = {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
      solargraph = {
        autoformat = true,
        completion = true,
        diagnostic = true,
        folding = true,
        references = true,
        rename = true,
        symbols = true
      },
      settings = {
        completions = {
          completeFunctionCalls = true
        }
      }
    }

    if server_name == "elixirls" then
      setup_params.cmd = { "elixir-ls" }
    end

    nvim_lsp[server_name].setup(setup_params)
  end
}

require('ufo').setup()

require('lint').linters_by_ft = {
  ruby = {'rubocop'},
  elixir = {'credo'},
  typescript = {'eslint_d'},
  javascript = {'eslint_d'},
  javascriptreact = {'eslint_d'},
  typescriptreact = {'eslint_d'}
}
