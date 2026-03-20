vim.cmd[[
  let g:test#javascript#runner = 'jest'

  highlight Search guibg=#3466b7 guifg=#ffffff

  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  match ErrorMsg '\s\+$'

  " Set ibeam on exit of vim
  augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver10-blinkoff0
  augroup END

  autocmd Filetype typescript setlocal ts=4 sw=4 sts=4 et

  " Use /bin/sh for dispatch (fish startup adds ~2.5s)
  let test#strategy = "dispatch"
  set shell=/bin/sh
  set shellcmdflag=-c
]]
