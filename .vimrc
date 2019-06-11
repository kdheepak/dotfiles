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

Plug 'morhetz/gruvbox'
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
" Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-jdaddy'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'gregsexton/gitv', {'on': ['Gitv']}
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-niceblock'
Plug 'mbbill/undotree'
Plug 'reedes/vim-wordy'
Plug 'wellle/tmux-complete.vim'
Plug 'farmergreg/vim-lastplace'
Plug 'ntpeters/vim-better-whitespace'
Plug 'w0rp/ale'
" Plug 'neomake/neomake'
Plug 'Yggdroot/indentLine' " Enables LaTeX formatting for some reason
" Plug 'thaerkh/vim-indentguides'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'Raimondi/delimitMate'
Plug 'danro/rename.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'davidhalter/jedi-vim'
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

Plug 'kdheepak/SearchHighlighting.vim'
Plug 'kdheepak/gridlabd.vim'
Plug 'baabelfish/nvim-nim'

Plug 'vim-scripts/DrawIt'
Plug 'gyim/vim-boxdraw'

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'joom/latex-unicoder.vim'

" Or install latest release tag
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-rls'
Plug 'neoclide/coc-python'
Plug 'neoclide/coc-highlight'
Plug 'neoclide/coc-git'
Plug 'neoclide/coc-yank'
Plug 'neoclide/coc-lists'
Plug 'neoclide/coc-vimtex'
Plug 'neoclide/coc-denite'
" Plug 'neoclide/coc-github'
" Plug 'neoclide/coc-dictionary'
" Plug 'neoclide/coc-tag'
" Plug 'neoclide/coc-emoji'
" Plug 'neoclide/coc-omni'
" Plug 'neoclide/coc-syntax'
" Plug 'neoclide/coc-ultisnips'
" Plug 'neoclide/coc-neosnippet'
" Plug 'neoclide/coc-browser'
" Plug 'neoclide/coc-marketplace'

Plug 'Shougo/denite.nvim'
Plug 'chemzqm/denite-extra'
Plug 'chemzqm/denite-git'

" Initialize plugin system
call plug#end()

filetype plugin indent on    " required

" Call the theme one
colorscheme gruvbox

syntax enable           " enable syntax processing

filetype indent on

" Note, the above line is ignored in Neovim 0.1.5 above, use this line instead.
set termguicolors

let mapleader = ' ' " Map leader to space

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

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase

set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

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

" nnoremap <silent> Q gqap
" xnoremap <silent> Q gq
" reformat paragraph
nnoremap <silent> <leader>q vapkJgqap
vnoremap <silent> <leader>q Jgqap

" turn off search highlight
nnoremap <silent> <leader><Space> :nohlsearch<Bar>:echo<CR>

nnoremap <leader>a :Autoformat<CR>

" TODO: Searches for word and always replacing
:nnoremap <leader>s <Esc>* \| :%s///g<Left><Left>

" remap Join lines and help
" nnoremap <leader>J J
" nnoremap <leader>H K

nnoremap <silent> <leader>sh :terminal<CR>

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" edit vimrc/zshrc/tmux and load vimrc bindings
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
nnoremap <silent> <leader>ez :e ~/.zshrc<CR>
nnoremap <silent> <leader>et :e ~/.tmux.conf<CR>

"" Split
noremap <leader>h :<C-u>split<CR>
noremap <leader>v :<C-u>vsplit<CR>

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

" Buffers
nnoremap <silent> <leader>bb :Buffers<CR>
noremap <leader>bls :ls<CR>

" Buffer nav
noremap <leader>bp :bp<CR>
noremap <leader>bn :bn<CR>

" Close buffer
noremap <leader>bd :bd<CR>
noremap <leader>bw :bw<CR>

nnoremap <silent> <leader>rg :FZF -m<CR>

" https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
" Add Find command to vim
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Use rg for grepprg
set grepprg=rg\ --vimgrep

" Use deoplete.
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#sources#jedi#show_docstring = 1

" if !exists('g:deoplete#omni#input_patterns')
    " let g:deoplete#omni#input_patterns = {}
" endif

" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" autocmd CompleteDone * pclose " To close preview window of deoplete automagically

" deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
" let g:neosnippet#snippets_directory='~/.config/nvim/snippets/'

nnoremap Y y$

command! W w
command! WQ wq
command! Wq wq
command! Q q
command! Qa qa
command! QA qa

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

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
let g:polyglot_disabled = ['python']
let python_highlight_all = 1

" vim-airline

" let g:airline_theme = 'gruvbox'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#tabline#fnamemod = ':t'

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

nnoremap * *N

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

" julia
let g:default_julia_version = '0.6'

" language server
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
\   'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
\       using LanguageServer;
\       server = LanguageServer.LanguageServerInstance(STDIN, STDOUT, false);
\       server.runlinter = true;
\       run(server);
\   '],
\ }

nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> <F3> :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> <F4> :call LanguageClient_textDocument_definition()<CR>

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

" coc.nvim
let g:coc_node_path = expand("~/miniconda3/bin/node")
" :CocInstall coc-dictionary
" :CocInstall coc-tag
" :CocInstall coc-emoji
" :CocInstall coc-omni
" :CocInstall coc-syntax
" :CocInstall coc-ultisnips
" :CocInstall coc-neosnippet
" :CocInstall coc-browser
" :CocInstall coc-json
" :CocInstall coc-rls
" :CocInstall coc-python
" :CocInstall coc-highlight
" :CocInstall coc-git
" :CocInstall coc-yank
" :CocInstall coc-lists
" :CocInstall coc-marketplace
" :CocInstall coc-vimtex
" :CocInstall coc-github

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <leader>cla  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>cle  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>clc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>clo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>cls  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>ccj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>cck  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>clp  :<C-u>CocListResume<CR>

" Denite

" reset 50% winheight on window resize
augroup deniteresize
  autocmd!
  autocmd VimResized,VimEnter * call denite#custom#option('default',
        \'winheight', winheight(0) / 2)
augroup end

call denite#custom#option('default', {
      \ 'prompt': '❯'
      \ })

call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
      \ ['--hidden', '--vimgrep', '--smart-case'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
endfunction

















