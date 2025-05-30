return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
    'RRethy/nvim-treesitter-endwise', -- Adds automatic end for if, do, class in Ruby, Elixir
    'RRethy/nvim-treesitter-textsubjects',
  },
  config = function()
    local list = require("nvim-treesitter.parsers").get_parser_configs()

    list.sql = {
      install_info = {
        url = "https://github.com/DerekStride/tree-sitter-sql",
        files = { "src/parser.c" },
        branch = "main",
      },
    }

    local _ = require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "heex",
        "eex",
        "ruby",
        "yaml",
        "fish",
        "go",
        "query",
        "html",
        "css",
        "lua",
        "vim",
        "bash",
        "javascript",
        "typescript",
        "pug",
        "jsdoc",
        "solidity",
        "elixir",
        "terraform",
        "graphql",
        "tsx",
        "luadoc",
        "vimdoc"
      },

      --indent = { enable = true },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = {'org'}
      },

      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
      },

      endwise = {
        enable = true,
      },

      textsubjects = {
        enable = true,
        prev_selection = ',',
        keymaps = {
          ['.'] = 'textsubjects-smart',
          [';'] = 'textsubjects-container-inner',
          ['o;'] = 'textsubjects-container-outer',
        },
      },

      textobjects = {
        select = {
          enable = true,
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner"
          }
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']]'] = '@function.outer'
          },
          goto_previous_start = {
            ['[['] = '@function.outer'
          },
        }
      }
    }
  end
}
