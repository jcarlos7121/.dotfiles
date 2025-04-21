return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup({
      edit_with_instructions = {
        keymaps = {
          close = "<ESC>",
        },
      },
      chat = {
        keymaps = {
          close = "<ESC>",
        },
      },
      openai_params = {
        model = "gpt-4o",
        max_tokens = 3000
      }
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim"
  }
}
