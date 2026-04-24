return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-context',
    'RRethy/nvim-treesitter-endwise',
  },
  config = function()
    -- Install parsers
    require("nvim-treesitter").install({
      "sql",
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
      "vimdoc",
    })

    -- Treesitter highlight is now enabled by default in Neovim.
    -- To enable additional vim regex highlighting for org:
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "org",
      callback = function()
        vim.bo.syntax = "on"
      end,
    })

    -- Textobjects setup (new standalone API)
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })

    -- Textobjects keymaps
    local move = require("nvim-treesitter-textobjects.move")
    local select = require("nvim-treesitter-textobjects.select")

    vim.keymap.set({"x", "o"}, "af", function() select.select_textobject("@function.outer", "textobjects") end)
    vim.keymap.set({"x", "o"}, "if", function() select.select_textobject("@function.inner", "textobjects") end)
    vim.keymap.set({"x", "o"}, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
    vim.keymap.set({"x", "o"}, "ic", function() select.select_textobject("@class.inner", "textobjects") end)

    vim.keymap.set({"n", "x", "o"}, "]]", function() move.goto_next_start("@function.outer", "textobjects") end)
    vim.keymap.set({"n", "x", "o"}, "[[", function() move.goto_previous_start("@function.outer", "textobjects") end)
  end
}
