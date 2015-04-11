set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where vundle should install plugins
"call vundle#begin('~/some/path/here')

" let vundle manage vundle, required
Plugin 'gmarik/vundle.vim'

" the following are examples of different formats supported.
" plugin from http://vim-scripts.org/vim/scripts.html

Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-repeat'
Plugin 'kien/ctrlp.vim'
Plugin 'sjl/gundo.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'ervandew/supertab'
Plugin 'mark'
Plugin 'searchalternatives'
Plugin 'searchcomplete'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
"
let s:python_ver = 0
silent! python import sys, vim;
			\ vim.command("let s:python_ver="+"".join(map(str,sys.version_info[0:3])))

" python plugin bundles
if (has('python') || has('python3')) && s:python_ver >= 260
endif

" all of your plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" to ignore plugin indent changes, instead use:
"filetype plugin on
"
" brief help
" :pluginlist       - lists configured plugins
" :plugininstall    - installs plugins; append `!` to update or just :pluginupdate
" :pluginsearch foo - searches for foo; append `!` to refresh local cache
" :pluginclean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for faq
" put your non-plugin stuff after this line


syntax on
set number
set t_co=256
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8
set background=dark
"let g:solarized_termcolors=256
let g:rehash256 = 1
colorscheme molokai
set mouse=a
set tabstop=4
set shiftwidth=4
set expandtab
" Solarized -------------------------------------------------------------- {{{

if exists('g:colors_name') && g:colors_name == 'solarized'
    " Text is unreadable with background transparency.
    if has('gui_macvim')
        set transparency=0
    endif

    " Highlighted text is unreadable in Terminal.app because it
    " does not support setting of the cursor foreground color.
    if !has('gui_running') && $TERM_PROGRAM == 'Apple_Terminal'
        if &background == 'dark'
            hi Visual term=reverse cterm=reverse ctermfg=10 ctermbg=7
        endif
    endif
endif


set list listchars=tab:>-

au filetype py set autoindent
au filetype py set smartindent
au filetype py set textwidth=79 " pep-8 friendly

au filetype python set omnifunc=pythoncomplete#complete
let g:supertabdefaultcompletiontype = "context"


" enable vim-airline
let g:airline#extensions#tabline#enabled = 1
""""""""""""""""""""""""""""""
" airline
" """"""""""""""""""""""""""""""

let g:airline_powerline_fonts = 1
let g:airline_theme             = 'powerlineish'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
"
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'" unicode symbols
"A
""""""""""""""""""""""""""""""""""""""""""""
"let g:powerline_symbols = "fancy"

"set relativenumber

"function! NumberToggle()
"  if(&relativenumber == 1)
"    set number
"  else
"    set relativenumber
"  endif
"endfunc
":au FocusLost * :set number
":au FocusGained * :set relativenumber
"nnoremap <C-n> :call NumberToggle()<cr>
"
"autocmd InsertEnter * :set number
"autocmd InsertLeave * :set relativenumber
"
set laststatus=2

" restore cursor position
if has("autocmd")
    au bufreadpost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


set hlsearch

" press space to turn off highlighting and clear any message already
" displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set incsearch

set cursorline " highlightcurrent line

set showcmd " show command in bottom bar

set wildmenu

set lazyredraw
set foldenable

set foldnestmax=10      " 10 nested fold max

set foldlevelstart=10   " open most folds by default
set foldmethod=indent   " fold based on indent level

"  move vertically by visual line
nnoremap j gj
nnoremap k gk

"highlight last inserted text
nnoremap gV `[v`]
"nmap <C-CR> i<CR><Esc>

set nostartofline

"toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" Stupid shift key fixes
cmap W w
cmap WQ wq
cmap wQ wq
cmap Q q
cmap Tabe tabe

nnoremap ; :

" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>
map <C-K> <C-W>k<C-W>
map <C-L> <C-W>l<C-W>
map <C-H> <C-W>h<C-W>
map <C-K> <C-W>k<C-W>

nnoremap Y y$

" Use visual bell instead of beeping when doing something wrong

set cmdheight=1

highlight Cursor guifg=black guibg=white


