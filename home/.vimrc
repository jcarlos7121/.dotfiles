set encoding=utf-8
set nocompatible | filetype indent plugin on | syn on | filetype plugin on

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

set t_Co=256                            " User 256 colors
set synmaxcol=240                       " Hightlight only the first n chars
set tabstop=2
set shell=/bin/bash
set nowrap                              " Do not wrap long lines
set number                              " Show linenumbers
set showcmd                             " Show info in the right bottom,set ttyfast
set textwidth=80
set nocursorline                        " Do not hightlight the current line
set scrolloff=5
set sidescroll=1
set sidescrolloff=10
set formatoptions=qcrn1
set clipboard+=unnamed                  " Yanks go on clipboard instead.
set novisualbell                        " No blinking .
set noerrorbells                        " No noise.
set lazyredraw
set autoread                            " Reload file if it's modified outside
set autowrite
set ruler                               " Show line and column number
set splitbelow
set splitright
set noswapfile
set shiftwidth=2
set expandtab
set autochdir
set foldmethod=indent
set foldlevel=1
set pastetoggle=<F2>

Bundle 'gmarik/vundle'
Bundle 'bling/vim-airline'
Bundle 'dag/vim-fish'
Bundle 'danro/rename.vim'
Bundle 'edsono/vim-matchit'
Bundle 'elixir-lang/vim-elixir'
Bundle 'godlygeek/tabular'
Bundle 'junegunn/vim-easy-align'
Bundle 'honza/vim-snippets'
Bundle 'ivalkeen/vim-ctrlp-tjump'
Bundle 'jasoncodes/ctrlp-modified.vim'
Bundle 'justinmk/vim-gtfo'
Bundle 'justinmk/vim-sneak'
Bundle 'kana/vim-smartinput'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'rking/ag.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-ragtag'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-vinegar'
Bundle 'thoughtbot/vim-rspec'
Bundle 'vim-ruby/vim-ruby'
Bundle 'w0ng/vim-hybrid'
Bundle 'rodjek/vim-puppet'
Bundle 'Floobits/floobits-vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'bling/vim-bufferline'
Bundle 'chriskempson/base16-vim'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'Shougo/neocomplete'
Bundle 'Shougo/neosnippet'
Bundle 'Shougo/neosnippet-snippets'
Bundle 'nanotech/jellybeans.vim'
Bundle 'tpope/vim-rbenv'
Bundle 'mattn/emmet-vim'
Bundle 'farseer90718/vim-colorpicker'
Bundle 'guicolorscheme.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'flazz/vim-colorschemes'
Bundle 'airblade/vim-rooter'
Bundle 'pangloss/vim-javascript'
Bundle 'briancollins/vim-jst'
Bundle 'ngmy/vim-rubocop'
Bundle 'ap/vim-css-color'
Bundle 'MattesGroeger/vim-bookmarks'
Bundle 'chrisbra/NrrwRgn'
Bundle 'danchoi/ri.vim'
Bundle 'mtscout6/vim-cjsx'

syntax enable                           " Switch syntax highlighting on
syntax on

""Color"
color distinguished
let g:airline_theme='thechosen'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:hybrid_use_Xresources = 1

"Key mappings""
let mapleader=","
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

map <Leader>gm :CtrlPModified<CR>
map <Leader>gM :CtrlPBranch<CR>
map <Leader>z :tab split<CR>
map <Leader>q :tabclose<CR>
map <C-a> :NeoCompleteDisable<CR>
map <C-s> :NeoCompleteEnable<CR>
map <F3> :!fish<CR>
vmap <Tab> >

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <F5> :call NTFinderP()<CR>
nnoremap <F6> :GundoToggle<CR>
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap <silent> <leader>c :!zenity --color-selection<CR>

" " For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif"

"Neosnippet config
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufReadPost *.coffee setl foldmethod=indent
autocmd VimResized * wincmd =
au BufNewFile,BufRead *.ejs set filetype=html

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
match ErrorMsg '\s\+$'

imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"

"Vim Bookmarks
highlight BookmarkSign ctermbg=NONE ctermfg=23
highlight BookmarkLine ctermbg=0 ctermfg=NONE
let g:bookmark_sign = '₪'
let g:bookmark_highlight_lines = 1

"Vim Rspec
map <Leader>w :call RunAllSpecs()<CR>
map <Leader>e :call RunNearestSpec()<CR>
map <Leader>t :call RunCurrentSpecFile()<CR>

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
" EasyAlign
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

"Emmet"
"  <c-x>,
let g:user_emmet_leader_key='<C-x>'

"agprg
"Remember install silver_searcher
let g:agprg="ag --column"

"NERDTREE + CTRLP integration
source ~/.vim/config/ntfinder.vim
source ~/.vim/config/startup.vim
let NERDTreeQuitOnOpen=1
let NERDTreeBookmarksFile=expand("$HOME/.vim-NERDTreeBookmarks")
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let g:ctrlp_by_filename = 1
let g:ctrlp_dont_split = 'NERD'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules'
let g:ctrlp_root_markers = ['.acignore', '.gitignore', '.git', '.floo']

" On startup
autocmd VimEnter * call StartUp()
