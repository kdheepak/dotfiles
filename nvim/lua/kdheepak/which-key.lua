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
vim.api.nvim_set_keymap('n', '<Leader><Leader>', ':delmarks! | delmarks a-zA-Z0-9<CR>:let @/=""<CR>',
                        { noremap = true, silent = true })

-- inoremap <silent> <expr> <CR> ncm2_ultisnips#expand_or("\<CR>", 'n')

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
    d = { '<cmd>BufDel<CR>', 'delete current buffer' },
    j = { '<cmd>bnext<CR>', 'Next buffer' },
    k = { '<cmd>bprev<CR>', 'Prev buffer' },
    w = { '<cmd>BufferWipeout<CR>', 'wipeout buffer' },
  },

  g = {
    name = 'Git',
    j = { '<cmd>GitGutterNextHunk<CR>', 'Next Hunk' },
    k = { '<cmd>GitGutterPrevHunk<CR>', 'Prev Hunk' },
    b = { '<cmd>Gblame<CR>', 'Blame' },
    B = { '<cmd>lua require\'gitsigns\'.blame_line(true)<CR>', 'Blame' },
    p = { '<cmd>Gpush<CR>', 'Git Push' },
    P = { '<cmd>Gpull<CR>', 'Git Pull' },
    r = { '<cmd>Gremove<CR>', 'Git Remove' },
    g = { '<cmd>LazyGit<CR>', 'Git Status' },
    o = { '<cmd>GBrowse<CR>', 'Open file in browser' },
  },

  f = {
    name = 'Find',
    f = { '<cmd>Telescope find_files<CR>', 'Find files' },
    g = { '<cmd>Telescope live_grep<CR>', 'Live grep' },
    b = { '<cmd>Telescope buffers<CR>', 'Buffers' },
    h = { '<cmd>Telescope help_tags<CR>', 'Help tags' },
    s = { '<cmd>lua require\'telescope.builtin\'.grep_string()<CR>', 'Search for word under cursor' },
    i = { '<cmd>lua require\'telescope\'.extensions.gh.issues()<CR>', 'Git issues' },
    p = { '<cmd>lua require\'telescope\'.extensions.gh.pull_request()<CR>', 'Git pull request' },
    c = { '<cmd>Telescope colorscheme<CR>', 'Colorscheme' },
    d = { '<cmd>Telescope lsp_document_diagnostics<CR>', 'Document Diagnostics' },
    D = { '<cmd>Telescope lsp_workspace_diagnostics<CR>', 'Workspace Diagnostics' },
    m = { '<cmd>Telescope marks<CR>', 'Marks' },
    M = { '<cmd>Telescope man_pages<CR>', 'Man Pages' },
    r = { '<cmd>Telescope oldfiles<CR>', 'Open Recent File' },
    R = { '<cmd>Telescope registers<CR>', 'Registers' },
    n = { '<cmd>lua require(\'telescope.builtin\').file_browser()<CR>', 'File Browser' },
    ['%'] = { '<cmd>lua require(\'telescope.builtin\').current_buffer_fuzzy_find()<CR>', 'Find in Current Buffer' },
    t = { [[<cmd>lua require('telescope.builtin').current_buffer_tags()<CR>]], 'tags of buffer' },
  },

  d = {
    name = 'Debug Adapter',
    ct = { '<cmd>lua require\'dap\'.continue()<CR>', '' },
    sv = { '<cmd>lua require\'dap\'.step_over()<CR>', '' },
    si = { '<cmd>lua require\'dap\'.step_into()<CR>', '' },
    so = { '<cmd>lua require\'dap\'.step_out()<CR>', '' },
    tb = { '<cmd>lua require\'dap\'.toggle_breakpoint()<CR>', '' },
    sc = { '<cmd>lua require\'dap.ui.variables\'.scopes()<CR>', '' },
    hh = { '<cmd>lua require\'dap.ui.variables\'.hover()<CR>', '' },
    hv = { '<cmd>lua require\'dap.ui.variables\'.visual_hover()<CR>', '' },
    uh = { '<cmd>lua require\'dap.ui.widgets\'.hover()<CR>', '' },
    uf = { '<cmd>lua local widgets=require\'dap.ui.widgets\';widgets.centered_float(widgets.scopes)<CR>', '' },
    sbr = { '<cmd>lua require\'dap\'.set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', '' },
    sbm = { '<cmd>lua require\'dap\'.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', '' },
    ro = { '<cmd>lua require\'dap\'.repl.open()<CR>', '' },
    rl = { '<cmd>lua require\'dap\'.repl.run_last()<CR>', '' },
    cc = { '<cmd>lua require\'telescope\'.extensions.dap.commands{}<CR>', '' },
    co = { '<cmd>lua require\'telescope\'.extensions.dap.configurations{}<CR>', '' },
    lb = { '<cmd>lua require\'telescope\'.extensions.dap.list_breakpoints{}<CR>', '' },
    v = { '<cmd>lua require\'telescope\'.extensions.dap.variables{}<CR>', '' },
    f = { '<cmd>lua require\'telescope\'.extensions.dap.frames{}<CR>', '' },
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
