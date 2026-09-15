local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/after/plugin/?.lua;" .. package.path

pcall(require, "impatient")

-- Leader keys must be set BEFORE plugins load: <leader> is resolved when a
-- mapping is defined, and lazy.nvim plugin specs (keys = ...) define theirs
-- during require "plugins".
vim.g.mapleader = ","
vim.g.maplocalleader = " "

require "janos.globals"
require "plugins"
require "options"
require "keymaps"
require "overrides"
