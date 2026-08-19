local themes = {
        {
          name = "Default",
          colorscheme = "default"
        },
        {
          name = "Koda",
          colorscheme = "koda",
          after = [[
            vim.opt.background = "dark" -- set this to dark or light
          ]]
        },
        {
          name = "Dayfox",
          colorscheme = "dayfox",
        },
        {
          name = "Rosepine",
          colorscheme = "rose-pine"
        },
        {
          name = "Iceberg",
          colorscheme = "iceberg"
        },
        {
          name = "Everforest",
          colorscheme = "everforest"
        },
        {
          name = "Aquarium",
          colorscheme = "aquarium",
          after = [[
            -- No vertical line
            vim.api.nvim_set_hl(0, "VertSplit", { fg = "none", bg = "none" })

            -- Inactive windows slightly lighter (NormalNC)
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "#20202A" })

            -- Optionally: make borderless floating windows blend better
            vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#2C2E3E" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2C2E3E" })  -- match Normal

            -- Progress bar with visible foreground
            vim.cmd("highlight LazyProgressTodo guibg=#2C2E3E ctermbg=NONE")
            vim.cmd("highlight LazyProgressDone guibg=#2C2E3E guifg=#e3aed9 ctermbg=NONE")
            vim.cmd("highlight LazyProgress guibg=#2C2E3E guifg=#e3aed9 ctermbg=NONE")
          ]]
        },
        {
          name = "Rosebones",
          colorscheme = "rosebones",
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
          name = "Duckbones",
          colorscheme = "duckbones",
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

-- Names of themes to exclude from the weekly Mon-Fri rotation.
local rotation_blocklist = {
  ["Default"] = true,
  ["Dayfox"] = true,
}

return {
  'zaldih/themery.nvim',
  config = function()
    require("themery").setup({ themes = themes })
    -- local now = os.date("*t")
    -- -- wday: 1=Sunday, 2=Monday, ..., 7=Saturday. Only rotate Mon-Fri.
    -- if now.wday < 2 or now.wday > 6 then
    --   return
    -- end
    --
    -- local eligible = {}
    -- for _, theme in ipairs(themes) do
    --   if not rotation_blocklist[theme.name] then
    --     table.insert(eligible, theme)
    --   end
    -- end
    -- if #eligible == 0 then
    --   return
    -- end
    --
    -- -- Deterministic by (year, day-of-year): same theme all day, different next day.
    -- local idx = (now.year * 366 + now.yday) % #eligible + 1
    -- local picked = eligible[idx]
    --
    -- vim.schedule(function()
    --   vim.cmd.colorscheme(picked.colorscheme)
    --   if picked.after then
    --     loadstring(picked.after)()
    --   end
    -- end)
  end
}
