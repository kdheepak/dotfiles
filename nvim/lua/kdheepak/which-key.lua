local wk = require 'which-key'

wk.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ...
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  icons = {
    breadcrumb = '»', -- symbol used in the command line area that shows your active key combo
    separator = '➜', -- symbol used between a key and it's label
    group = '+', -- symbol prepended to a group
  },
  window = {
    border = 'single', -- none, single, double, shadow
    position = 'bottom', -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom=, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
  },
  hidden = { '<silent>', '<cmd>', '<Cmd>', '<CR>', 'call', 'lua', '^:', '^ ' }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
}

vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', { noremap = true, silent = true })

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = {
  mode = 'n', -- NORMAL mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

vim.api.nvim_set_keymap('n', '<leader>w', [[<C-w>]], { noremap = true })

-- no hl
vim.api.nvim_set_keymap('n', '<Leader><Leader>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

local global_opts = {
  mode = 'n', -- normal mode
  buffer = nil, -- global mappings. specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local global_mappings = {
  ['<C-c><C-c>'] = { '<cmd>Bdelete<CR>', 'close buffer' },
  ['<Tab>'] = { '<cmd>TablineBufferNext<CR>', 'Jump to next buffer' },
  ['<S-Tab>'] = { '<cmd>TablineBufferPrevious<CR>', 'Jump to next buffer' },
}

wk.register(global_mappings, global_opts)

local visual_mappings = {
  p = { '"+p', 'Paste from clipboard' },
  P = { '"+P', 'Paste from clipboard (before)' },
  y = { '"+y', 'Yank to clipboard' },
  Y = { '"+Y', 'Yank line to clipboard' },
  d = { '"+ygvd', 'Cut line to clipboard' },
  g = { name = 'Git', o = { '<cmd>\'<,\'>GBrowse<CR>', 'Open file in browser' } },
}

wk.register(visual_mappings, {
  mode = 'v', -- NORMAL mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
})

local mappings = {
  p = { '"+p', 'Paste from clipboard' },
  P = { '"+P', 'Paste from clipboard (before)' },
  y = { '"+y', 'Yank to clipboard' },
  Y = { '"+Y', 'Yank line to clipboard' },

  ['/'] = { '<cmd>ToggleTerm direction=horizontal<CR>', 'Split terminal horizontally' },
  ['\\'] = { '<cmd>ToggleTerm direction=vertical<CR>', 'Split terminal vertically' },

  w = {
    name = '+Windows',
    ['/'] = { '<cmd>split<CR>', 'Split window horizontally' },
    ['\\'] = { '<cmd>vsplit<CR>', 'Split window vertically' },
    z = { '<cmd>call zoom#toggle()', 'Zoom Toggle' },
  },

  q = {
    name = 'Format',
    t = { '<cmd>Tabularize<CR>', 'Tabularize' },
    j = { '<cmd>JuliaFormatterFormat<CR>', 'Format Julia file' },
    q = { '<cmd>lua require(\'telescope.builtin\').quickfix()<CR>', 'Quickfix' },
  },

  b = {
    name = '+Buffers',
    d = { '<cmd>Bdelete<CR>', 'delete current buffer' },
    j = { '<cmd>TablineBufferNext<CR>', 'Next buffer' },
    k = { '<cmd>TablineBufferPrevious<CR>', 'Prev buffer' },
    w = { '<cmd>BufferWipeout<CR>', 'wipeout buffer' },
  },

  t = {
    name = '+Tabs',
    n = { '<cmd>TablineTabNew<CR>', 'New tab' },
    d = { '<cmd>tabclose<CR>', 'delete current tab' },
    j = { '<cmd>tabnext<CR>', 'Next tab' },
    k = { '<cmd>tabprevious<CR>', 'Prev tab' },
  },

  g = {
    name = 'Git',
    j = { '&diff ? \']c\' : \'<cmd>lua require"gitsigns.actions".next_hunk()<CR>\'', 'Next Hunk' },
    k = { '&diff ? \']c\' : \'<cmd>lua require"gitsigns.actions".prev_hunk()<CR>\'', 'Prev Hunk' },
    b = { '<Plug>(git-messenger)', 'Git Messanger Blame' },
    B = { '<cmd>Git blame<CR>', 'Git Blame' },
    p = { '<cmd>Git push<CR>', 'Git Push' },
    P = { '<cmd>Git pull<CR>', 'Git Pull' },
    r = { '<cmd>GRemove<CR>', 'Git Remove' },
    g = { '<cmd>LazyGit<CR>', 'Git Status' },
    c = { '<cmd>Git commit', 'Git commit' },
    o = { '<cmd>GBrowse<CR>', 'Open file in browser' },
    s = { '<cmd>Git<CR>', 'Status' },
    w = { '<cmd>Gwrite<CR>', 'Stage' },
    D = { '<cmd>Gdiffsplit<CR>', 'Diff' },
    d = { '<cmd>DiffviewOpen<CR>', 'Diff ALL' },
    dth = { ':call difftoggle#DiffToggle(1)<CR>', 'Diff toggle left' },
    dtm = { ':call difftoggle#DiffToggle(2)<CR>', 'Diff toggle middle' },
    dtl = { ':call difftoggle#DiffToggle(3)<CR>', 'Diff toggle right' },
    du = { ':diffupdate<CR>', 'Diff update' },
    dcm = { [[/\v^[<=>]{7}( .*\|$)<CR>]], 'Show commit markers' },
    mt = { '<cmd>MergetoolToggle<CR>', 'Merge tool toggle' },
    mh = { '<Plug>(MergetoolDiffExchangeLeft)<CR>', 'Merge Tool Diff Exchange Left' },
    ml = { '<Plug>(MergetoolDiffExchangeRight)<CR>', 'Merge Tool Diff Exchange Right' },
    mj = { '<Plug>(MergetoolDiffExchangeDown)<CR>', 'Merge Tool Diff Exchange Down' },
    mk = { '<Plug>(MergetoolDiffExchangeUp)<CR>', 'Merge Tool Diff Exchange Up' },
    hs = { '<cmd>lua require"gitsigns".stage_hunk()<CR>', 'Stage Hunk' },
    -- hs = { '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>' },
    hu = { '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', 'Undo Stage Hunk' },
    hr = { '<cmd>lua require"gitsigns".reset_hunk()<CR>', 'Reset Hunk' },
    -- hr = { '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>' },
    hR = { '<cmd>lua require"gitsigns".reset_buffer()<CR>', 'Reset Buffer' },
    hp = { '<cmd>lua require"gitsigns".preview_hunk()<CR>', 'Preview Hunk' },
    hb = { '<cmd>lua require"gitsigns".blame_line(true)<CR>', 'Blame line' },
  },

  f = {
    name = 'Find',
    b = { ':lua require\'fzf-lua\'.buffers()<CR>', 'Buffers' },
    l = { ':lua require\'fzf-lua\'.loclist()<CR>', 'Location List' },
    q = { ':lua require\'fzf-lua\'.quickfix()<CR>', 'Quick Fix' },
    c = { ':lua require\'fzf-lua\'.grep_curbuf()<CR>', 'Grep Current Buffer' },
    v = { ':lua require\'fzf-lua\'.grep_visual()<CR>', 'Grep Visual' },
    w = { ':lua require\'fzf-lua\'.grep_cword()<CR>', 'Grep Cursor Word' },
    g = { ':lua require\'fzf-lua\'.live_grep()<CR>', 'Grep Live' },
    f = { ':lua require\'fzf-lua\'.files()<CR>', 'Files' },
    h = { ':lua require\'fzf-lua\'.help_tags()<CR>', 'Help' },
    m = { ':lua require\'fzf-lua\'.man_pages()<CR>', 'Man' },
    t = { ':lua require\'fzf-lua\'.lsp_typedefs()<CR>', 'Type Defs' },
    r = { ':lua require\'fzf-lua\'.lsp_references()<CR>', 'References' },
    d = { ':lua require\'fzf-lua\'.lsp_definitions()<CR>', 'Definitions' },
    s = { ':lua require\'fzf-lua\'.lsp_workspace_symbols()<CR>', 'Workspace Symbols' },
  },

  s = {
    name = 'Session',
    s = { ':SaveSession<CR>', 'Save Session' },
    l = { ':silent! bufdo Bdelete<CR>:silent! RestoreSession<CR>', 'Load Session' },
  },

  n = {
    name = 'NerdTree',
    n = { '<cmd>NvimTreeToggle<CR>', 'Open NERDTree' },
    r = { '<cmd>NvimTreeRefresh<CR>', 'Refresh NERDTree' },
    f = { '<cmd>NvimTreeFindFile<CR>', 'Find File NERDTree' },
  },

  d = {
    name = 'Debug Adapter',
    c = { '<cmd>lua require"dap".continue()<CR>', 'Continue' },
    sv = { '<cmd>lua require"dap".step_over()<CR>', 'Step Over' },
    si = { '<cmd>lua require"dap".step_into()<CR>', 'Step Into' },
    so = { '<cmd>lua require"dap".step_out()<CR>', 'Step Out' },
    tb = { '<cmd>lua require"dap".toggle_breakpoint()<CR>', 'Toggle Breakpoint' },
    sc = { '<cmd>lua require"dap.ui.variables".scopes()<CR>', 'Variable Scopes' },
    hh = { '<cmd>lua require"dap.ui.variables".hover()<CR>', 'Variable Hover' },
    hv = { '<cmd>lua require"dap.ui.variables".visual_hover()<CR>', 'Variable Visual Hover' },
    uh = { '<cmd>lua require"dap.ui.widgets".hover()<CR>', 'Widget Hover' },
    uf = { '<cmd>lua require"dap.ui.widgets".centered_float(widgets.scopes)<CR>', 'Widgets Centered Float Scopes' },
    sbr = {
      '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', 'Set Breakpoint condition',
    },
    sbm = {
      '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
      'Set Breakpoint log point',
    },
    ro = { '<cmd>lua require"dap".repl.open()<CR>', 'REPL Open' },
    rl = { '<cmd>lua require"dap".repl.run_last()<CR>', 'REPL run last' },
    cc = { '<cmd>lua require"telescope".extensions.dap.commands{}<CR>', 'Telescope Commands' },
    co = { '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>', 'Telescope Configurations' },
    lb = { '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>', 'Telescope List Breakpoints' },
    v = { '<cmd>lua require"telescope".extensions.dap.variables{}<CR>', 'Telescope Variables' },
    f = { '<cmd>lua require"telescope".extensions.dap.frames{}<CR>', 'Telescope Frames' },
  },

  l = {
    name = 'LSP',
    [']'] = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Next Diagnostic' },
    ['['] = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Previous Diagnostic' },
    a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
    d = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
    D = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Definition' },
    t = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type Definition' },
    i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Implementation' },
    H = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature' },
    h = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover Doc' },
    r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
    R = { '<cmd>lua vim.lsp.buf.references()<CR>', 'References' },
    f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Formatting' },
    F = { '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', 'Formatting' },
    co = { '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', 'Outgoing calls' },
    ci = { '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', 'Incoming calls' },
    s = { '<cmd>lua vim.lsp.buf.document_symbol()<CR>', 'Document symbol' },
    S = { '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'Workspace symbol' },
    x = { '<cmd>cclose<CR>', 'Close Quickfix' },
    G = { '<cmd>edit ' .. vim.lsp.get_log_path(), 'Open LSP Log file' },
  },

  v = {
    name = 'Vim',
    m = { ':TSHighlightCapturesUnderCursor<CR>', 'Show highlights under cursor' },
    e = { '<cmd>e $MYVIMRC<CR>', 'Open VIMRC' },
    s = { '<cmd>luafile $MYVIMRC<CR>', 'Source VIMRC' },
    z = { '<cmd>e ~/.zshrc<CR>', 'Open ZSHRC' },
  },
}

wk.register(mappings, opts)
