return {
  'zaldih/themery.nvim',
  config = function()
    -- Set custom name to the list
    require("themery").setup({
      themes = {
        {
          name = "Default",
          colorscheme = "default"
        },
        {
          name = "At the Beach",
          colorscheme = "grey",
        },
        {
          name = "Habamax",
          colorscheme = "habamax"
        },
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
          name = "Nordbones",
          colorscheme = "nordbones",
          after = [[
          vim.opt.background = "dark" -- set this to dark or light
          ]]
        },
        {
          name = "Forestbones",
          colorscheme = "forestbones",
          after = [[
          vim.opt.background = "dark" -- set this to dark or light
          ]]
        },
        {
          name = "Neobones",
          colorscheme = "neobones",
          after = [[
          vim.opt.background = "dark" -- set this to dark or light
          ]]
        },
        {
          name = "Tokyobones",
          colorscheme = "tokyobones",
          after = [[
          vim.opt.background = "dark" -- set this to dark or light
          ]]
        },
        {
          name = "Duckbones",
          colorscheme = "duckbones",
          after = [[
          vim.opt.background = "dark" -- set this to dark or light
          ]]
        },
        {
          name = "Zenburned",
          colorscheme = "zenburned",
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
  end
}
