set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where vundle should install plugins
"call vundle#begin('~/some/path/here')

" let vundle manage vundle, required
Plugin 'gmarik/Vundle.vim'
" the following are examples of different formats supported.
" plugin from http://vim-scripts.org/vim/scripts.html

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'Shougo/neocomplete'
Plugin 'Yggdroot/indentLine'
Plugin 'altercation/vim-colors-solarized'
Plugin 'benmills/vimux'
Plugin 'bling/vim-airline'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'davidhalter/jedi'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'garbas/vim-snipmate'
Plugin 'godlygeek/tabular'
Plugin 'henrik/vim-indexed-search'
Plugin 'honza/vim-snippets'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'kien/ctrlp.vim'
Plugin 'kshenoy/vim-signature'
Plugin 'mileszs/ack.vim'
Plugin 'morhetz/gruvbox'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'plasticboy/vim-markdown'
Plugin 'reinh/vim-makegreen'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'searchalternatives'
Plugin 'searchcomplete'
Plugin 'sjl/gundo.vim'
Plugin 'tomasr/molokai'
Plugin 'tomtom/tlib_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-scripts/The-NERD-tree'
Plugin 'wincent/Command-T'
Plugin 'jgors/vimux-ipy'

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

"set ttymouse=xterm2

syntax enable
" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=~/.vim/undodir

set number
set t_Co=256
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
"set term=screen-256color
"set term=xterm-256color
set termencoding=utf-8
set background=light
let g:solarized_termcolors=256
let g:rehash256 = 1

colorscheme gruvbox


if has("mouse")
    set mouse=a
endif


set tabstop=4
set shiftwidth=4
set expandtab

set wrap "automatically wrap on load
"set fo-=t " don't automatically wrap text when typign
"set colorcolumn=80
highlight ColorColumn ctermbg=233

let g:syntastic_python_flake8_post_args='--ignore=E501,E128,E225'

" copy and paste
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

"" Mokolai
"if has('gui_running')
"    set background=light
"else
"    set background=dark
"endif
"

"" Solarized -------------------------------------------------------------- {{{
"if exists('g:colors_name') && g:colors_name == 'solarized'
"    " Text is unreadable with background transparency.
"    if has('gui_macvim')
"        set transparency=0
"    endif
"
"    " Highlighted text is unreadable in Terminal.app because it
"    " does not support setting of the cursor foreground color.
"    if !has('gui_running') && $TERM_PROGRAM == 'Apple_Terminal'
"        if &background == 'dark'
"            hi Visual term=reverse cterm=reverse ctermfg=10 ctermbg=7
"        endif
"    endif
"endif


set list listchars=tab:>-,extends:»,precedes:«

au filetype py set autoindent
au filetype py set smartindent
au filetype py set textwidth=79 " pep-8 friendly
"
au filetype python set omnifunc=pythoncomplete#complete
let g:supertabdefaultcompletiontype = "context"

let g:neocomplete#enable_at_startup = 1

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
let g:airline_symbols.whitespace = 'Ξ'"" unicode symbols
""""""""""""""""""""""""""""""""""""""""""""
"let g:powerline_symbols = "fancy"

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
nnoremap <F5> :GundoToggle<CR>
" Easier moving in tabs and windows
map <C-J> <C-W>j<C-W>
map <C-K> <C-W>k<C-W>
map <C-L> <C-W>l<C-W>
map <C-H> <C-W>h<C-W>

"let g:pyflakes_use_quickfix = 0

map <silent> <C-h> :call WinMove('h')<cr>
map <silent> <C-j> :call WinMove('j')<cr>
map <silent> <C-k> :call WinMove('k')<cr>
map <silent> <C-l> :call WinMove('l')<cr>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" moving up and down work as you would expect
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> ^ g^
nnoremap <silent> $ g$

" search for word under the cursor
nnoremap <leader>/ "fyiw :/<c-r>f<cr>

"au FileType python set omnifunc=pythoncomplete#Complete
"let g:SuperTabDefaultCompletionType = "context"
"
"set completeopt=menuone,longest,preview
"" faster redrawing
"
"" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <C-n> :NERDTreeToggle<CR>



nnoremap Y y$
" make backspace behave in a sane manner
set backspace=indent,eol,start

" Use visual bell instead of beeping when doing something wrong

set cmdheight=1
" remove extra whitespace
nmap <leader><space> :%s/\s\+$<cr>

"set clipboard=unnamed

set scrolloff=3 " lines of text around cursor
" set a map leader for more key combos
let mapleader = ','
let g:mapleader = ','

highlight Cursor guifg=black guibg=white

nmap <silent> <leader>n :NERDTreeToggle<CR>

nmap <leader>a <Esc>:Ack!
" shortcut to save
nmap <leader>w :w<cr>
nmap <leader>q :q<cr>

vnoremap <Leader>s :sort<CR>
" disable Ex mode
noremap Q <NOP>

" set paste toggle
set pastetoggle=<F6>

" toggle paste mode
" map <leader>v :set paste!<cr>

map <Leader>vip :call VimuxIpy()<CR>
vmap <silent> <Leader>e :python run_visual_code()<CR>
noremap <silent> <Leader>c :python run_cell(save_position=False, cell_delim='####')<CR>

" Unmap the arrow keys
no <down> <Nop>
no <left> <Nop>
no <right> <Nop>
no <up> <Nop>

" Textmate style indentation
vmap <leader>[ <gv
vmap <leader>] >gv
nmap <leader>[ <<
nmap <leader>] >>
" search for word under the cursor
nnoremap <leader>/ "fyiw :/<c-r>f<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Window movement shortcuts
" move to the window in the direction shown, or create a new window
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction


"autocmd! bufwritepost .vimrc source %

"let g:syntastic_check_on_open = 1

nnoremap <Leader>rtw :%s/\s\+$//ge<CR>

" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
"" ]M            Jump on next class or method (normal, visual, operator modes)
"let g:pymode_rope = 1
"
"" Documentation
"let g:pymode_doc = 1
"let g:pymode_doc_key = 'K'
"
""Linting
"let g:pymode_lint = 1
"let g:pymode_lint_checker = "pyflakes,pep8"
"" Auto check on save
"let g:pymode_lint_write = 1
"
"" Support virtualenv
"let g:pymode_virtualenv = 1
"
"" Enable breakpoints plugin
"let g:pymode_breakpoint = 1
"let g:pymode_breakpoint_bind = '<leader>b'
"
"" syntax highlighting
"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"let g:pymode_syntax_space_errors = g:pymode_syntax_all
"noremap <F8> :PymodeLintAuto<CR>
"" Don't autofold code
"let g:pymode_folding = 0


:command WQ wq
:command Wq wq
:command W w
:command Q q
:command Qa qa
:command QA qa


inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i

vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <escc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $inoremap$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>


" Ignore case when searching
set ignorecase
"
" "                           When searching try to be smart about cases
set smartcase
set ai "Apple_Terminaluto indent
set si "Smart indent

" Vim
let g:indentLine_color_term = 239

"GVim
let g:indentLine_color_gui = '#A4E57E'

" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
