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

""""                                                              | " vim integration with external tools
Plug 'junegunn/fzf'                                               | " main fzf plugin
Plug 'junegunn/fzf.vim'                                           | " fuzzy finding plugin
Plug 'itchyny/calendar.vim'                                       | " calendar application
Plug 'glacambre/firenvim', { 'do': function('firenvim#install') } | " turn your browser into a Neovim client.
Plug 'Lokaltog/neoranger'                                         | " Neoranger is a simple ranger wrapper script for neovim.
Plug 'kassio/neoterm'                                             | " Use the same terminal for everything. The main reason for this plugin is to reuse the terminal easily.
Plug 'wincent/terminus'                                           | " Terminal integration improvements
""""                                                              | " git
Plug 'tyru/open-browser.vim'                                      | " Opens url in browser
Plug 'tyru/open-browser-unicode.vim'                              | " Opens current character or unicode in browser
Plug 'tyru/open-browser-github.vim'                               | " Opens github repo or github issue in browser
Plug 'rhysd/git-messenger.vim'                                    | " reveal a hidden message from git under the cursor quickly
Plug 'tpope/vim-fugitive'                                         | " vim plugin for Git that is so awesome, it should be illegal
Plug 'tpope/vim-rhubarb'                                          | " vim plugin for github
""""                                                              | " tmux
Plug 'edkolev/tmuxline.vim'                                       | " tmux statusline generator with support for powerline symbols and vim/airline/lightline statusline integration
Plug 'wellle/tmux-complete.vim'                                   | " insert mode completion of words in adjacent tmux panes
Plug 'tmux-plugins/vim-tmux'                                      | " vim plugin for editing .tmux.conf files
Plug 'christoomey/vim-tmux-navigator'                             | " navigate seamlessly between vim and tmux splits using a consistent set of hotkeys
Plug 'tmux-plugins/vim-tmux-focus-events'                         | " FocusGained and FocusLost autocommand events are not working in terminal vim. This plugin restores them when using vim inside Tmux
Plug 'jpalardy/vim-slime'                                         | " You can type text in a file, send it to a live REPL, and avoid having to reload all your code every time you make a change
""""                                                              | " vim themes
Plug 'airblade/vim-gitgutter'                                     | " shows a git diff in the 'gutter' (sign column)
Plug 'vim-airline/vim-airline'                                    | " airline status bar
Plug 'vim-airline/vim-airline-themes'                             | " official theme repository
Plug 'rakr/vim-one'                                               | " Light and dark vim colorscheme
" Plug 'morhetz/gruvbox'                                          |
" Plug 'chriskempson/base16-vim'                                  |
""""                                                              | " vim extensions features
Plug 'norcalli/nvim-colorizer.lua'                                | " a high-performance color highlighter for Neovim which has no external dependencies
Plug 'machakann/vim-highlightedyank'                              | " Make the yanked region apparent!
Plug 'junegunn/vim-peekaboo'                                      | " extends double quote and at sign in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers
Plug 'itchyny/vim-cursorword'                                     | " underlines the word under the cursor
Plug 'godlygeek/tabular'                                          | " line up text
Plug 'tpope/vim-commentary'                                       | " comment and uncomment stuff
Plug 'tpope/vim-unimpaired'                                       | " complementary pairs of mappings
Plug 'tpope/vim-surround'                                         | " all about surroundings: parentheses, brackets, quotes, XML tags, and more.
Plug 'tpope/vim-repeat'                                           | " Repeat.vim remaps . in a way that plugins can tap into it.
Plug 'tpope/vim-tbone'                                            | " Basic tmux support for vim
Plug 'tpope/vim-jdaddy'                                           | " mappings for working with json in vim
Plug 'tpope/vim-obsession'                                        | " no hassle vim sessions
Plug 'dhruvasagar/vim-zoom'                                       | " toggle zoom of current window within the current tab
Plug 'kana/vim-niceblock'                                         | " makes blockwise Visual mode more useful and intuitive
Plug 'mbbill/undotree'                                            | " visualizes undo history and makes it easier to browse and switch between different undo branches
Plug 'reedes/vim-wordy'                                           | " uncover usage problems in your writing
Plug 'farmergreg/vim-lastplace'                                   | " intelligently reopen files at your last edit position
Plug 'ntpeters/vim-better-whitespace'                             | " causes all trailing whitespace characters to be highlighted
Plug 'Yggdroot/indentLine'                                        | " displaying thin vertical lines at each indentation level for code indented with spaces
Plug 'jeffkreeftmeijer/vim-numbertoggle'                          | " numbertoggle switches to absolute line numbers (:set number norelativenumber) automatically when relative numbers don't make sense
Plug 'dhruvasagar/vim-table-mode'                                 | " automatic table creator & formatter allowing one to create neat tables as you type
Plug 'airblade/vim-rooter'                                        | " rooter changes the working directory to the project root when you open a file or directory
Plug 'joom/latex-unicoder.vim'                                    | " A plugin to type Unicode chars in Vim, using their LaTeX names
Plug 'editorconfig/editorconfig-vim'                              | " editorconfig plugin for vim
Plug 'haya14busa/vim-asterisk'                                    | " asterisk.vim provides improved * motions.
Plug 'google/vim-searchindex'                                     | " This plugin shows how many times a search pattern occurs in the current buffer.
Plug 'ryanoasis/vim-devicons'                                     | " Adds icons to plugins
Plug 'segeljakt/vim-isotope'                                      | " insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,
Plug 'pbrisbin/vim-mkdir'                                         | " automatically create any non-existent directories before writing the buffer
Plug 'kshenoy/vim-signature'                                      | " toggle display and navigate marks
""""                                                              | " vim programming language features
Plug 'roxma/nvim-yarp'                                            | " yet another remote plugin framework for neovim
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}     | " vim-plug with on-demand support for the Requirements File Format syntax for vim
Plug 'Vimjas/vim-python-pep8-indent'                              | " A nicer Python indentation style for vim
Plug 'rust-lang/rust.vim'                                         | " Rust file detection, syntax highlighting, formatting, Syntastic integration, and more
Plug 'JuliaEditorSupport/julia-vim'                               | " Julia support for vim
Plug 'kdheepak/gridlabd.vim'                                      | " gridlabd syntax support
Plug 'zah/nim.vim'                                                | " syntax highlighting auto indent for nim in vim
Plug 'neovim/nvim-lsp'                                            | " collection of common configurations for the Nvim LSP client.
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }     | " dark powered asynchronous completion framework for neovim/Vim8
Plug 'ncm2/float-preview.nvim'                                    | " Completion preview window based on neovim's floating window
Plug 'gpanders/vim-medieval'                                      | " Evaluate markdown code blocks within vim
Plug 'kdheepak/JuliaFormatter.vim'                                | " Formatter for Julia
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/1.x',
  \ 'for': [
    \ 'javascript',
    \ 'typescript',
    \ 'css',
    \ 'less',
    \ 'scss',
    \ 'json',
    \ 'graphql',
    \ 'markdown',
    \ 'vue',
    \ 'lua',
    \ 'python',
    \ 'html', ] }

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

" wrap
let &showbreak='↳ '
set breakindent
set linebreak
set wrap

" set spelllang=en
" set spell
" set spellfile=$HOME/config/spell/en.utf-8.add

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

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

set complete-=i

" buffer
set autoread
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
" set bomb
" set binary

set hidden

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

set scrolloff=20

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

" highlight last inserted text
nnoremap gV `[v`]

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move vertically by actual line
nnoremap J j
nnoremap K k
nnoremap H ^
nnoremap L $

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
noremap gh ^
noremap gl $

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
au! FileType vim,python setl nosmartindent

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" vim-markdown
let g:vim_markdown_conceal = 0
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_folding_disabled = 1

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

let g:gitgutter_override_sign_column_highlight = 1
highlight SignColumn guibg=bg
highlight SignColumn ctermbg=bg

let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▋'

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
noremap <leader>gs :Magit<CR>
noremap <leader>gb :Gblame<CR>
noremap <leader>gd :Gvdiff<CR>
noremap <leader>gr :Gremove<CR>
" Open current line in the browser
nnoremap <Leader>go :.Gbrowse<CR>
" Open visual selection in the browser
vnoremap <Leader>go :Gbrowse<CR>


nnoremap <Leader>gm <Plug>(git-messenger)

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Run last tabularize command
nnoremap <leader>t :Tabularize<CR>
vnoremap <leader>t :Tabularize<CR>

nnoremap yy V"+y
vnoremap <leader>y "+y
noremap <leader>p "+gP<CR>

nnoremap <leader>z <Plug>(zoom-toggle)
nnoremap <leader>ss :StripWhitespace<CR>

" Buffers

" Close buffer
nnoremap <leader>ww :bw<CR>

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

" Clear highlighting
nnoremap <leader><leader> :noh<return><esc>

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

" delete buffer
" works nicely in terminal mode as well
nnoremap <silent> <C-d><C-d> :confirm bd<cr>
nnoremap <silent> <leader>d :confirm bd<cr>

let g:fzf_command_prefix = 'Fzf'
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-g': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'down': '~40%' }

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* FzfRgPreview
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --no-heading --color=always --smart-case '.shellescape(<q-args>), 2,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%', 'ctrl-l'),
  \   <bang>0)

" Files command with preview window
command! -bang -nargs=? -complete=dir FzfFilesPreview
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%:hidden', 'ctrl-l'), <bang>0)

function! s:find_git_root()
  return system('cd '. expand('%:p:h') . ' && git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! FzfProjectFilesPreview execute 'FzfFiles ' . s:find_git_root()

" Open ranger at current file with "-"
nnoremap <silent> - :RangerCurrentFile<CR>
nnoremap <Leader>f :FzfProjectFilesPreview<CR>
nnoremap <Leader>rg :FzfRgPreview<CR>
nnoremap <Leader>b :FzfBuffers<CR>

" for setting ranger viewmode values
let g:neoranger_viewmode='miller' " supported values are ['multipane', 'miller']

" for setting any extra option passed to ranger params
let g:neoranger_opts='--cmd="set show_hidden true"' " this line makes ranger show hidden files by default

nnoremap QQ q:I
nnoremap Q: <NOP>
nnoremap q: <NOP>
" nnoremap : q:I

" tmuxline
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '%a',
      \'y'    : '%Y-%m-%d  %R',
      \'z'    : '#(~/.tmux/plugins/tmux-battery/scripts/battery_percentage.sh)'
\ }

let g:tmuxline_status_justify = 'left'

":PromptlineSnapshot! ~/gitrepos/dotfiles/promptline.sh airline<CR>

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

set grepprg=rg\ --vimgrep

set redrawtime=10000

lua << EOF
    -- require'nvim_lsp'.nimls.setup{}
    require'nvim_lsp'.julials.setup{}
    require'nvim_lsp'.pyls.setup{}
    require'nvim_lsp'.vimls.setup{}
EOF

nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>lh    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> <leader>lk    <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>lr    <cmd>lua vim.lsp.buf.references()<CR>

autocmd Filetype c,cpp,python,julia,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

" let g:LanguageClient_serverCommands = {
"     \ 'vim': ['vim-language-server', '--stdio'],
"     \ 'julia': ['julia', '--project', '--startup-file=no', '--history-file=no', '-e', '
"     \       using LanguageServer;
"     \       using Pkg;
"     \       env_path = dirname(Pkg.Types.Context().env.project_file);
"     \       debug = false;
"     \
"     \       server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "");
"     \       server.runlinter = true;
"     \       run(server);
"     \   ']
"     \ }
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_virtualTextPrefix = ''
" let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')
"
" function! LC_maps()
"   if has_key(g:LanguageClient_serverCommands, &ft)
"     nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
"     inoremap <buffer> <silent> <c-i> <c-o>:call LanguageClient#textDocument_hover()<cr>
"     nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
"     nnoremap <buffer> <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
"   endif
" endfunction
"
" autocmd BufEnter * call LC_maps()

" tyru/open-browser.vim
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-open)
vmap gx <Plug>(openbrowser-open)

set completeopt=menuone    " Use the popup menu also when there is only one match.
set completeopt+=noinsert  " Do not insert any text for a match until the user selects a match from the menu.
set completeopt+=noselect  " Do not select a match in the menu, force the user to select one from the menu.
set completeopt-=preview   " Remove extra information about the currently selected completion in the preview window.
                           " Only works in combination with "menu" or "menuone".

set shortmess+=c   " Shut off completion messages
set shortmess+=I   " no intro message

let g:deoplete#enable_at_startup = 1

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ deoplete#manual_complete()

inoremap <silent><expr> <s-TAB> pumvisible() ? "\<C-p>" :
\ <SID>check_back_space() ? "\<BS>" :
\ deoplete#manual_complete()

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

let g:float_preview#docked = 0

" let g:mucomplete#enable_auto_at_startup = 1
" let g:mucomplete#chains = {}
" let g:mucomplete#chains.default = ['omni', 'c-n', 'path', 'tags', 'dict']
" let s:cpp_cond = { t -> t =~# '\%(->\|::\|\.\)$' }
" let g:mucomplete#can_complete = {}
" let g:mucomplete#can_complete.cpp = { 'omni': s:cpp_cond }

nnoremap <localleader>jf :<C-u>call JuliaFormatter#Format(0)<CR>
vnoremap <localleader>jf :<C-u>call JuliaFormatter#Format(1)<CR>

let g:prettier#config#prose_wrap = 'always'

" vim-asterisk
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)

let g:asterisk#keeppos = 1

let g:medieval_langs = ['python=python3', 'julia', 'sh', 'console=bash']
nnoremap <buffer> Z! :<C-U>EvalBlock<CR>

let g:slime_target = "tmux"
