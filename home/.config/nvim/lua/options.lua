local opt = vim.opt
opt.termguicolors = true

--vim.cmd [[colorscheme iceberg]]
vim.cmd [[colorscheme aquarium]]

opt.tabstop=2
opt.shell = "/usr/local/bin/fish"
opt.wrap = false
opt.number = true
opt.showcmd = true
opt.showmode = false -- Don't display -- INSERT -- in status line
opt.textwidth = 80
opt.cursorline = false
opt.scrolloff = 5
opt.sidescroll = 1
opt.sidescrolloff = 10
opt.formatoptions = "qcrn1"
opt.clipboard = { 'unnamed' }
opt.visualbell = false
opt.errorbells = false
opt.lazyredraw = true
opt.autoread = true
opt.autowrite = true
opt.ruler = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.shiftwidth = 2
opt.expandtab = true
opt.autochdir = true
opt.foldmethod = "indent"
opt.pastetoggle = "<F6>"
opt.foldlevel = 1
opt.laststatus = 2
opt.showtabline = 0
opt.mmp = 5000

vim.cmd[[
  highlight GitGutterAdd    guifg=#009900
  highlight GitGutterChange guifg=#bbbb00
  highlight GitGutterDelete guifg=#ff2222
  hi Search guibg=#3466b7 guifg=White

  " Vim Airline
  "let g:airline_theme='deus'
  "let g:airline_powerline_fonts=1
  "let g:airline#extensions#tabline#enabled = 1
  "let g:hybrid_use_Xresources = 1

  autocmd BufWritePost * GitGutter
  autocmd FileType * EnableStripWhitespaceOnSave
  au BufNewFile,BufRead *.* set noro
  au BufReadPost * set bufhidden=delete

  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
  match ErrorMsg '\s\+$'

  " Bookmarks configuration
  highlight BookmarkSign ctermbg=NONE ctermfg=23
  highlight BookmarkLine ctermbg=0 ctermfg=NONE
  let g:bookmark_sign = '₪'
  let g:bookmark_highlight_lines = 1

  let g:rspec_command = "Dispatch rspec {spec}"

  " Silver searcher configuration
  let g:ackprg='ag -S --nocolor --nogroup --column --ignore tmp --ignore "./_build" --ignore node_modules --ignore webclient/node_modules --ignore "./frontend/node_modules/*" --ignore "./frontend/tmp/*" --ignore "./app/build/*" --ignore="*.png" --ignore="*.jpg" --ignore="*.svg"'

  source ~/.vim/config/ntfinder.vim
  source ~/.vim/config/envcommands.vim

  " NerdTree and Rooter configuration
  let NERDTreeQuitOnOpen=1
  let NERDTreeBookmarksFile=expand("$HOME/.vim-NERDTreeBookmarks")
  let NERDTreeShowBookmarks=1
  let NERDTreeChDirMode=2
  let NERDTreeShowHidden = 1
  let g:NERDTreeWinSize=31
  let g:NERDTreeNodeDelimiter = "\u00a0"

  " ctrlp configuration
  let g:ctrlp_by_filename = 1
  let g:ctrlp_dont_split = 'NERD'
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_root_markers = ['.acignore', '.git']
  let g:ctrlp_user_command = 'ag %s -i -U --nocolor --nogroup --hidden --ignore doc --ignore .yardoc --ignore tmp --ignore node_modules --ignore deps --ignore webclient/node_modules --ignore client/node_modules --ignore app/build --ignore storage --ignore .git --ignore .svn --ignore .hg --ignore .DS_Store --ignore "**/*.pyc" --ignore="*.png" --ignore="*.jpg" --ignore="*.jpeg" --ignore="*.svg"  -g ""'

  " Web devicons
  let g:WebDevIconsUnicodeDecorateFolderNodes = 0 " Disable decoration of folder nodes

  " Set ibeam on exit of vim
  augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:ver10-blinkoff0
  augroup END
]]
