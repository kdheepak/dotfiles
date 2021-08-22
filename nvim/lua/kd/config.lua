local utils = require("kd/utils")
local augroup = utils.augroup
local autocmd = utils.autocmd

-- settings

vim.cmd("syntax enable")
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

vim.o.undodir = vim.fn.stdpath("cache") .. "/undodir"
vim.o.backupdir = vim.fn.stdpath("cache") .. "/backup"
vim.o.directory = vim.fn.stdpath("cache") .. "/swap"
vim.o.undofile = true

vim.o.encoding = "utf-8" -- Default file encoding
vim.o.fileencoding = "utf-8" --  Default file encoding
vim.o.fileencodings = "utf-8" --  Default file encoding
vim.o.autochdir = false --  Don't change dirs automatically
vim.o.errorbells = false --  No sound

vim.o.tabstop = 4 --  Number of spaces a <TAB> is
vim.o.softtabstop = 4 --  Fine tunes the amount of white space to be added
vim.o.shiftwidth = 4 --  Number of spaces for indentation
vim.o.shiftround = true
vim.o.expandtab = true --  Expand tab to spaces
vim.o.timeoutlen = 500 --  Wait less time for mapped sequences
vim.o.smarttab = true --  <TAB> in front of line inserts blanks according to shiftwidth
vim.o.autoindent = true --  copy indent from current line
vim.o.smartindent = true --  do smart indenting when starting a new line
-- vim.o.backspace=indent,eol,start -- allow backspacing over autoindent, line breaks, the start of insert

vim.o.showbreak = "↪ " --  string to put at the start of lines that have been wrapped
vim.o.breakindent = true --  every wrapped line will continue visually indented
vim.o.linebreak = true --  wrap long lines at a character in breakat
vim.o.wrap = true --  lines longer than the width of the window will not wrap

vim.o.termguicolors = true --  enables 24bit colors
vim.o.visualbell = false --  don't display visual bell
vim.o.showmode = false --  don't show mode changes
vim.o.colorcolumn = "121" --  add indicator for 120
vim.o.diffopt = vim.o.diffopt .. ",vertical" --  Always use vertical diffs
vim.o.diffopt = vim.o.diffopt .. ",algorithm:patience"
vim.o.diffopt = vim.o.diffopt .. ",indent-heuristic"
vim.o.cursorline = true --  highlight current line
vim.o.showcmd = true --  show command in bottom bar display an incomplete command in the lower right of the vim window
vim.o.showmatch = true --  highlight matching [{()}]
vim.o.lazyredraw = true --  redraw only when we need to.
vim.o.ignorecase = true --  Ignore case when searching
vim.o.smartcase = true --  When searching try to be smart about cases
vim.o.incsearch = true --  search as characters are entered
vim.o.hlsearch = true --  highlight matches
vim.o.inccommand = "split" --  live search and replace
vim.o.wildmenu = true --  visual autocomplete for command menu
vim.o.autoread = true --  automatically read files that have been changed outside of vim
vim.o.emoji = false --  emoji characters are not considered full width
vim.o.backup = false --  no backup before overwriting a file
vim.o.writebackup = false --  no backups when writing a file
vim.o.autowrite = true --  Automatically :write before running commands
vim.o.list = true
vim.o.listchars = "tab:»·,trail:·,conceal:┊,nbsp:×,extends:❯,precedes:❮" --  Display extra whitespace
vim.o.nrformats = "bin,hex,alpha" --  increment or decrement alpha
vim.o.mouse = "a" --  Enables mouse support
vim.o.foldenable = false --  disable folding
vim.o.signcolumn = "yes" --  Always show git gutter / sign column
vim.o.joinspaces = false --  Use one space, not two, after punctuation
vim.o.splitright = true --  split windows right
vim.o.splitbelow = true --  split windows below
vim.o.viminfo = vim.o.viminfo .. ",n" .. vim.fn.stdpath("cache") .. "/viminfo"
-- vim.o.virtualedit = vim.o.virtualedit .. "all" --  allow virtual editing in all modes
vim.o.modeline = false --  no lines are checked for set commands
vim.o.grepprg = "rg --vimgrep" --  use ripgrep
vim.o.redrawtime = 10000 -- set higher redrawtime so that vim does not hang on difficult syntax highlighting
vim.o.updatetime = 250 -- set lower updatetime so that vim git gutter updates sooner
vim.o.switchbuf = vim.o.switchbuf .. "useopen" --  open buffers in tab
local cmdheight = 1
vim.o.cmdheight = cmdheight
vim.o.winheight = cmdheight
vim.o.winminheight = cmdheight
vim.o.winminwidth = cmdheight * 2
vim.o.shortmess = "filnxtToOfcI" --  Shut off completion and intro messages
vim.o.scrolloff = 10 --  show 10 lines above and below
vim.o.number = true
vim.o.sessionoptions = vim.o.sessionoptions .. ",globals"
vim.o.hidden = true
vim.o.autoread = true

vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/bin/python3")

-- autocmds

augroup("KDAutocmds", function()
  autocmd("InsertLeave", "*", "set nopaste")

  autocmd("BufRead,BufNewFile", "*.md", "setlocal spell")

  autocmd("FileType", "gitcommit", "setlocal spell")

  autocmd("FileType", "*", "setlocal nosmartindent") -- Ensure comments don't go to beginning of line by default

  autocmd("VimResized", "*", "wincmd =") -- resize panes when host window is resized

  autocmd("FileType", "json", "syntax match Comment +//.+$+")

  autocmd("FileType", "gitcommit,gitrebase,gitconfig", "setl bufhidden=delete")

  autocmd("FocusGained", "*", "silent! :checktime")

  autocmd("BufWinEnter", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

  autocmd("BufRead", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

  autocmd("BufNewFile", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

  autocmd("TextYankPost", "*", function()
    require("vim.highlight").on_yank({ higroup = "Search", timeout = 500 })
  end)

  autocmd("BufWritePost", "plugins.lua", require("kd/plugins").reload_config)
end)

-- mappings

vim.api.nvim_exec(
  [[

cnoremap <expr> <C-k>  pumvisible() ? "<C-p>"  : "<Up>"
cnoremap <expr> <C-j>  pumvisible() ? "<C-n>"  : "<Down>"

" Use virtual replace mode all the time
nnoremap r gr
nnoremap R gR

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
nnoremap > >>_
nnoremap < <<_

" highlight last inserted text
nnoremap gV `[v`]

" move vertically by visual line
nnoremap j gj
nnoremap k gk
" move vertically by actual line
nnoremap J j
nnoremap K k

" move to beginning of the line
noremap H ^
" move to end of the line
noremap L $

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" copy to the end of line
nnoremap Y y$

" allow W, Q to be used instead of w and q
command! W w
command! -bang Q q
command! -bang Qa qa

" kakoune like mapping
noremap ge G$
noremap gj G
noremap gk gg
noremap gi 0
noremap gh ^
noremap gl $
noremap ga <C-^>

" Navigate jump list
nnoremap g, <C-o>
nnoremap g. <C-i>

" Goto file under cursor
noremap gf gF
noremap gF gf

nnoremap <a-s-tab> :tabprevious<CR>
nnoremap <a-tab> :tabnext<CR>

" Macros
nnoremap Q @q
vnoremap Q :norm @@<CR>

nnoremap q: <nop>
nnoremap q/ <nop>
nnoremap q? <nop>

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" redo
nnoremap U <C-R>

" Repurpose cursor keys
nnoremap <silent> <Up> :cprevious<CR>
nnoremap <silent> <Down> :cnext<CR>
nnoremap <silent> <Left> :cpfile<CR>
nnoremap <silent> <Right> :cnfile<CR>

nnoremap <kPlus> <C-a>
nnoremap <kMinus> <C-x>
nnoremap + <C-a>
nnoremap - <C-x>
vnoremap + g<C-a>gv
vnoremap - g<C-x>gv

nmap <Plug>SpeedDatingFallbackUp   <Plug>(CtrlXA-CtrlA)
nmap <Plug>SpeedDatingFallbackDown <Plug>(CtrlXA-CtrlX)

" backtick goes to the exact mark location, single quote just the line; swap 'em
nnoremap ` '
nnoremap ' `

" Opens line below or above the current line
inoremap <S-CR> <C-O>o
inoremap <C-CR> <C-O>O

" Sizing window horizontally
nnoremap <c-,> <C-W><
nnoremap <c-.> <C-W>>

let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"

let g:prettier#config#prose_wrap = 'always'

" make searching with * use vim-asterisk
map *  <Plug>(asterisk-z*)zzzv
map #  <Plug>(asterisk-z#)zzzv
map g* <Plug>(asterisk-gz*)zzzv
map g# <Plug>(asterisk-gz#)zzzv
nmap n <Plug>(anzu-n-with-echo)zzzv
nmap N <Plug>(anzu-N-with-echo)zzzv

let g:asterisk#keeppos = 1

let g:medieval_langs = ['python=python3', 'julia', 'sh', 'console=bash']
nnoremap <buffer> Z! :<C-U>EvalBlock<CR>
let g:slime_target = "neovim"

" Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()

inoremap <silent> <C-u> <C-\><C-O>:call unicode#Fuzzy()<CR>

command -nargs=* Glg Git! log --graph --pretty=format:'\%h - (\%ad)\%d \%s <\%an>' --abbrev-commit --date=local <args>
syn match gitLgLine     /^[_\*|\/\\ ]\+\(\<\x\{4,40\}\>.*\)\?$/

syn match gitLgHead     /^[_\*|\/\\ ]\+\(\<\x\{4,40\}\> - ([^)]\+)\( ([^)]\+)\)\? \)\?/ contained containedin=gitLgLine

syn match gitLgDate     /(\u\l\l \u\l\l \d\=\d \d\d:\d\d:\d\d \d\d\d\d)/ contained containedin=gitLgHead nextgroup=gitLgRefs skipwhite

syn match gitLgRefs     /([^)]*)/ contained containedin=gitLgHead

syn match gitLgGraph    /^[_\*|\/\\ ]\+/ contained containedin=gitLgHead,gitLgCommit nextgroup=gitHashAbbrev skipwhite

syn match gitLgCommit   /^[^-]\+- / contained containedin=gitLgHead nextgroup=gitLgDate skipwhite

syn match gitLgIdentity /<[^>]*>$/ contained containedin=gitLgLine

hi def link gitLgGraph    Comment

hi def link gitLgDate     gitDate

hi def link gitLgRefs     gitReference

hi def link gitLgIdentity gitIdentity
]],
  false
)

vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true, silent = true })

-- -- clear highlights
-- vim.api.nvim_set_keymap('n', '<leader><leader>', ':noh<cr>', { noremap = true, silent = true })

-- simplify split movements
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w><c-h>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w><c-j>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w><c-k>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w><c-l>", { noremap = true, silent = true })

-- move through wrapped lines
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })

-- reselect after visual indent
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- search visually selected text (consistent `*` behaviour)
vim.api.nvim_set_keymap("n", "*", [[*N]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { noremap = true, silent = true })

-- bubble lines
vim.api.nvim_set_keymap("x", "J", ":move '>+1<cr>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "K", ":move '<-2<cr>gv=gv", { noremap = true, silent = true })
