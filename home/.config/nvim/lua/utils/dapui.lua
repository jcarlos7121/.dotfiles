-- ~/.config/nvim/lua/utils/dapui.lua
local M = {}

function M.toggle_maximize()
  local dapui_types = {
    dap_repl            = true,
    dapui_scopes        = true,
    dapui_stacks        = true,
    dapui_watches       = true,
    dapui_breakpoints   = true,
    dapui_console       = true,
  }

  local ft = vim.bo.filetype
  -- accept both dash and underscore variants
  if not (dapui_types[ft] or dapui_types[ft:gsub("-", "_")]) then
    return
  end

  local is_max = vim.g.dapui_maximized

  if is_max then
    vim.cmd(vim.g.dapui_restore_cmd or "wincmd =")
  else
    vim.g.dapui_restore_cmd = vim.fn.winrestcmd()
    vim.cmd("wincmd | | wincmd _")
  end

  vim.g.dapui_maximized = not is_max
end

return M
