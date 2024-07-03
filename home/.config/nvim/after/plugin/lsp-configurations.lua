local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
local configurations = require('lsp-server-configurations')

-- Setup Mason and links to LSP servers to nvim-cmp
require('mason').setup()

mason_lspconfig.setup_handlers {
  function(server_name)
    local setup_params = configurations.default_config

    if configurations.lsp_server_configurations[server_name] then
      setup_params = vim.tbl_extend(
        'force',
        setup_params,
        configurations.lsp_server_configurations[server_name]
      )
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
