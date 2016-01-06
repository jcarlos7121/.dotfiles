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
set pastetoggle=<F2>
set tags+=gems.tags

" NeoBundle Scripts-----------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=/home/juancarlos/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/juancarlos/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'gmarik/vundle'
NeoBundle 'bling/vim-airline'
NeoBundle 'dag/vim-fish'
NeoBundle 'danro/rename.vim'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'godlygeek/tabular'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'honza/vim-snippets'
NeoBundle 'ivalkeen/vim-ctrlp-tjump'
NeoBundle 'jasoncodes/ctrlp-modified.vim'
NeoBundle 'justinmk/vim-gtfo'
NeoBundle 'justinmk/vim-sneak'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'rking/ag.vim'
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
NeoBundle 'geekjuice/vim-spec'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'rodjek/vim-puppet'
NeoBundle 'Floobits/floobits-vim'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'bling/vim-bufferline'
NeoBundle 'chriskempson/base16-vim'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'tpope/vim-rbenv'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'farseer90718/vim-colorpicker'
NeoBundle 'guicolorscheme.vim'
NeoBundle 'scrooloose/nerdtree'
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
NeoBundle 'majutsushi/tagbar'
NeoBundle 'bkad/CamelCaseMotion'
NeoBundle 'nono/vim-handlebars'
NeoBundle 'ain/vim-capistrano'
"NeoBundle 'vim-scripts/vim-auto-save'
"NeoBundle '0x0dea/vim-molasses'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

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
color distinguished
let g:airline_theme='thechosen'
"let g:molasses_wait=5000
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:hybrid_use_Xresources = 1

"Key mappings""
let mapleader=","
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

map <S-W> <Plug>CamelCaseMotion_w
map <S-B> <Plug>CamelCaseMotion_b
map <S-E> <Plug>CamelCaseMotion_e

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
nnoremap <leader>. :CtrlPTag<cr>
nmap <F8> :TagbarToggle<CR>
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
autocmd BufWritePost *.rb,*.js,*.html,*.haml,*.css,*.sass,*.coffee silent! !ctags -R 2> /dev/null --exclude=.git --exclude=log --exclude=frontend --exclude=tmp &
autocmd VimResized * wincmd =
au BufNewFile,BufRead *.ejs set filetype=html
au BufReadPost * set bufhidden=delete

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
let g:mocha_js_command = "!mocha --recursive --no-colors {spec}"
let g:mocha_coffee_command = "!mocha -b --compilers coffee:coffee-script/register {spec}"

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
"let g:ag_prg="ag --column"
let g:ag_prg='ag -S --nocolor --nogroup --column --ignore tmp --ignore node_modules --ignore "./frontend/node_modules/*" --ignore "./frontend/tmp/*"'

"NERDTREE + CTRLP integration
source ~/.vim/config/ntfinder.vim
source ~/.vim/config/servers_ftp.vim
source ~/.vim/config/envcommands.vim
let NERDTreeQuitOnOpen=1
let NERDTreeBookmarksFile=expand("$HOME/.vim-NERDTreeBookmarks")
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let g:ctrlp_by_filename = 1
let g:ctrlp_dont_split = 'NERD'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules'
let g:ctrlp_root_markers = ['.acignore', '.gitignore', '.git', '.floo', 'Gemfile']
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden --ignore .git --ignore .svn --ignore .hg --ignore .DS_Store --ignore "**/*.pyc" -g ""'

" Autosave
"let g:auto_save = 1
