return {
    'neovim/nvim-lspconfig', -- Adds LSP support for Neovim
    dependencies = {
      'b0o/mapx.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'onsails/lspkind-nvim',
      'nvimdev/lspsaga.nvim',
      'saadparwaiz1/cmp_luasnip', -- Adds lua snippets to cmp
      'mfussenegger/nvim-lint', -- Adds linting support for neovim
      {
        "petertriho/cmp-git",
        dependencies = { 'hrsh7th/nvim-cmp' },
        opts = {
            -- options go here
        },
        init = function()
            table.insert(require("cmp").get_config().sources, { name = "git" })
        end
      }, -- Adds git completion to nvim-cmp
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
        config = function()
          require("typescript-tools").setup {
            settings = {
              complete_function_calls = true,
              include_completions_with_insert_text = true
            }
          }
        end
      }, -- Adds typescript tools for nvim
      {
        'L3MON4D3/LuaSnip',
        dependencies = { 'rafamadriz/friendly-snippets' }
      }, -- Snippets engine for Lua, compatible with VSCode
    },
    config = function()
      local nvim_lsp = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')

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

      local configurations = {
        default_config = default_config,
        lsp_server_configurations = lsp_server_configurations
      }

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

      -- require('ufo').setup()

      require('lint').linters_by_ft = {
        elixir = {'credo'},
        typescript = {'eslint_d'},
        javascript = {'eslint_d'},
        javascriptreact = {'eslint_d'},
        typescriptreact = {'eslint_d'}
      }

      -- LSP Saga configuration
      require'mapx'.setup { global = "force" }

      require('lspsaga').setup({
        ui = {
          code_action = ''
        },
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
      nnoremap("gd",  ":Lspsaga goto_definition<cr>" ,  "silent")

      -- Setup nvim-cmp
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
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
        }),
        sources = cmp.config.sources({
          { name = 'luasnip', option = { use_show_condition = false } },
          { name = 'orgmode' },
          { name = 'git' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
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
    end
  }
