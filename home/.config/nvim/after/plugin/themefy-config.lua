-- Set custom name to the list
require("themery").setup({
  themes = {
    {
      name = "Rosepine",
      colorscheme = "rose-pine"
    },
    {
      name = "Aquarium",
      colorscheme = "aquarium",
    },
    {
      name = "Poimandres",
      colorscheme = "poimandres",
    },
    {
      name = "Rosebones",
      colorscheme = "rosebones",
      after = [[
        vim.opt.background = "dark" -- set this to dark or light
      ]]
    },
    {
      name = "Nordic",
      colorscheme = "nordic"
    },
    {
      name = "Aquarium Dark",
      colorscheme = "aquarium",
      after = [[
        vim.cmd 'hi Normal guibg=#151515'
        vim.cmd 'hi LineNr guibg=#151515'
        vim.cmd 'hi SignColumn guibg=#151515'
        vim.cmd 'hi PMenu guifg=#d0d0d0 guibg=#151515'
        vim.cmd 'hi NormalFloat guifg=#d0d0d0 guibg=#151515'
        vim.cmd 'hi VertSplit guibg=NONE guifg=#141414'
      ]]
    }
  }
})
