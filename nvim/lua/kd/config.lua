local utils = require("kd/utils")
local augroup = utils.augroup
local autocmd = utils.autocmd
local cnoremap = utils.cnoremap
local noremap = utils.noremap
local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap
local inoremap = utils.inoremap
local nmap = utils.nmap
local command = utils.command
local syntax = utils.syntax
local highlight = utils.highlight

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- settings

-- vim.cmd("syntax enable")
-- vim.cmd("syntax on")
vim.cmd("filetype indent on")

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
vim.o.listchars = "tab:»»,trail:·,conceal:┊,nbsp:×,extends:❯,precedes:❮" --  Display extra whitespace
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
vim.o.switchbuf = vim.o.switchbuf .. ",useopen" --  open buffers in tab
local cmdheight = 1
vim.o.cmdheight = cmdheight
vim.o.winheight = cmdheight
vim.o.winminheight = cmdheight
vim.o.winminwidth = cmdheight * 2
vim.o.shortmess = "filnxtToOfcI" --  Shut off completion and intro messages
vim.o.scrolloff = 10 --  show 10 lines above and below
vim.o.number = true
vim.o.relativenumber = true
vim.o.sessionoptions = vim.o.sessionoptions .. ",globals"
vim.o.hidden = true
vim.o.autoread = true

vim.opt.laststatus = 3

vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/bin/python3")

-- autocmds

augroup("KDAutocmds", function()
  autocmd("InsertLeave", "set nopaste")

  autocmd("BufRead,BufNewFile", "setlocal spell", { pattern = "*.md" })

  autocmd("FileType", "setlocal spell", { pattern = "gitcommit" })

  autocmd("FileType", "setlocal nosmartindent") -- Ensure comments don't go to beginning of line by default

  autocmd("VimResized", "wincmd =") -- resize panes when host window is resized

  autocmd("FileType", "setl bufhidden=delete", { pattern = { "gitcommit", "gitrebase", "gitconfig" } })

  autocmd("BufWinEnter", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

  autocmd("BufRead", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

  autocmd("BufNewFile", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

  autocmd("BufWinEnter", "setlocal wrap")

  autocmd("BufRead", "setlocal wrap")

  autocmd("BufNewFile", "setlocal wrap")

  autocmd("TextYankPost", function()
    require("vim.highlight").on_yank({ higroup = "Search", timeout = 500 })
  end)

  autocmd("BufNewFile,BufRead", function()
    if vim.fn.getline(1) == "#!/usr/bin/env julia" then
      vim.cmd("setfiletype julia")
    end
    if vim.fn.getline(1) == "#!/usr/bin/env python3" then
      vim.cmd("setfiletype python")
    end
  end)

  vim.cmd [[autocmd filetype markdown syn region match start=/\\$\\$/ end=/\\$\\$/]]
  vim.cmd [[autocmd filetype markdown syn match math '\\$[^$].\{-}\$']]

  autocmd("BufWritePost", require("kd/plugins").reload_config, { pattern = "plugins.lua" })
end)

-- mappings

cnoremap("<C-k>", "pumvisible() ? \"<C-p>\"  : \"<Up>\"")
cnoremap("<C-j>", "pumvisible() ? \"<C-n>\"  : \"<Down>\"")

-- Use virtual replace mode all the time
nnoremap("r", "gr")
nnoremap("R", "gR")

-- visual shifting (does not exit Visual mode)
vnoremap("<", "<gv")
vnoremap(">", ">gv")
nnoremap(">", ">>_")
nnoremap("<", ">>_")

-- highlight last inserted text
nnoremap("gV", "`[v`]")

-- move vertically by visual line
nnoremap("j", "gj")
nnoremap("k", "gk")

-- move vertically by actual line
nnoremap("J", "j")
nnoremap("K", "k")

-- move to beginning of the line
noremap("H", "^")

-- move to end of the line
noremap("L", "$")

-- Move visual block
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

-- copy to the end of line
nnoremap("Y", "y$")

-- kakoune like mapping
noremap("ge", "G$")
noremap("gj", "G")
noremap("gk", "gg")
noremap("gi", "0")
noremap("gh", "^")
noremap("gl", "$")
noremap("ga", "<C-^>")

-- move through wrapped lines
nnoremap("j", "gj")
nnoremap("k", "gk")

-- Navigate jump list
nnoremap("g,", "<C-o>")
nnoremap("g.", "<C-i>")

-- Goto file under cursor
noremap("gf", "gF")
noremap("gF", "gf")

nnoremap("<a-s-tab>", ":tabprevious<CR>")
nnoremap("<a-tab>", ":tabnext<CR>")

-- Macros
nnoremap("Q", "@q")
vnoremap("Q", ":norm @@<CR>")

nnoremap("q:", "<nop>")
nnoremap("q/", "<nop>")
nnoremap("q?", "<nop>")

-- Select last paste
nnoremap("gp", "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true })

-- redo
nnoremap("U", "<C-R>")

-- Repurpose cursor keys
nnoremap("<Up>", ":cprevious<CR>", { silent = true })
nnoremap("<Down>", ":cnext<CR>", { silent = true })
nnoremap("<Left>", ":cpfile<CR>", { silent = true })
nnoremap("<Right>", ":cnfile<CR>", { silent = true })

nnoremap("<kPlus>", "<C-a>")
nnoremap("<kMinus>", "<C-x>")
nnoremap("+", "<C-a>")
nnoremap("-", "<C-x>")
vnoremap("+", "g<C-a>gv")
vnoremap("-", "g<C-x>gv")

nmap("<Plug>SpeedDatingFallbackUp", "<Plug>(CtrlXA-CtrlA)")
nmap("<Plug>SpeedDatingFallbackDown", "<Plug>(CtrlXA-CtrlX)")

-- backtick goes to the exact mark location, single quote just the line; swap 'em
nnoremap("`", "'")
nnoremap("'", "`")

-- Opens line below or above the current line
inoremap("<S-CR>", "<C-O>o")
inoremap("<C-CR>", "<C-O>O")

-- Sizing window horizontally
nnoremap("<c-,>", "<C-W><")
nnoremap("<c-.>", "<C-W>>")

inoremap("<C-u>", "<C-<C-O>:call unicode#Fuzzy()<CR>")

-- Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap("<CR>", [[{-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()]], { expr = true })

nnoremap("<space>", "<nop>", { silent = true })

-- search visually selected text (consistent `*` behaviour)
vnoremap("*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { silent = true })

-- allow W, Q to be used instead of w and q
command("W", "w")
command("Q", "q", { bang = true })
command("Qa", "qa", { bang = true })

command("LspLog", "edit " .. vim.lsp.get_log_path())

command(
  "Glg",
  "Git! log --graph --pretty=format:'%h - (%ad)%d %s <%an>' --abbrev-commit --date=local <args>",
  { nargs = "*" }
)

syntax("match", "gitLgLine", [[/^[_\*|\/\\ ]\+\(\<\x\{4,40\}\>.*\)\?$/]])

syntax(
  "match",
  "gitLgHead",
  [[/^[_\*|\/\\ ]\+\(\<\x\{4,40\}\> - ([^)]\+)\( ([^)]\+)\)\? \)\?/ contained containedin=gitLgLine]]
)

syntax(
  "match",
  "gitLgDate",
  [[/(\u\l\l \u\l\l \d\=\d \d\d:\d\d:\d\d \d\d\d\d)/ contained containedin=gitLgHead nextgroup=gitLgRefs skipwhite]]
)

syntax("match", "gitLgRefs", [[/([^)]*)/ contained containedin=gitLgHead]])

syntax(
  "match",
  "gitLgGraph",
  [[/^[_\*|\/\\ ]\+/ contained containedin=gitLgHead,gitLgCommit nextgroup=gitHashAbbrev skipwhite]]
)

syntax("match", "gitLgCommit", [[/^[^-]\+- / contained containedin=gitLgHead nextgroup=gitLgDate skipwhite]])

syntax("match", "gitLgIdentity", [[/<[^>]*>$/ contained containedin=gitLgLine]])

highlight("default", "link", "gitLgGraph", "Comment")

highlight("default", "link", "gitLgDate", "gitDate")

highlight("default", "link", "gitLgRefs", "gitReference")

highlight("default", "link", "gitLgIdentity", "gitIdentity")

vim.api.nvim_exec(
  [[
let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
]] ,
  false
)

vim.api.nvim_exec(
  [[
augroup ReplaceNetrw
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | call luaeval("require('fzf-lua').files(function() return {cwd = _A} end)", argv()[0]) | endif
augroup END
]] ,
  false)
