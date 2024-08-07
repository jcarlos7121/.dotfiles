set encoding=utf-8
set nocompatible | filetype indent plugin on | syn on | filetype plugin on

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
set pastetoggle=<F6>
set laststatus=2
set tags+=gems.tags
set t_ut=
set t_Co=256

"NeoBundle Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath^=/Users/juanhinojo/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('/Users/juanhinojo/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'bling/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'
NeoBundle 'dag/vim-fish'
NeoBundle 'danro/rename.vim'
NeoBundle 'adelarsq/vim-matchit'
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'godlygeek/tabular'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'easymotion/vim-easymotion'
NeoBundle 'ivalkeen/vim-ctrlp-tjump'
NeoBundle 'jasoncodes/ctrlp-modified.vim'
NeoBundle 'justinmk/vim-gtfo'
"NeoBundle 'justinmk/vim-sneak'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'plasticboy/vim-markdown'
"NeoBundle 'rking/ag.vim'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'honza/vim-snippets'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'tpope/vim-bundler'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-ragtag'
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-vinegar'
NeoBundle 'thoughtbot/vim-rspec'
"NeoBundle 'vim-test/vim-test'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'rodjek/vim-puppet'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'bling/vim-bufferline'
NeoBundle 'terryma/vim-multiple-cursors', '13232e4b544775cf2b039571537b0e630406f801'
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-rbenv'
NeoBundle 'guicolorscheme.vim'
NeoBundle 'scrooloose/nerdtree', '67fa9b3116948466234978aa6287649f98e666bd'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'airblade/vim-rooter'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'briancollins/vim-jst'
NeoBundle 'ngmy/vim-rubocop'
NeoBundle 'ap/vim-css-color'
NeoBundle 'MattesGroeger/vim-bookmarks'
NeoBundle 'chrisbra/NrrwRgn'
NeoBundle 'danchoi/ri.vim'
NeoBundle 'mtscout6/vim-cjsx'
NeoBundle 'ntpeters/vim-better-whitespace'
NeoBundle 'tpope/vim-rake'
NeoBundle 'jgdavey/vim-blockle'
NeoBundle 'bkad/CamelCaseMotion'
NeoBundle 'ain/vim-capistrano'
NeoBundle 'BjRo/vim-extest'
NeoBundle 'mattreduce/vim-mix'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'isRuslan/vim-es6'
NeoBundle 'rizzatti/dash.vim'
NeoBundle 'KabbAmine/vCoolor.vim'
NeoBundle 'wakatime/vim-wakatime'
NeoBundle 'iurifq/ctrlp-rails.vim', {'depends' : 'kien/ctrlp.vim' }
NeoBundle 'SirVer/ultisnips'
NeoBundle 'ervandew/supertab'
NeoBundle 'stillwwater/vim-nebula'
NeoBundle 'tomlion/vim-solidity'

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
"
" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

syntax enable                           " Switch syntax highlighting on
syntax on

""Color"
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if has('termguicolors')
  set termguicolors
endif

"set background=light
set background=dark
colorscheme nebula
"color distinguished
"color alduin

highlight GitGutterAdd    guifg=#009900 ctermfg=2 ctermbg=black
highlight GitGutterChange guifg=#bbbb00 ctermfg=3 ctermbg=black
highlight GitGutterDelete guifg=#ff2222 ctermfg=1 ctermbg=black

"let g:airline_theme='thechosen'
let g:airline_theme='deus'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:hybrid_use_Xresources = 1

"Key mappings""
let mapleader=","
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'
let g:autoformat_verbosemode=1

map <S-W> <Plug>CamelCaseMotion_w
map <S-B> <Plug>CamelCaseMotion_b
map <S-E> <Plug>CamelCaseMotion_e

map <Leader>gm :CtrlPModified<CR>
map <Leader>gM :CtrlPBranch<CR>
map <Leader>z :tab split<CR>
map <Leader>q :tabclose<CR>

nmap s <Plug>(easymotion-overwin-f2)

map <Leader>3 :!fish<CR>
vmap <Tab> >

" Convert Js to Coffee
vmap <Leader>jc <esc>:'<,'>!js2coffee<CR>
" " Convert Coffee to JS
vmap <leader>cj <esc>:'<,'>!coffee -sbp<CR>"

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <F5> :call NTFinderP()<CR>
nnoremap <F6> :GundoToggle<CR>
nnoremap <leader>. :CtrlPTag<cr>
nmap <F8> :TagbarToggle<CR>
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
nmap <silent> <leader>c :VCoolor<CR>

" " For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif"

" Move multiple lines
noremap <A-Down> :m .+1<CR>==
noremap <A-Up> :m .-2<CR>==
noremap <A-Down> <Esc>:m .+1<CR>==gi
noremap <A-Up> <Esc>:m .-2<CR>==gi
noremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

"Neosnippet config
let g:acp_enableAtStartup = 0
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" AfterSave and FileTypes
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufReadPost *.coffee setl foldmethod=indent
autocmd BufWritePost *.py,*.rb,*.js,*.html,*.haml,*.css,*.sass,*.coffee silent! !ctags -R 2> /dev/null --exclude=.git --exclude=log --exclude=frontend --exclude=tmp --exclude=node_modules --exclude=public --exclude=doc --exclude=coverage --exclude=spec &
autocmd BufWritePost * GitGutter
autocmd VimResized * wincmd =
autocmd FileType * EnableStripWhitespaceOnSave
au BufNewFile,BufRead *.ejs set filetype=html
au BufNewFile,BufRead *.* set noro
au BufReadPost * set bufhidden=delete

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
let g:mocha_js_command = "Dispatch mocha --recursive --no-colors {spec}"
let g:mocha_coffee_command = "Dispatch mocha -b --compilers coffee:coffee-script/register {spec}"
let g:rspec_command = "Dispatch rspec {spec}"

"Vim Test
"let test#strategy = "dispatch"
"let g:dispatch_compilers = {'elixir': 'exunit'}
"let test#elixir#exunit#executable = 'mix test'

map <Leader>w :call RunAllSpecs()<CR>
map <Leader>e :call RunNearestSpec()<CR>
map <Leader>t :call RunCurrentSpecFile()<CR>

" Vim Test
"map <Leader>w :TestSuite<CR>
"map <Leader>e :TestNearest<CR>
"map <Leader>t :TestFile<CR>

map oo <C-]>

"let test#elixir#exunit#executable = 'iex -S mix test'

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
" EasyAlign
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

"Emmet"
"  <c-x>,
let g:user_emmet_leader_key='<C-x>'

"agprg
"Remember install silver_searcher
"let g:ag_prg="ag --column"
"let g:ag_prg='ag -S --nocolor --nogroup --column --ignore tmp --ignore --ignore _build --ignore node_modules --ignore "./frontend/node_modules/*" --ignore "./frontend/tmp/*" --ignore "./app/build/*"'
let g:ackprg='ag -S --nocolor --nogroup --column --ignore tmp --ignore _build --ignore node_modules --ignore "./frontend/node_modules/*" --ignore "./frontend/tmp/*" --ignore "./app/build/*"'

"NERDTREE + CTRLP integration
"source ~/.vim/config/ntfinder.vim
"source ~/.vim/config/envcommands.vim
let NERDTreeQuitOnOpen=1
let NERDTreeBookmarksFile=expand("$HOME/.vim-NERDTreeBookmarks")
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let g:ctrlp_by_filename = 1
let g:ctrlp_dont_split = 'NERD'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = { 'dir':  '\node_modules$\|\tmp$' }
let g:ctrlp_root_markers = ['.acignore', '.gitignore', '.git', '.floo', 'Gemfile']
let g:ctrlp_user_command = 'ag %s -i -U --nocolor --nogroup --hidden --ignore _build --ignore doc --ignore log --ignore coverage --ignore .yardoc --ignore tmp --ignore node_modules --ignore deps --ignore client/node_modules --ignore app/build --ignore storage --ignore .git --ignore .svn --ignore .hg --ignore .DS_Store --ignore "**/*.pyc" -g ""'
let g:NERDTreeNodeDelimiter = "\u00a0"
let g:airline_powerline_fonts = 1

" Whitespace
let g:strip_whitespace_confirm=0
