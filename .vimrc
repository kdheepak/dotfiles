syntax enable           " enable syntax processing
set background=dark
let g:solarized_termcolors=256

colorscheme solarized 

set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set expandtab           " tabs are spaces
set number              " show line numbers
set showcmd             " show command in bottom bar
"set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set nocompatible        " make vim more useful

set mouse=a
set noerrorbells

" Show the (partial) command as it’s being typed
set showcmd

" shortcut to turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
" za to unfold block

set foldmethod=indent   " fold based on indent level

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
nnoremap $ E
nnoremap ^ B

" highlight last inserted text
nnoremap gV `[v`]

let mapleader=","       " leader is comma

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
"

