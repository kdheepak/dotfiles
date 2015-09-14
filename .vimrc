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

" Plugin 'benmills/vimux'
"Plugin 'jpalardy/vim-slime'
Plugin 'kdheepak89/dotvim'


Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'Raimondi/delimitMate'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bfredl/nvim-ipy'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-visual-star-search'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'davidhalter/jedi'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'garbas/vim-snipmate'
Plugin 'godlygeek/tabular'
Plugin 'henrik/vim-indexed-search'
Plugin 'honza/vim-snippets'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'jgors/vimux-ipy'
Plugin 'julienr/vim-cellmode'
Plugin 'kien/ctrlp.vim'
Plugin 'kshenoy/vim-signature'
Plugin 'mileszs/ack.vim'
Plugin 'morhetz/gruvbox'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'plasticboy/vim-markdown'
Plugin 'powerline/fonts'
Plugin 'reinh/vim-makegreen'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'searchalternatives'
Plugin 'searchcomplete'
Plugin 'simnalamburt/vim-mundo'
" Plugin 'sjl/gundo.vim'
Plugin 'tomasr/molokai'
Plugin 'tomtom/tlib_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-scripts/The-NERD-tree'
Plugin 'wincent/Command-T'

let mapleader=","       " leader is comma

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

" set ttymouse=xterm2

syntax enable
" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=~/.vim/undodir

set number
set t_Co=256
" set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
"set term=screen-256color
"set term=xterm-256color
set termencoding=utf-8
set background=light
let g:solarized_termcolors=256
let g:rehash256 = 1

let g:cellmode_tmux_sessionname=''
let g:cellmode_tmux_windowname=''
let g:cellmode_tmux_panenumber='2'
let g:cellmode_use_tmux=1

autocmd BufReadPost fugitive://* set bufhidden=delete

set guifont=Source\ Code\ Pro\ for\ Powerline "make sure to escape the spaces in the name properly<F37>

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" $/^ doesn't do anything
nnoremap $ <nop>
nnoremap ^ <nop>

" highlight last inserted text
nnoremap gV `[v`]

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" autocmd VimEnter * NERDTree
" autocmd BufEnter * NERDTreeMirror

" autocmd VimEnter * wincmd w

let g:NERDTreeShowHidden=1

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Use deoplete.
" let g:deoplete#enable_at_startup = 1
