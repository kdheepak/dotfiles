set nocompatible              " be iMproved, required
filetype off                  " required

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"
" Specify a directory for plugins
" - For Neovim:
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" If installed using Homebrew
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'dracula/vim'
Plug 'vim-airline/vim-airline' " Airline status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/vim-cursorword'
Plug 'ap/vim-css-color'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-obsession'
Plug 'gregsexton/gitv', {'on': ['Gitv']}
" Plug 'dhruvasagar/vim-prosession'
Plug 'dhruvasagar/vim-zoom'
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-niceblock'
Plug 'mbbill/undotree'
Plug 'reedes/vim-wordy'
" Plug 'edkolev/tmuxline.vim'
" Plug 'kdheepak/promptline.vim'
Plug 'wellle/tmux-complete.vim'
Plug 'farmergreg/vim-lastplace'
Plug 'ntpeters/vim-better-whitespace'
"Plug 'w0rp/ale'
Plug 'neomake/neomake'
" Plug 'Yggdroot/indentLine' " Enables LaTeX formatting for some reason
" Plug 'thaerkh/vim-indentguides'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'Raimondi/delimitMate'
Plug 'danro/rename.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'sjl/gundo.vim'
Plug 'dhruvasagar/vim-table-mode'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'vim-pandoc/vim-pandoc-after'
" Tmux
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'
Plug 'tmux-plugins/vim-tmux-focus-events'
" Markdown
" Plug 'rhysd/vim-gfm-syntax'
" Python
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'vim-python/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'vim-scripts/python_match.vim'
" Plug 'ambv/black'
" Rust
Plug 'rust-lang/rust.vim'
" Java
Plug 'artur-shaik/vim-javacomplete2'
Plug 'tfnico/vim-gradle'
" Julia
Plug 'JuliaEditorSupport/julia-vim'
Plug 'zyedidia/julialint.vim'
" Dart
Plug 'dart-lang/dart-vim-plugin'
Plug 'reisub0/hot-reload.vim'
" assuming your using vim-plug: https://github.com/junegunn/vim-plug
Plug 'roxma/nvim-yarp'

" Plug 'kdheepak/SearchHighlighting.vim' " replaced with loupe
Plug 'kdheepak/gridlabd.vim'
Plug 'baabelfish/nvim-nim'

Plug 'pondrejk/vim-readability'

Plug 'vim-scripts/DrawIt'
Plug 'gyim/vim-boxdraw'
" Plug 'airblade/vim-rooter'

Plug 'glacambre/firenvim', { 'do': function('firenvim#install') }
Plug 'norcalli/nvim-colorizer.lua'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

Plug 'joom/latex-unicoder.vim'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'Shougo/defx.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'chemzqm/denite-extra'
Plug 'chemzqm/denite-git'
Plug 'machakann/vim-highlightedyank'
Plug 'kassio/neoterm'
Plug 'wincent/loupe'
" Plug 'scrooloose/nerdtree'
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}}
Plug 'chemzqm/unite-location'
Plug 'yyotti/denite-marks'
Plug 'hecal3/vim-leader-guide'
Plug 'Lokaltog/neoranger'
Plug 'rbgrouleff/bclose.vim'

Plug 'editorconfig/editorconfig-vim'

Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'chriskempson/base16-vim'

Plug 'kdheepak/firenvim', { 'do': function('firenvim#install') }

Plug 'zah/nim.vim'

" Initialize plugin system
call plug#end()

filetype plugin indent on    " required

set termguicolors
" Change colorscheme
colorscheme one
set background=light
let g:one_allow_italics = 1 " I love italic for comments

syntax enable           " enable syntax processing

filetype indent on

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

let mapleader = " " " Map leader to space
let maplocalleader = "\\" " Map leader to space

set smarttab
" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When on uses space instead of tabs
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

set autoindent
set smartindent
set backspace=indent,eol,start
set complete-=i

" wrap
let &showbreak='↳ '
set breakindent
set linebreak
set wrap

set spelllang=en
set spell
set spellfile=$HOME/config/spell/en.utf-8.add

" " Ignore case when searching
" set ignorecase
" " When searching try to be smart about cases
" set smartcase
" set incsearch           " search as characters are entered
" set hlsearch            " highlight matches
" Loupe does all this

set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]

" display
set display+=lastline

" Always use vertical diffs
set diffopt+=vertical

" show status at the bottom
set laststatus=2
set showmode

set number relativenumber " line numbers
set cursorline " highlight current line
" set cursorcolumn " highlight current column
set showcmd " show command in bottom bar

" buffer
set autoread
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
" set bomb
" set binary

set hidden

set fileformats=unix,dos,mac

set nobackup
set nowritebackup
set cmdheight=1
" set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set autowrite     " Automatically :write before running commands

set updatetime=300
set shortmess+=c

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

set mouse=a

set nofoldenable    " disable folding

" Always show git gutter / sign column
set signcolumn=yes

set inccommand=split

" wrap around line
set whichwrap+=h,l

set viminfo+=n~/.config/nvim/viminfo

set scrolloff=10

" Use one space, not two, after punctuation.
set nojoinspaces

" split windows right and below
set splitright
set splitbelow

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

 " visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Disable autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" resize panes when host window is resized
autocmd VimResized * wincmd =

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" highlight last inserted text
nnoremap gV `[v`]

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move vertically by actual line
nnoremap J j
nnoremap K k

set grepprg=rg\ --vimgrep

nnoremap Y y$

command! W w
command! -bang Q q
command! -bang Qa qa

"" Tabs
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>

noremap X V
noremap gj G
noremap gk gg

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" python
" vim-python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

" syntastic
let g:syntastic_python_checkers=['python', 'flake8']

" Syntax highlight
" Default highlight is better than polyglot
let g:polyglot_disabled = ['python', 'nim']
let python_highlight_all = 1

" vim-airline

let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
" let g:airline_skip_empty_sections = 1 " causes json to crash
let g:airline_section_c = '%t'

let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'

" air-line
" let g:airline_powerline_fonts = 1

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
    set undodir=~/.local/share/nvim/undo//
    set backupdir=~/.local/share/nvim/backup//
    set directory=~/.local/share/nvim/swap//
    set undofile
endif

let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 1

autocmd BufEnter * EnableStripWhitespaceOnSave
let g:strip_whitespace_confirm=0

" autocmd! BufWritePost * make

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" Use tab for indenting in visual mode
vnoremap <Tab> >gv|
vnoremap <S-Tab> <gv
nnoremap > >>_
nnoremap < <<_

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" Macros
nnoremap M @q
vnoremap M :norm @q<CR>

let g:neomake_python_flake8_maker = {
            \ 'errorformat':
            \ '%E%f:%l: could not compile,%-Z%p^,' .
            \ '%A%f:%l:%c: %t%n %m,' .
            \ '%A%f:%l: %t%n %m,' .
            \ '%-G%.%#'
            \ }
let g:neomake_python_enabled_makers = ['flake8']

" Ensure comments don't go to beginning of line by default

au! FileType python setl nosmartindent

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" vim-markdown
let g:vim_markdown_conceal = 0
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_folding_disabled = 1

let g:deoplete#enable_at_startup = 1
" Pass a dictionary to set multiple options
call deoplete#custom#option({
\ 'auto_complete_delay': 200,
\ 'smart_case': v:true,
\ })

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ deoplete#mappings#manual_complete()

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

let g:racer_cmd = "~/.cargo/bin/racer"
if executable('racer')
  let g:deoplete#sources#rust#racer_binary = systemlist('which racer')[0]
endif

let g:deoplete#sources#rust#rust_source_path = expand('~/GitRepos/rust/src')

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

set virtualedit+=all

set nomodeline

let g:gitgutter_override_sign_column_highlight = 0

highlight clear SignColumn

let g:latex_to_unicode_auto = 1
let g:latex_to_unicode_tab = 0
let g:latex_to_unicode_cmd_mapping = ['<C-J>']

" TODO: add shortcut to transform string
let g:unicoder_cancel_normal = 1
let g:unicoder_cancel_insert = 1
let g:unicoder_cancel_visual = 1
let g:unicoder_no_map = 1

"
" 'Yggdroot/indentLine'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" jsonc comment syntax highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+
" disable indent line plugin for json
" autocmd Filetype json :IndentLinesDisable

" reformat paragraph
nnoremap <silent> <leader>q vapkJgqap
vnoremap <silent> <leader>q Jgqap

nnoremap <leader>a :Autoformat<CR>

" TODO: Searches for word and always replacing
" nnoremap <leader>s <Esc>* \| :%s///g<Left><Left> " TODO: doesn't work as expected

" remap Join lines and help
" nnoremap <leader>J J
" nnoremap <leader>H K

nnoremap <silent> <leader>sh :terminal<CR>
nnoremap <silent> <leader><Enter> :terminal<CR>
nnoremap <silent> <localleader><localleader> <C-^>
nnoremap <silent> <BS> <C-^>

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
" redo
nnoremap U <C-R>

" edit vimrc/zshrc/tmux and load vimrc bindings
nnoremap <silent> <leader>ev :vsp $MYVIMRC<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
nnoremap <silent> <leader>ez :vsp ~/.zshrc<CR>

"" Git
noremap <leader>ga :Gwrite<CR>
noremap <leader>gc :Gcommit<CR>
noremap <leader>gsh :Gpush<CR>
noremap <leader>gll :Gpull<CR>
noremap <leader>gs :Gstatus<CR>
noremap <leader>gb :Gblame<CR>
noremap <leader>gd :Gvdiff<CR>
noremap <leader>gr :Gremove<CR>
" Open current line on GitHub
nnoremap <leader>go :.Gbrowse<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Opens an edit command with the path of the currently edited file filled in
noremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled
noremap <leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

nnoremap yy V"+y
vnoremap <leader>y "+y
noremap <leader>p "+gP<CR>

nmap <leader>z <Plug>(zoom-toggle)
nnoremap <leader>ss :StripWhitespace<CR>

" Buffers
" nnoremap <silent> <leader>bb :Denite buffer<CR>

" Close buffer
noremap <leader>ww :bw<CR>

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" " Command ':Bdelete' executes ':bd' to delete buffer in current window.
" " The window will show the alternate buffer (Ctrl-^) if it exists,
" " or the previous buffer (:bp), or a blank buffer if no previous.
" " Command ':Bdelete!' is the same, but executes ':bd!' (discard changes).
" " An optional argument can specify which buffer to close (name or number).

" function! s:Bdelete(bang, buffer)
"   if empty(a:buffer)
"     let btarget = bufnr('%')
"   elseif a:buffer =~ '^\d\+$'
"     let btarget = bufnr(str2nr(a:buffer))
"   else
"     let btarget = bufnr(a:buffer)
"   endif
"   if btarget < 0
"     call s:Warn('No matching buffer for '.a:buffer)
"     return
"   endif
"   if empty(a:bang) && getbufvar(btarget, '&modified')
"     call s:Warn('No write since last change for buffer '.btarget.' (use :Bdelete!)')
"     return
"   endif
"   " Numbers of windows that view target buffer which we will delete.
"   let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
"   if len(wnums) > 1
"     execute 'close'.a:bang
"     return
"   endif
"   let wcurrent = winnr()
"   for w in wnums
"     execute w.'wincmd w'
"     let prevbuf = bufnr('#')
"     if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
"       buffer #
"     else
"       bprevious
"     endif
"     if btarget == bufnr('%')
"       " Numbers of listed buffers which are not the target to be deleted.
"       let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
"       " Listed, not target, and not displayed.
"       let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
"       " Take the first buffer, if any (could be more intelligent).
"       let bjump = (bhidden + blisted + [-1])[0]
"       if bjump > 0
"         execute 'buffer '.bjump
"       else
"         execute 'enew'.a:bang
"       endif
"     endif
"   endfor
"   execute 'bdelete'.a:bang.' '.btarget
"   execute wcurrent.'wincmd w'
" endfunction
" command! -bang -complete=buffer -nargs=? Bdelete call <SID>Bdelete('<bang>', '<args>')

" " Allows closing windows without closing buffers and remaps q to this action
" cabbrev q    <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'Bdelete' : 'q')<CR>
" cabbrev wq   <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'w\|Bdelete' : 'wq')<CR>

nnoremap <leader>o :only<CR>

" autocmd BufEnter,BufWinEnter,WinEnter term://* startinsert
" autocmd BufLeave term://* stopinsert
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen term://* startinsert

augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

nmap <leader><leader> <Plug>(LoupeClearHighlight)

" The default of 31 is just a little too narrow.
" let g:NERDTreeWinSize=40

" Disable display of '?' text and 'Bookmarks' label.
" let g:NERDTreeMinimalUI=1

" Let <Leader><Leader> (^#) return from NERDTree window.
" let g:NERDTreeCreatePrefix='silent keepalt keepjumps'

" Single-click to toggle directory nodes, double-click to open non-directory
" nodes.
" let g:NERDTreeMouseMode=2

" let g:NERDTreeQuitOnOpen=1

" nnoremap <leader>n :NERDTreeToggle<CR>
" let NERDTreeHijackNetrw = 0
" let g:ranger_replace_netrw = 1

nnoremap <leader>r :tabe %:p:h<CR>

" Repurpose cursor keys
nnoremap <silent> <Up> :cprevious<CR>
nnoremap <silent> <Down> :cnext<CR>
nnoremap <silent> <Left> :cpfile<CR>
nnoremap <silent> <Right> :cnfile<CR>

nmap <silent> tt :tabnew<CR>
nmap <silent> [g :tabprevious<CR>
nmap <silent> ]g :tabnext<CR>
nmap <silent> [G :tabrewind<CR>
nmap <silent> ]G :tablast<CR>


" " tell denite to use this matcher by default for all sources
" call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
" nnoremap <leader>fl :Denite line<cr>
" nnoremap <leader>fg :Denite grep<cr>

" nnoremap <leader>wl :DeniteCursorWord line<cr>
" nnoremap <leader>wg :DeniteCursorWord grep<cr>

" nnoremap <leader>pl :DeniteProjectDir line<cr>
" nnoremap <leader>pg :DeniteProjectDir grep<cr>

" nnoremap <silent> <leader>rg :Denite grep<CR>

hi link deniteMatchedChar Special

" optional - but recommended - see below
let g:fruzzy#usenative = 1

call denite#custom#var('file/rec', 'command',
            \ ['rg', '--hidden', '--files', '--glob', '!.git'])

" Ripgrep command on grep source
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
call denite#custom#option('_', 'input', '')
call denite#custom#option('default', 'prompt', ' ')
call denite#custom#option('_', 'start_filter', v:true)
call denite#custom#option('_', 'auto_resize', v:false)
call denite#custom#option('_', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('_', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('_', 'highlight_matched_range', 'Tag')
call denite#custom#option('_', 'highlight_matched_char', 'Tag')
call denite#custom#option('_', 'split', 'vertical')
call denite#custom#option('_', 'winminheight', 1)

let g:session_directory = expand('~').'/.config/nvim/.vim-sessions'

function! s:denite_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> dd
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
endfunction

function! s:denite_filter_settings() abort
  imap <silent><buffer><expr> <Esc> denite#do_map('quit')
endfunction

autocmd FileType denite-filter call s:denite_filter_settings()
autocmd FileType denite call s:denite_settings()

nnoremap <silent> <leader>* :Denite grep:::`expand('<cword>')`<CR>
nnoremap <silent> <leader>b :<C-u>Denite buffer<cr>
nnoremap <silent> <leader>f :<C-u>Denite file/rec buffer<cr>
nnoremap <silent> <leader>o :<C-u>DeniteProjectDir file/rec<cr>
nnoremap <silent> <leader>rg :Denite grep<CR>
nnoremap <silent> <localleader>: :<C-u>Denite command<cr>
nnoremap <silent> <localleader>c :<C-u>Denite change<cr>
nnoremap <silent> <localleader>h :<C-u>Denite help<cr>
nnoremap <silent> <localleader>j :<C-u>Denite jump<cr>
nnoremap <silent> <localleader>l :<C-u>Denite line<cr>
nnoremap <silent> <localleader>m :<C-u>Denite mark<cr>
nnoremap <silent> <localleader>s :<C-u>Denite session<cr>
nnoremap <silent> <localleader>t :<C-u>DeniteProjectDir tag<cr>
" interactive grep mode


" delete buffer
" works nicely in terminal mode as well
nnoremap <silent> <C-d><C-d> :confirm bd<cr>

" Open ranger at current file with "-"
nnoremap <silent> - :RangerCurrentFile<CR>

" Open ranger in current working directory
nnoremap <silent> <Leader>r :Ranger<CR>

" for setting ranger viewmode values
let g:neoranger_viewmode='miller' " supported values are ['multipane', 'miller']

" for setting any extra option passed to ranger params
" let g:neoranger_opts='--cmd="set show_hidden true"' " this line makes ranger show hidden files by default

nnoremap QQ q:I
nnoremap Q: <NOP>
nnoremap q: <NOP>
" nnoremap : q:I

" tmuxline
" let g:tmuxline_preset = {
      " \'a'    : '#S',
      " \'b'    : '#W',
      " \'c'    : '#{prefix_highlight}',
      " \'win'  : '#I #W',
      " \'cwin' : '#I #W',
      " \'x'    : '%a',
      " \'y'    : '%R',
      " \'z'    : '#{battery_percentage}'}

":PromptlineSnapshot! ~/GitRepos/dotfiles/promptline.sh airline<CR>

if has('nvim') && executable('nvr')
  " pip install neovim-remote
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  " send the escape key to the temrinal
  tnoremap <A-[> <Esc>
  " tnoremap <c-h> <c-\><c-n><c-w>h
  " tnoremap <c-j> <c-\><c-n><c-w>j
  " tnoremap <c-k> <c-\><c-n><c-w>k
  " tnoremap <c-l> <c-\><c-n><c-w>l
  tnoremap <expr> <A-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'
  hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#f00000 cterm=NONE gui=NONE

  "" Split
  " noremap <leader>\| :vsp|wincmd l|terminal<CR>
  " noremap <leader>-  :NvimuxHorizontalSplit<CR>
  noremap <silent> <leader>- :split\|wincmd j\|terminal<CR>
  noremap <silent> <leader>\| :vsplit\|wincmd l\|terminal<CR>
endif

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

set grepprg=rg\ --vimgrep

set redrawtime=10000

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'julia': ['~/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia', '--startup-file=no', '--history-file=no', '--project', '-e', '
    \       using LanguageServer;
    \       using Pkg;
    \       env_path = dirname(Pkg.Types.Context().env.project_file);
    \       debug = false;
    \       server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "");
    \       server.runlinter = true;
    \       run(server);
    \   '],
    \ 'python': ['~/miniconda3/bin/pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ }
