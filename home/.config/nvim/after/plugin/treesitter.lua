local list = require("nvim-treesitter.parsers").get_parser_configs()

list.sql = {
  install_info = {
    url = "https://github.com/DerekStride/tree-sitter-sql",
    files = { "src/parser.c" },
    branch = "main",
  },
}

local _ = require("nvim-treesitter.configs").setup {
  ensure_installed = { "ruby", "yaml", "sql", "go", "query", "html", "css", "lua", "vim", "bash", "javascript", "typescript", "pug", "org", "solidity" },

  --indent = { enable = true },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'}
  }
}
