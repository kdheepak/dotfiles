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
vim.o.virtualedit = vim.o.virtualedit .. "all" --  allow virtual editing in all modes
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
vim.o.completeopt = "menu,menuone,noselect" --  Use the popup menu also when there is only one match.
vim.o.shortmess = "filnxtToOfcI" --  Shut off completion and intro messages
vim.o.scrolloff = 10 --  show 10 lines above and below
vim.o.number = true
vim.o.sessionoptions = vim.o.sessionoptions .. ",globals"
vim.o.hidden = true
vim.o.formatoptions = "jql"
-- Use a (usually) better diff algorithm.

vim.g.VtrStripLeadingWhitespace = false
vim.g.VtrClearEmptyLines = false
vim.g.VtrAppendNewline = true

vim.g.vim_markdown_emphasis_multiline = false
vim.g.vim_markdown_folding_disabled = true
vim.g.tex_conceal = ""
vim.g.vim_markdown_math = true
vim.g.vim_markdown_frontmatter = true
vim.g.vim_markdown_strikethrough = true
vim.g.vim_markdown_fenced_languages = { "julia=jl", "python=py" }
vim.g.latex_to_unicode_auto = true
vim.g.latex_to_unicode_tab = false
vim.g.latex_to_unicode_cmd_mapping = { "<C-j>" }

-- TODO: add shortcut to transform string
vim.g.unicoder_cancel_normal = true
vim.g.unicoder_cancel_insert = true
vim.g.unicoder_cancel_visual = true
vim.g.unicoder_no_map = true

vim.g.mkdp_auto_start = 0

vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/bin/python3")

vim.g.mergetool_layout = "bmr"
vim.g.mergetool_prefer_revision = "local"

vim.g.camelcasemotion_key = ","

vim.g.clever_f_across_no_line = 1
vim.g.clever_f_fix_key_direction = 1
