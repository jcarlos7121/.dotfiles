" dispatch.vim herdr strategy — run :Make/:Dispatch/:Start in a herdr pane
" below nvim, like the tmux strategy did in tmux. Requires the
" ~/.local/bin/herdr-dispatch-run helper and nvim running inside herdr.

if exists('g:autoloaded_dispatch_herdr')
  finish
endif
let g:autoloaded_dispatch_herdr = 1

function! s:spawn(placement, script, focus, ratio, label) abort
  let b64 = substitute(system('base64', a:script), '\n', '', 'g')
  if v:shell_error
    return 0
  endif
  let helper = expand('~/.local/bin/herdr-dispatch-run')
  if !executable(helper)
    return 0
  endif
  call system(helper . ' ' . a:placement . ' ' . a:ratio . ' ' . a:focus . ' ' .
        \ shellescape(b64) . ' ' . shellescape(getcwd()) . ' ' .
        \ shellescape(a:label) . ' >/dev/null 2>&1 &')
  return 1
endfunction

function! dispatch#herdr#handle(request) abort
  if empty($HERDR_ENV) || empty($HERDR_PANE_ID)
    return 0
  endif
  if a:request.action ==# 'make'
    " small pane at the bottom, focus stays in nvim; output lands in quickfix
    let script = dispatch#isolate(a:request, ['HERDR_PANE_ID', 'HERDR_TAB_ID'],
          \ dispatch#prepare_make(a:request))
    return s:spawn('split', script, 0, get(g:, 'dispatch_herdr_make_ratio', '0.8'), '')
  elseif a:request.action ==# 'start'
    " whole new tab (like tmux new-window), focused unless :Start!
    let script = dispatch#isolate(a:request, ['HERDR_PANE_ID', 'HERDR_TAB_ID'],
          \ dispatch#set_title(a:request),
          \ dispatch#prepare_start(a:request))
    return s:spawn('tab', script, get(a:request, 'background', 0) ? 0 : 1,
          \ '0', get(a:request, 'title', 'start'))
  endif
endfunction
