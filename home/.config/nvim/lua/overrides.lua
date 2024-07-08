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

  " Set the strategy for test#run to dispatch
  let test#strategy = "dispatch"

  " NERDCommenter configuration"
  let g:NERDSpaceDelims = 2
  let g:NERDDefaultAlign = 'left'
]]
