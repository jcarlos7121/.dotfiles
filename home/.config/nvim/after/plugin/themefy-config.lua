-- Set custom name to the list
require("themery").setup({
  themeConfigFile = "/Users/juanhinojo/.config/nvim/lua/theme.lua",
  themes = {
    {
      name = "Rosepine",
      colorscheme = "rose-pine"
    },
    {
      name = "Nord Dark",
      colorscheme = "nord",
      after = [[
        vim.cmd 'hi Normal guibg=#111111'
        vim.cmd 'hi StatusLine guibg=#111111'
        vim.cmd 'hi StatusLineNC guibg=#111111'
        vim.cmd 'hi LineNr guibg=#111111'
        vim.cmd 'hi SignColumn guibg=#111111'
        vim.cmd 'hi PMenu guifg=#d0d0d0 guibg=#151515'
        vim.cmd 'hi NormalFloat guifg=#d0d0d0 guibg=#151515'
        vim.cmd 'hi VertSplit guibg=NONE guifg=#141414'
      ]]
    },
    {
      name = "Aquarium",
      colorscheme = "aquarium",
    },
    {
      name = "Aquarium Dark",
      colorscheme = "aquarium",
      after = [[
        vim.cmd 'hi Normal guibg=#111111'
        vim.cmd 'hi LineNr guibg=#111111'
        vim.cmd 'hi SignColumn guibg=#111111'
        vim.cmd 'hi PMenu guifg=#d0d0d0 guibg=#151515'
        vim.cmd 'hi NormalFloat guifg=#d0d0d0 guibg=#151515'
        vim.cmd 'hi VertSplit guibg=NONE guifg=#141414'
      ]]
    }
  }
})
