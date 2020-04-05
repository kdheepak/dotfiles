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
Plug 'junegunn/fzf'                                               | " main fzf
Plug 'junegunn/fzf.vim'                                           | " fuzzy finding plugin
Plug 'yuki-ycino/fzf-preview.vim'                                 | " add floating window support for fzf
Plug 'itchyny/calendar.vim'                                       | " calendar application
Plug 'glacambre/firenvim', { 'do': function('firenvim#install') } | " turn your browser into a Neovim client.
Plug 'Lokaltog/neoranger'                                         | " neoranger is a simple ranger wrapper script for neovim.
Plug 'kassio/neoterm'                                             | " use the same terminal for everything. The main reason for this plugin is to reuse the terminal easily.
Plug 'wincent/terminus'                                           | " terminal integration improvements
""""                                                              | " git
Plug 'tyru/open-browser.vim'                                      | " opens url in browser
Plug 'tyru/open-browser-unicode.vim'                              | " opens current character or unicode in browser
Plug 'tyru/open-browser-github.vim'                               | " opens github repo or github issue in browser
Plug 'rhysd/git-messenger.vim'                                    | " reveal a hidden message from git under the cursor quickly
Plug 'tpope/vim-fugitive'                                         | " vim plugin for Git that is so awesome, it should be illegal
Plug 'tpope/vim-rhubarb'                                          | " vim plugin for github
Plug 'samoshkin/vim-mergetool'                                    | " Merge tool for git
Plug '~/gitrepos/lazygit.vim'                                     | " lazygit
""""                                                              | " tmux
Plug 'edkolev/tmuxline.vim'                                       | " tmux statusline generator with support for powerline symbols and vim/airline/lightline statusline integration
Plug 'wellle/tmux-complete.vim'                                   | " insert mode completion of words in adjacent tmux panes
Plug 'tmux-plugins/vim-tmux'                                      | " vim plugin for editing .tmux.conf files
Plug 'christoomey/vim-tmux-navigator'                             | " navigate seamlessly between vim and tmux splits using a consistent set of hotkeys
Plug 'tmux-plugins/vim-tmux-focus-events'                         | " focusGained and FocusLost autocommand events are not working in terminal vim. This plugin restores them when using vim inside Tmux
Plug 'jpalardy/vim-slime'                                         | " you can type text in a file, send it to a live REPL, and avoid having to reload all your code every time you make a change
""""                                                              | " vim themes
Plug 'airblade/vim-gitgutter'                                     | " shows a git diff in the 'gutter' (sign column)
Plug 'vim-airline/vim-airline'                                    | " airline status bar
Plug 'vim-airline/vim-airline-themes'                             | " official theme repository
Plug 'rakr/vim-one'                                               | " light and dark vim colorscheme
" Plug 'morhetz/gruvbox'                                          |
" Plug 'chriskempson/base16-vim'                                  |
""""                                                              | " vim extensions features
Plug 'bkad/CamelCaseMotion'                                       | " motions for inside camel case
Plug 'norcalli/nvim-colorizer.lua'                                | " a high-performance color highlighter for Neovim which has no external dependencies
Plug 'machakann/vim-highlightedyank'                              | " make the yanked region apparent!
Plug 'junegunn/vim-peekaboo'                                      | " extends double quote and at sign in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers
Plug 'itchyny/vim-cursorword'                                     | " underlines the word under the cursor
Plug 'junegunn/vim-easy-align'                                    | " helps alignment
Plug 'godlygeek/tabular'                                          | " line up text
Plug 'tpope/vim-commentary'                                       | " comment and uncomment stuff
Plug 'tpope/vim-unimpaired'                                       | " complementary pairs of mappings
Plug 'tpope/vim-surround'                                         | " all about surroundings: parentheses, brackets, quotes, XML tags, and more.
Plug 'tpope/vim-repeat'                                           | " repeat.vim remaps . in a way that plugins can tap into it.
Plug 'tpope/vim-tbone'                                            | " basic tmux support for vim
Plug 'tpope/vim-jdaddy'                                           | " mappings for working with json in vim
Plug 'tpope/vim-obsession'                                        | " no hassle vim sessions
Plug 'tpope/vim-speeddating'                                      | " Tools for working with dates
Plug 'dhruvasagar/vim-zoom'                                       | " toggle zoom of current window within the current tab
Plug 'kana/vim-niceblock'                                         | " makes blockwise Visual mode more useful and intuitive
Plug 'mbbill/undotree'                                            | " visualizes undo history and makes it easier to browse and switch between different undo branches
Plug 'reedes/vim-wordy'                                           | " uncover usage problems in your writing
Plug 'farmergreg/vim-lastplace'                                   | " intelligently reopen files at your last edit position
Plug 'ntpeters/vim-better-whitespace'                             | " causes all trailing whitespace characters to be highlighted
Plug 'nathanaelkane/vim-indent-guides'                            | " displaying thin vertical lines at each indentation level for code indented with spaces
Plug 'jeffkreeftmeijer/vim-numbertoggle'                          | " numbertoggle switches to absolute line numbers (:set number norelativenumber) automatically when relative numbers don't make sense
Plug 'dhruvasagar/vim-table-mode'                                 | " automatic table creator & formatter allowing one to create neat tables as you type
Plug 'airblade/vim-rooter'                                        | " rooter changes the working directory to the project root when you open a file or directory
Plug 'joom/latex-unicoder.vim'                                    | " a plugin to type Unicode chars in Vim, using their LaTeX names
Plug 'editorconfig/editorconfig-vim'                              | " editorconfig plugin for vim
Plug 'haya14busa/vim-asterisk'                                    | " asterisk.vim provides improved * motions.
Plug 'google/vim-searchindex'                                     | " this plugin shows how many times a search pattern occurs in the current buffer.
Plug 'ryanoasis/vim-devicons'                                     | " adds icons to plugins
Plug 'segeljakt/vim-isotope'                                      | " insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,
Plug 'pbrisbin/vim-mkdir'                                         | " automatically create any non-existent directories before writing the buffer
Plug 'kshenoy/vim-signature'                                      | " toggle display and navigate marks
Plug 'wellle/targets.vim'                                         | " Move text objects
Plug 'sedm0784/vim-you-autocorrect'                               | " Automatic autocorrect
""""                                                              | " vim programming language features
Plug 'vim-vdebug/vdebug'                                          | " Debugging, loaded manually
Plug 'roxma/nvim-yarp'                                            | " yet another remote plugin framework for neovim
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}     | " vim-plug with on-demand support for the Requirements File Format syntax for vim
Plug 'Vimjas/vim-python-pep8-indent'                              | " a nicer Python indentation style for vim
Plug 'rust-lang/rust.vim'                                         | " rust file detection, syntax highlighting, formatting, Syntastic integration, and more
Plug 'JuliaEditorSupport/julia-vim'                               | " julia support for vim
Plug 'kdheepak/gridlabd.vim'                                      | " gridlabd syntax support
Plug 'zah/nim.vim'                                                | " syntax highlighting auto indent for nim in vim
Plug 'neovim/nvim-lsp'                                            | " collection of common configurations for the Nvim LSP client.
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }     | " dark powered asynchronous completion framework for neovim/Vim8
Plug 'ncm2/float-preview.nvim'                                    | " completion preview window based on neovim's floating window
Plug 'gpanders/vim-medieval'                                      | " evaluate markdown code blocks within vim
Plug 'kdheepak/JuliaFormatter.vim'                                | " formatter for Julia
Plug 'iamcco/markdown-preview.nvim'                               | " Markdown preview
Plug 'inkarkat/vim-ingo-library'                                  | " Spellcheck dependency
Plug 'inkarkat/vim-spellcheck'                                    | " Spelling errors to quickfix list
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

syntax enable | " enable syntax processing

set encoding=utf-8      | " Default file encoding
set fileencoding=utf-8  | " Default file encoding
set fileencodings=utf-8 | " Default file encoding
set noautochdir         | " Don't change dirs automatically
set noerrorbells        | " No sound
set hidden              | " Make buffers hidden then abandoned

set tabstop=4                    | " Number of spaces a <Tab> is
set softtabstop=4                | " Fine tunes the amount of white space to be added
set shiftwidth=4                 | " Number of spaces for indentation
set expandtab                    | " Expand tab to spaces
set spelllang=en                 | " Spell checking
set timeoutlen=500               | " Wait less time for mapped sequences
set smarttab                     | " <Tab> in front of line inserts blanks according to shiftwidth
set autoindent                   | " copy indent from current line
set smartindent                  | " do smart indenting when starting a new line
" set backspace=indent,eol,start | "allow backspacing over autoindent, line breaks, the start of insert

let &showbreak='↳ ' | " string to put at the start of lines that have been wrapped
set breakindent     | " every wrapped line will continue visually indented
set linebreak       | " wrap long lines at a character in breakat
set wrap            | " lines longer than the width of the window will wrap

let g:one_allow_italics = 1              | " I love italic for comments
colorscheme one                          | " sets theme to one
set background=light                     | " use light mode
set termguicolors                        | " enables 24bit colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1        | " enables true colors for Neovim 0.1.3 and 0.1.4
set novisualbell                         | " don't display visual bell
set noshowmode                           | " don't show mode changes
let &colorcolumn=121                     | " add indicator for 120
set display+=lastline                    | " as much as possible of the last line in a window will be displayed
set diffopt+=vertical                    | " Always use vertical diffs
set laststatus=2                         | " show status at the bottom
set number relativenumber                | " use line numbers and relative line numn
set cursorline                           | " highlight current line
set showcmd                              | " show command in bottom bar
set showmatch                            | " highlight matching [{()}]
set lazyredraw                           | " redraw only when we need to.
set ignorecase                           | " Ignore case when searching
set smartcase                            | " When searching try to be smart about cases
set incsearch                            | " search as characters are entered
set hlsearch                             | " highlight matches
set inccommand=split                     | " live search and replace
set wildmenu                             | " visual autocomplete for command menu
set autoread                             | " automatically read files that have been changed outside of vim
set nobackup                             | " no backup before overwriting a file
set nowritebackup                        | " no backups when writing a file
set autowrite                            | " Automatically :write before running commands
set list listchars=tab:»·,trail:·,nbsp:· | " Display extra whitespace
set mouse=a                              | " Enables mouse support
set nofoldenable                         | " disable folding
set signcolumn=yes                       | " Always show git gutter / sign column
set scrolloff=20                         | " Minimal number of lines to keep above and below the cursor
set nojoinspaces                         | " Use one space, not two, after punctuation
set splitright                           | " split windows right
set splitbelow                           | " split windows below
set viminfo+=n~/.config/nvim/viminfo     | " viminfo file
set virtualedit+=all                     | " allow virtual editing in all modes
set nomodeline                           | " no lines are checked for set commands
set grepprg=rg\ --vimgrep                | " use ripgrep
set redrawtime=10000                     | " set higher redrawtime so that vim does not hang on difficult syntax highlighting
" set noswapfile                         | " Don't write .swp files

if has("persistent_undo")
    set undodir=~/.local/share/nvim/undo//
    set backupdir=~/.local/share/nvim/backup//
    set directory=~/.local/share/nvim/swap//
    set undofile
endif

" Ensure comments don't go to beginning of line by default
autocmd! FileType vim,python setl nosmartindent
" Disable autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" resize panes when host window is resized
autocmd VimResized * wincmd =

" jsonc comment syntax highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+
" disable indent line plugin for json
" autocmd Filetype json :IndentLinesDisable

" autocmd BufEnter,BufWinEnter,WinEnter term://* startinsert
" autocmd BufLeave term://* stopinsert
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen term://* startinsert

" remove highlight on the cursorline when moving out of the window
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

" use built in neovim lsp for autocomplete
autocmd Filetype c,cpp,python,julia,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

autocmd BufEnter * EnableStripWhitespaceOnSave
let g:strip_whitespace_confirm=0

" autocmd! BufWritePost * make

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

let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 1

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

" vim-markdown
let g:vim_markdown_conceal = 0
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_folding_disabled = 1

" vim gitgutter
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

" 'Yggdroot/indentLine'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

let mapleader = " "       | " Map leader to space
let maplocalleader = "\\" | " Map localleader to \

" Markdown Preview
" Don't start markdown preview automatically, use :MarkdownPreview
let g:mkdp_auto_start = 0

" Merge Tool
" 3-way merge
let g:mergetool_layout = 'bmr'
let g:mergetool_prefer_revision = 'local'

" Camelcase Motion
" Sets up within word motions to use ,
let g:camelcasemotion_key = ','

" Indent Guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_color_change_percent = 1
let g:indent_guides_exclude_filetypes = ['help', 'fzf', 'openterm', 'neoterm', 'calendar']

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
nnoremap > >>_
nnoremap < <<_

" Use tab for indenting in visual mode
vnoremap <Tab> >gv|
vnoremap <S-Tab> <gv

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

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" copy to the end of line
nnoremap Y y$
" copy full line
nnoremap yy V"+y
" copy to clipboard
vnoremap <leader>y "+y
" paste from clipboard
noremap <leader>p "+gP<CR>

" allow W, Q to be used instead of w and q
command! W w
command! -bang Q q
command! -bang Qa qa

" Tabs
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>

" kakoune like mapping
noremap gj G
noremap gk gg
noremap gh ^
noremap gl $

" Macros
nnoremap Q @@
vnoremap Q :norm @@<CR>
nnoremap q: :q

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" reformat paragraph
nnoremap <silent> <leader>q vapkJgqap
vnoremap <silent> <leader>q Jgqap

nnoremap <silent> <leader>sh :terminal<CR>
nnoremap <silent> <leader><Enter> :terminal<CR>
nnoremap <silent> <localleader><localleader> <C-^>
nnoremap <silent> <BS> <C-^>

" toggle undo tree
nnoremap <leader>u :UndotreeToggle<CR>
" redo
nnoremap U <C-R>

" edit vimrc/zshrc/tmux and load vimrc bindings
nnoremap <silent> <leader>ev :vsp $MYVIMRC<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
nnoremap <silent> <leader>sl :luafile %<CR>
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
nnoremap <leader>go :.Gbrowse<CR>
" Open visual selection in the browser
vnoremap <leader>go :Gbrowse<CR>

" git messenger
nnoremap <leader>gm <Plug>(git-messenger)

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Run last tabularize command
nnoremap <leader>t :Tabularize<CR>
vnoremap <leader>t :Tabularize<CR>

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

nnoremap <leader>o :only<CR>

" Clear highlighting
nnoremap <leader><leader> :noh<return><esc>

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
nnoremap <silent> <leader>dd :confirm bd<cr>

" Open ranger at current file with "-"
nnoremap <silent> <leader>- :RangerCurrentFile<CR>

nnoremap <silent> <leader>ff :<c-u>FzfPreviewProjectFiles<CR>
nnoremap <silent> <leader>f/ :<c-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="'"<CR>
nnoremap <silent> <leader>f* :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort -add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap <silent> <leader>fb :<c-u>FzfPreviewAllBuffers<CR>
nnoremap <silent> <leader>fm :<c-u>FzfPreviewMarks<CR>
nnoremap <silent> <leader>fj :<c-u>FzfPreviewJumps<CR>
nnoremap <silent> <leader>fc :<c-u>FzfPreviewChanges<CR>
nnoremap <silent> <leader>ft :<c-u>FzfPreviewTags<CR>
nnoremap <silent> <leader>fg :<c-u>FzfPreviewGitStatus<CR>

let g:fzf_preview_floating_window_winblend = 5
let g:fzf_preview_command = 'bat --color=always --style=grid {-1}' " Installed bat

" for setting ranger viewmode values
let g:neoranger_viewmode='miller' " supported values are ['multipane', 'miller']

" for setting any extra option passed to ranger params
let g:neoranger_opts='--cmd="set show_hidden true"' " this line makes ranger show hidden files by default

" lazygit
nnoremap <silent> <leader>gs :LazyGit<CR>

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

lua << EOF
    require'nvim_lsp'.nimls.setup{}
    require'nvim_lsp'.julials.setup{}
    require'nvim_lsp'.pyls.setup{}
    require'nvim_lsp'.vimls.setup{}
EOF

nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <leader>lh    <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> <leader>lk    <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>lr    <cmd>lua vim.lsp.buf.references()<CR>

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

" automatically enable table mode when using || or __
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
