require 'jabs'.setup {
    position = 'center',
    border = 'single', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default shadow
    preview = {
      border = 'single' -- none, single, double, rounded, solid, shadow, (or an array or chars). Default double
    },
    --Keymaps
    keymap = {
      preview = "p", -- Jump to buffer. Default <cr>
      jump = "o" -- Jump to buffer. Default <cr>
    }
}
