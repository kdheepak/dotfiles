set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'morhetz/gruvbox'        " Theme

Plugin 'Shougo/deoplete.nvim'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/echodoc.vim'

Plugin 'zchee/deoplete-jedi'

" Plugin 'myusuf3/numbers.vim'    " Toggle automatically line numbers between normal and insert mode

Plugin 'vim-airline/vim-airline' " Airline status bar
Plugin 'vim-airline/vim-airline-themes'

Plugin 'christoomey/vim-tmux-navigator'
Plugin 'christoomey/vim-tmux-runner'

Plugin 'itchyny/vim-cursorword'

Plugin 'ap/vim-css-color'

Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'rhysd/vim-gfm-syntax'

Plugin 'vim-python/python-syntax'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'vim-scripts/python_match.vim'
Plugin 'raimon49/requirements.txt.vim'

Plugin 'tmux-plugins/vim-tmux'

Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-tbone'
Plugin 'tpope/vim-jdaddy'

Plugin 'kana/vim-niceblock'

Plugin 'mbbill/undotree'

Plugin 'reedes/vim-wordy'

Plugin 'wellle/tmux-complete.vim'

Plugin 'farmergreg/vim-lastplace'

Plugin 'ntpeters/vim-better-whitespace'

Plugin 'neomake/neomake'

Plugin 'kdheepak/gridlabd.vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set termguicolors
colorscheme gruvbox
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let g:python_highlight_all = 1

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.config/nvim/snippets/'

if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" autocmd CompleteDone * pclose " To close preview window of deoplete automagically

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>

nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

set relativenumber
set number

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

set cursorline " highlightcurrent line

set showcmd " show command in bottom bar

set wildmenu

set lazyredraw
set foldenable

set foldnestmax=10      " 10 nested fold max

set foldlevelstart=10   " open most folds by default
set foldmethod=indent   " fold based on indent level

set cindent

" " Set 7 lines to the cursor - when moving vertically using j/k
set so=7

nnoremap Y y$
" " make backspace behave in a sane manner
set backspace=indent,eol,start

:command W w
:command WQ wq
:command Wq wq
:command Q q
:command Qa qa
:command QA qa

:map Q <Nop>

" Ignore case when searching
set ignorecase

"                           When searching try to be smart about cases
set smartcase
set ai "Apple_Terminaluto indent
set si "Smart indent

augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

let g:airline#extensions#tabline#enabled = 1
"
" air-line
let g:airline_powerline_fonts = 1

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
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 1

autocmd BufEnter * EnableStripWhitespaceOnSave

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

autocmd! BufWritePost * Neomake

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_python_checkers = ['pylint', 'flake8']

" Use tab for indenting in visual mode
vnoremap <Tab> >gv|
vnoremap <S-Tab> <gv
nnoremap > >>_
nnoremap < <<_

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" Macros
nnoremap Q q
nnoremap M @q
vnoremap M :norm @q<CR>

let g:neomake_python_flake8_maker = {
    \ 'args': ['--ignore=F403',  '--format=default', '--max-line-length=160', '--max-complexity=15', '--exclude=tests/*'],
    \ 'errorformat':
        \ '%E%f:%l: could not compile,%-Z%p^,' .
        \ '%A%f:%l:%c: %t%n %m,' .
        \ '%A%f:%l: %t%n %m,' .
        \ '%-G%.%#'
    \ }
let g:neomake_python_enabled_makers = ['flake8']

set list
set listchars=tab:>-

nnoremap * *N


