local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/after/plugin/?.lua;" .. package.path

pcall(require, "impatient")

require "janos.globals"
require "plugins"
require "options"
require "keymaps"
require "overrides"
