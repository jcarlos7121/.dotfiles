require("nvim-tree").setup({
  view = {
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true
  },
})

-- Disable nvim-tree folder icon
vim.g.nvim_tree_show_icons = {
  files = 1,
  git = 1,
  folder_arrows = 1,
  folders = 0
}
