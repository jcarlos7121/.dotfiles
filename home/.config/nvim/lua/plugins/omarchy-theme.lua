-- Follow the Omarchy system theme (Linux only).
--
-- Omarchy writes each theme's Neovim colorscheme as a LazyVim spec at
-- ~/.local/state/omarchy/current/theme/neovim.lua:
--   { { "ficcdaf/ashen.nvim" }, { "LazyVim/LazyVim", opts = { colorscheme = "ashen" } } }
-- This config isn't LazyVim, so read that file ourselves: register its theme
-- plugins (lazy-loaded), apply its colorscheme on startup, and re-apply when
-- `omarchy theme set` swaps the theme. Themery still works for manual picks.
local theme_dir = vim.fn.expand("~/.local/state/omarchy/current")
local theme_file = theme_dir .. "/theme/neovim.lua"

-- Not on Omarchy (e.g. the Mac): nothing to follow
if not vim.uv.fs_stat(theme_file) then
  return {}
end

local function read_theme()
  local ok, spec = pcall(dofile, theme_file)
  if not ok or type(spec) ~= "table" then
    return {}, nil
  end

  local plugins, colorscheme = {}, nil
  for _, entry in ipairs(spec) do
    if entry[1] == "LazyVim/LazyVim" then
      colorscheme = entry.opts and entry.opts.colorscheme
    elseif entry[1] then
      plugins[#plugins + 1] = vim.tbl_extend("force", entry, { lazy = true })
    end
  end
  return plugins, colorscheme
end

local function apply()
  local plugins, colorscheme = read_theme()
  if not colorscheme then
    return
  end

  -- A theme switched to mid-session may name a plugin that isn't installed yet
  local config = require("lazy.core.config")
  local missing = {}
  for _, plugin in ipairs(plugins) do
    local name = plugin.name or plugin[1]:match("[^/]+$")
    if not config.plugins[name] then
      missing[#missing + 1] = plugin
    end
  end
  if #missing > 0 then
    vim.notify("Omarchy theme needs " .. missing[1][1] .. "; add it with :Lazy and restart", vim.log.levels.WARN)
  end

  vim.o.background = "dark"
  pcall(require("lazy.core.loader").colorscheme, colorscheme)
  pcall(vim.cmd.colorscheme, colorscheme)
end

local specs = read_theme()

specs[#specs + 1] = {
  name = "omarchy-theme",
  dir = vim.fn.stdpath("config"),
  lazy = false,
  priority = 900, -- after the colorscheme plugins, so this choice wins at startup
  config = function()
    vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = apply })

    -- `omarchy theme set` re-points ~/.local/state/omarchy/current/theme
    local watcher = vim.uv.new_fs_event()
    if watcher then
      local pending = false
      watcher:start(theme_dir, {}, function()
        if pending then
          return
        end
        pending = true
        vim.defer_fn(function()
          pending = false
          apply()
        end, 300)
      end)
    end
  end,
}

return specs
