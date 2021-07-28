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

-- vim.api.nvim_set_keymap('<C-f>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', '<NOP>', {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('<C-b>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', '<NOP>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', 'K', ':Lspsaga hover_doc<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', 'ca', ':Lspsaga code_action<CR>', { silent = true, noremap = true })

-- scroll down hover doc or scroll in definition preview
vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(1)<CR>',
                        { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<C-g>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(-1)<CR>',
                        { silent = true, noremap = true })

vim.cmd([[
autocmd CursorHold * lua require'lspsaga.diagnostic'.show_cursor_diagnostics()
]])

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
vim.api.nvim_set_keymap('n', '<Leader><Leader>', ':delmarks! | delmarks a-zA-Z0-9<CR>:let @/=""<CR>',
                        { noremap = true, silent = true })

-- inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

local global_opts = {
  mode = 'n', -- normal mode
  buffer = nil, -- global mappings. specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local global_mappings = {
  ['<C-c><C-c>'] = { '<cmd>BufferClose<cr>', 'close buffer' },
  ['<Tab>'] = { '<cmd>BufferNext<cr>', 'Jump to next buffer' },
  ['<S-Tab>'] = { '<cmd>BufferPrevious<cr>', 'Jump to prev buffer' },
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

  ['/'] = { '<cmd>split|wincmd l|terminal<CR>', 'Split terminal horizontally' },
  ['\\'] = { '<cmd>vsplit|wincmd l|terminal<CR>', 'Split terminal vertically' },

  w = {
    name = '+Windows',
    ['/'] = { '<cmd>split<CR>', 'Split window horizontally' },
    ['\\'] = { '<cmd>vsplit<CR>', 'Split window vertically' },
  },

  q = {
    name = 'Format',
    t = { '<cmd>Tabularize<CR>', 'Tabularize' },
    j = { '<cmd>JuliaFormatterFormat<CR>', 'Format Julia file' },
    q = { '<cmd>lua require(\'telescope.builtin\').quickfix()<CR>', 'Quickfix' },
  },

  b = {
    name = '+Buffers',
    d = { '<cmd>BufferClose<CR>', 'delete current buffer' },
    j = { '<cmd>BufferNext<CR>', 'Next buffer' },
    k = { '<cmd>BufferPrevious<CR>', 'Prev buffer' },
    w = { '<cmd>BufferWipeout<CR>', 'wipeout buffer' },
  },
  g = {
    name = 'Git',
    j = { '<cmd>GitGutterNextHunk<CR>', 'Next Hunk' },
    k = { '<cmd>GitGutterPrevHunk<CR>', 'Prev Hunk' },
    b = { '<cmd>Gblame<CR>', 'Blame' },
    B = { '<cmd>lua require"gitsigns".blame_line(true)<CR>', 'Blame' },
    p = { '<cmd>Gpush<CR>', 'Git Push' },
    P = { '<cmd>Gpull<CR>', 'Git Pull' },
    r = { '<cmd>Gremove<CR>', 'Git Remove' },
    g = { '<cmd>LazyGit<CR>', 'Git Status' },
    o = { '<cmd>GBrowse<CR>', 'Open file in browser' },
  },

  f = {
    name = 'Find',
    b = { ':lua require\'fzf-lua\'.buffers()<cr>', 'Buffers' },
    l = { ':lua require\'fzf-lua\'.loclist()<cr>', 'Location List' },
    q = { ':lua require\'fzf-lua\'.quickfix()<cr>', 'Quick Fix' },
    c = { ':lua require\'fzf-lua\'.grep_curbuf()<cr>', 'Grep Current Buffer' },
    v = { ':lua require\'fzf-lua\'.grep_visual()<cr>', 'Grep Visual' },
    w = { ':lua require\'fzf-lua\'.grep_cword()<cr>', 'Grep Cursor Word' },
    g = { ':lua require\'fzf-lua\'.live_grep()<cr>', 'Grep Live' },
    f = { ':lua require\'fzf-lua\'.files()<cr>', 'Files' },
    h = { ':lua require\'fzf-lua\'.help_tags()<cr>', 'Help' },
    m = { ':lua require\'fzf-lua\'.man_pages()<cr>', 'Man' },
    t = { ':lua require\'fzf-lua\'.lsp_typedefs()<cr>', 'Type Defs' },
    r = { ':lua require\'fzf-lua\'.lsp_references()<cr>', 'References' },
    d = { ':lua require\'fzf-lua\'.lsp_definitions()<cr>', 'Definitions' },
    s = { ':lua require\'fzf-lua\'.lsp_workspace_symbols()<cr>', 'Workspace Symbols' },
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
    [']'] = { '<cmd>Lspsaga diagnostic_jump_next<CR>', 'Next Diagnostic' },
    ['['] = { '<cmd>Lspsaga diagnostic_jump_prev<CR>', 'Previous Diagnostic' },
    a = { '<cmd>Lspsaga code_action<CR>', 'Code Action' },
    A = { '<cmd>Lspsaga range_code_action<CR>', 'Selected Action' },
    d = { '<cmd>Telescope lsp_document_diagnostics<CR>', 'Document Diagnostics' },
    D = { '<cmd>Telescope lsp_workspace_diagnostics<CR>', 'Workspace Diagnostics' },
    f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format' },
    h = { '<cmd>Lspsaga hover_doc<CR>', 'Hover Doc' },
    H = { '<cmd>Lspsaga signature_help<CR>', 'Signature Help' },
    i = { '<cmd>LspInfo<CR>', 'Info' },
    l = { '<cmd>Lspsaga lsp_finder<CR>', 'LSP Finder' },
    L = { '<cmd>Lspsaga show_line_diagnostics<CR>', 'Line Diagnostics' },
    p = { '<cmd>Lspsaga preview_definition<CR>', 'Preview Definition' },
    q = { '<cmd>Telescope quickfix<CR>', 'Quickfix' },
    r = { '<cmd>Lspsaga rename<CR>', 'Rename' },
    t = { '<cmd>LspTypeDefinition<CR>', 'Type Definition' },
    x = { '<cmd>cclose<CR>', 'Close Quickfix' },
    s = { '<cmd>Telescope lsp_document_symbols<CR>', 'Document Symbols' },
    g = { '<cmd>lua require\'lspsaga.diagnostic\'.show_cursor_diagnostics()<CR>', 'Document Symbols' },
    S = { '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', 'Workspace Symbols' },
  },

  v = { name = 'Vim', e = { '<cmd>e $MYVIMRC<CR>' }, s = { '<cmd>luafile $MYVIMRC<CR>' }, z = { '<cmd>e ~/.zshrc<CR>' } },

}

wk.register(mappings, opts)
