local wk = require("which-key")

wk.setup({
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
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom=, left]
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
  },
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
})

local nnoremap = require("kd/utils").nnoremap
local noremap = require("kd/utils").noremap
local vnoremap = require("kd/utils").vnoremap

nnoremap("<Space>", "<NOP>", { silent = true })

nnoremap("<Tab>", "<cmd>bnext<CR>", { label = "Jump to next buffer", silent = true })

nnoremap("<S-Tab>", "<cmd>bprevious<CR>", { label = "Jump to next buffer", silent = true })

nnoremap("<Leader><Leader>", ":nohlsearch<CR>", { label = "Clear Highlighting", silent = true })

vnoremap("<leader>p", "\"+p", { label = "Paste from clipboard" })

vnoremap("<leader>P", "\"+P", { label = "Paste from clipboard (before)" })

vnoremap("<leader>y", "\"+y", { label = "Yank to clipboard" })

vnoremap("<leader>Y", "\"+Y", { label = "Yank line to clipboard" })

vnoremap("<leader>d", "\"+ygvd", { label = "Cut line to clipboard" })

nnoremap("<leader>p", "\"+p", { label = "Paste from clipboard" })

nnoremap("<leader>P", "\"+P", { label = "Paste from clipboard (before)" })

nnoremap("<leader>y", "\"+y", { label = "Yank to clipboard" })

nnoremap("<leader>Y", "\"+Y", { label = "Yank line to clipboard" })

nnoremap("<C-w>/", "<cmd>split<CR>", { label = "Split window horizontally" })
nnoremap("<C-w>\\", "<cmd>vsplit<CR>", { label = "Split window vertically" })
nnoremap("<C-w>z", "<cmd>call zoom#toggle()<CR>", { label = "Zoom toggle" })

nnoremap("<leader>w/", "<cmd>split<CR>", { label = "Split window horizontally" })
nnoremap("<leader>w\\", "<cmd>vsplit<CR>", { label = "Split window vertically" })
nnoremap("<leader>wz", "<cmd>call zoom#toggle()<CR>", { label = "Zoom toggle" })
nnoremap("<leader>ww", "<C-w>w", { label = "Switch windows" })
nnoremap("<leader>wq", "<C-w>q", { label = "Quit a window" })
nnoremap("<leader>wT", "<C-w>T", { label = "Break out into a new tab" })
nnoremap("<leader>wx", "<C-w>x", { label = "Swap current with next" })
nnoremap("<leader>w-", "<C-w>-", { label = "Decrease height" })
nnoremap("<leader>w+", "<C-w>+", { label = "Increase height" })
nnoremap("<leader>w<lt>", "<C-w><lt>", { label = "Decrease width" })
nnoremap("<leader>w>", "<C-w>>", { label = "Increase width" })
nnoremap("<leader>w|", "<C-w>|", { label = "Max out the width" })
nnoremap("<leader>w=", "<C-w>=", { label = "Equally high and wide" })
nnoremap("<leader>wh", "<C-w>h", { label = "Go to the left window" })
nnoremap("<leader>wl", "<C-w>l", { label = "Go to the right window" })
nnoremap("<leader>wk", "<C-w>k", { label = "Go to the up window" })
nnoremap("<leader>wj", "<C-w>j", { label = "Go to the down window" })

nnoremap("<leader>q", { label = "+Format" })
nnoremap("<leader>qt", "<cmd>Tabularize<CR>", { label = "Tabularize" })
nnoremap("<leader>qf", "<cmd>JuliaFormatterFormat<CR>", { label = "Format Julia file" })
nnoremap("<leader>qq", "<cmd>lua require('fzf-lua').quickfix()<CR>", { label = "Quickfix" })

nnoremap("<leader>b", { label = "+Buffers" })
nnoremap("<leader>bd", "<cmd>Bdelete<CR>", { label = "Delete buffer" })
nnoremap("<leader>bj", "<cmd>TablineBufferNext<CR>", { label = "Next buffer" })
nnoremap("<leader>bk", "<cmd>TablineBufferPrevious<CR>", { label = "Previous buffer" })
nnoremap("<leader>bw", "<cmd>BufferWipeout<CR>", { label = "Previous buffer" })

nnoremap("<leader>t", { label = "+Tabs" })

nnoremap("<leader>tn", "<cmd>TablineTabNew<CR>", { label = "New tab" })
nnoremap("<leader>td", "<cmd>tabclose<CR>", { label = "delete current tab" })
nnoremap("<leader>tj", "<cmd>tabnext<CR>", { label = "Next tab" })
nnoremap("<leader>tk", "<cmd>tabprevious<CR>", { label = "Prev tab" })

nnoremap("<leader>g", { label = "+Git" })
nnoremap("<leader>gj", "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'", { label = "Next Hunk" })
nnoremap("<leader>gk", "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'", { label = "Prev Hunk" })
nnoremap("<leader>gb", "<Plug>(git-messenger)", { label = "Git Messanger Blame" })
nnoremap("<leader>gB", "<cmd>Git blame<CR>", { label = "Git Blame" })
nnoremap("<leader>gp", "<cmd>Git push<CR>", { label = "Git Push" })
nnoremap("<leader>gP", "<cmd>Git pull<CR>", { label = "Git Pull" })
nnoremap("<leader>gr", "<cmd>GRemove<CR>", { label = "Git Remove" })
nnoremap("<leader>gg", "<cmd>LazyGit<CR>", { label = "LazyGit" })
nnoremap("<leader>gC", "<cmd>Git commit<CR>", { label = "Git commit" })
nnoremap("<leader>gs", "<cmd>Git<CR>", { label = "Git Status" })
nnoremap("<leader>gw", "<cmd>Gwrite<CR>", { label = "Stage" })

nnoremap("<leader>gd", { label = "Diff" })
nnoremap("<leader>gD", "<cmd>Gdiffsplit<CR>", { label = "Diff" })
nnoremap("<leader>gd", "<cmd>DiffviewOpen<CR>", { label = "Diff ALL" })
nnoremap("<leader>gdt", ":call difftoggle#DiffToggle(1)<CR>", { label = "Diff toggle left" })
nnoremap("<leader>gdt", ":call difftoggle#DiffToggle(2)<CR>", { label = "Diff toggle middle" })
nnoremap("<leader>gdt", ":call difftoggle#DiffToggle(3)<CR>", { label = "Diff toggle right" })
nnoremap("<leader>gdu", ":diffupdate<CR>", { label = "Diff update" })
nnoremap("<leader>gdc", [[/\v^[<=>]{7}( .*\|$)<CR>]], { label = "Show commit markers" })

nnoremap("<leader>gh", { label = "Hunk" })
nnoremap("<leader>ghs", "<cmd>lua require\"gitsigns\".stage_hunk()<CR>", { label = "Stage Hunk" })
nnoremap("<leader>ghu", "<cmd>lua require\"gitsigns\".undo_stage_hunk()<CR>", { label = "Undo Stage Hunk" })
nnoremap("<leader>ghr", "<cmd>lua require\"gitsigns\".reset_hunk()<CR>", { label = "Reset Hunk" })
nnoremap("<leader>ghR", "<cmd>lua require\"gitsigns\".reset_buffer()<CR>", { label = "Reset Buffer" })
nnoremap("<leader>ghp", "<cmd>lua require\"gitsigns\".preview_hunk()<CR>", { label = "Preview Hunk" })
nnoremap("<leader>ghb", "<cmd>lua require\"gitsigns\".blame_line(true)<CR>", { label = "Blame line" })

nnoremap("<leader>gf", { label = "Fuzzy" })

nnoremap("<leader>gfs", function()
  require("fzf-lua").git_status({})
end, { label = "Git Status" })

nnoremap("<leader>gff", function()
  require("fzf-lua").git_files({})
end, { label = "Git Files" })

nnoremap("<leader>gfc", function()
  require("fzf-lua").git_commits({})
end, { label = "Git Commits" })

nnoremap("<leader>gfb", function()
  require("fzf-lua").git_bcommits({})
end, { label = "Git Buffer Commits" })

nnoremap("<leader>gfr", function()
  require("fzf-lua").git_branches({})
end, {
  label = "Git Branches",
})

nnoremap("<leader>s", { label = "+Session" })
nnoremap("<leader>ss", ":SaveSession<CR>", { label = "Save Session" })
nnoremap("<leader>sL", ":SearchSession<CR>", { label = "Search Session" })
nnoremap("<leader>sl", ":silent! bufdo Bdelete<CR>:silent! RestoreSession<CR>", { label = "Load Session" })

nnoremap("<leader>d", { label = "Debug Adapter" })
nnoremap("<leader>ds", { label = "+Step" })
nnoremap("<leader>dsu", "<cmd>lua require\"dap\".step_over()<CR>", { label = "Step Over" })
nnoremap("<leader>dsi", "<cmd>lua require\"dap\".step_into()<CR>", { label = "Step Into" })
nnoremap("<leader>dso", "<cmd>lua require\"dap\".step_out()<CR>", { label = "Step Out" })
nnoremap("<leader>dsv", "<cmd>lua require\"dap.ui.variables\".scopes()<CR>", { label = "Variable Scopes" })

nnoremap("<leader>dsb", { label = "+Breakpoint" })
nnoremap(
  "<leader>dsbr",
  "<cmd>lua require\"dap\".set_breakpoint(vim.fn.input(\"Breakpoint condition: \"))<CR>",
  { label = "Set Breakpoint condition" }
)
nnoremap("<leader>dsc", "<cmd>lua require\"dap\".continue()<CR>", { label = "Continue" })
nnoremap(
  "<leader>dsbm",
  "<cmd>lua require\"dap\".set_breakpoint(nil, nil, vim.fn.input(\"Log point message: \"))<CR>",
  { label = "Set Breakpoint log point" }
)
nnoremap("<leader>dsbt", "<cmd>lua require\"dap\".toggle_breakpoint()<CR>", { label = "Toggle Breakpoint" })

nnoremap("<leader>dh", { label = "+Hover" })
nnoremap("<leader>dhh", "<cmd>lua require\"dap.ui.variables\".hover()<CR>", { label = "Variable Hover" })
nnoremap("<leader>dhv", "<cmd>lua require\"dap.ui.variables\".visual_hover()<CR>", { label = "Variable Visual Hover" })
nnoremap("<leader>dhu", "<cmd>lua require\"dap.ui.widgets\".hover()<CR>", { label = "Widget Hover" })
nnoremap(
  "<leader>dhf",
  "<cmd>lua require\"dap.ui.widgets\".centered_float(widgets.scopes)<CR>",
  { label = "Widgets Centered Float Scopes" }
)

nnoremap("<leader>dr", { label = "+REPL" })
nnoremap("<leader>dro", "<cmd>lua require\"dap\".repl.open()<CR>", { label = "REPL Open" })
nnoremap("<leader>drl", "<cmd>lua require\"dap\".repl.run_last()<CR>", { label = "REPL run last" })

nnoremap("<leader>f", { label = "+Fuzzy" })

nnoremap("<leader>fr", "<cmd>lua require 'fzf-lua'.registers{}<CR>", {
  label = "Registers",
})

nnoremap("<leader>fk", "<cmd>lua require 'fzf-lua'.keymaps{}<CR>", {
  label = "Keymaps",
})

nnoremap("<leader>fB", function()
  require("fzf-lua").blines({})
end, {
  label = "Current Buffer",
})

nnoremap("<Leader>fb", function()
  require("fzf-lua").buffers({
    -- attach_mappings = function(_, map)
    --   map("i", "<C-d>", actions.delete_buffer)
    --   return true
    -- end,
  })
end, {
  label = "Buffers",
})

nnoremap("<leader>ff", function(opts)
  opts = opts or {}
  require("fzf-lua").files(opts)
end, {
  label = "Files",
  silent = true,
})

nnoremap("<leader>f:", function()
  require("fzf-lua").command_history({})
end, {
  label = "Command History",
  silent = true,
})

nnoremap("<leader>fg", function(opts)
  opts = opts or {}
  opts.continue_last_search = true
  require("fzf-lua").live_grep(opts)
end, {
  label = "Live Grep",
  silent = true,
})

vnoremap("<leader>fw", function(opts)
  opts = opts or {}
  require("fzf-lua").grep_visual(opts)
end, {
  label = "Grep String",
  silent = true,
})

nnoremap("<leader>fw", function(opts)
  opts = opts or {}
  require("fzf-lua").grep_cword(opts)
end, {
  label = "Grep String",
  silent = true,
})

nnoremap("<leader>fh", function()
  require("fzf-lua").help_tags()
end, {
  label = "Help Tags",
})

nnoremap("<leader>fm", function()
  require("fzf-lua").man_pages({ sections = { "ALL" } })
end, {
  label = "Man pages",
})

nnoremap("<leader>fs", function()
  require("fzf-lua").spell_suggest()
end, {
  label = "Spell suggest",
})

nnoremap("<leader>l", { label = "+LSP" })

nnoremap("<leader>lr", function()
  require("fzf-lua").lsp_references({})
end, { label = "References" })

nnoremap("<leader>ld", function()
  require("fzf-lua").lsp_definitions({})
end, {
  label = "Definitions",
})

nnoremap("<leader>lD", function()
  require("fzf-lua").lsp_declarations({})
end, {
  label = "Declarations",
})

nnoremap("<leader>li", function()
  require("fzf-lua").lsp_implementations({})
end, { label = "Implementation" })

nnoremap("<leader>ls", function()
  require("fzf-lua").lsp_document_symbols({})
end, {
  label = "Document Symbols",
})

nnoremap("<leader>lS", function()
  require("fzf-lua").lsp_workspace_symbols({})
end, {
  label = "Workspace Symbols",
})

nnoremap("<leader>lt", function()
  require("fzf-lua").lsp_typedefs({})
end, {
  label = "Type definitions",
})

nnoremap("<leader>la", function()
  require("fzf-lua").lsp_code_actions({})
end, { label = "Code actions" })

nnoremap("<leader>lh", function()
  -- instead of vim.lsp.buf.hover()
  -- solves issue where line_diagnostics would hide hover info because of CursorHold autocmd
  vim.api.nvim_command("set eventignore=CursorHold")
  vim.api.nvim_command("autocmd CursorMoved <buffer> ++once set eventignore=\"\"")
  vim.lsp.buf.hover()
end, {
  label = "Hover Doc",
})

nnoremap("<leader>lH", function()
  -- instead of vim.lsp.buf.signature_help()
  -- solves issue where line_diagnostics would hide hover info because of CursorHold autocmd
  vim.api.nvim_command("set eventignore=CursorHold")
  vim.api.nvim_command("autocmd CursorMoved <buffer> ++once set eventignore=\"\"")
  vim.lsp.buf.signature_help()
end, {
  label = "Signature",
})

nnoremap("<leader>lg", function()
  -- focus into diagnostic
  vim.api.nvim_command("set eventignore=WinLeave")
  vim.api.nvim_command("autocmd CursorMoved <buffer> ++once set eventignore=\"\"")
  vim.diagnostic.open_float(nil, {
    focusable = true,
    scope = "line",
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
  })
end, {
  label = "Diagnostics",
})

nnoremap("<leader>lG", function()
  require("fzf-lua").lsp_workspace_diagnostics({})
end, {
  label = "Diagnostics",
})

nnoremap("<leader>l]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { label = "Next Diagnostic" })
nnoremap("<leader>l[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { label = "Previous Diagnostic" })
nnoremap("<leader>ll", "<cmd>Trouble<CR>", { label = "Trouble" })
nnoremap("<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>", { label = "Rename" })
nnoremap("<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { label = "Declaration" })
nnoremap("<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { label = "Type Definition" })
nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", { label = "Formatting" })
nnoremap("<leader>lF", "<cmd>lua vim.lsp.buf.format()<CR>", { label = "Formatting" })
nnoremap("<leader>lc", { label = "+Calls" })
nnoremap("<leader>lco", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", { label = "Outgoing calls" })
nnoremap("<leader>lci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", { label = "Incoming calls" })

nnoremap("<leader>v", { label = "+Neovim" })
nnoremap("<leader>vm", "<cmd>TSHighlightCapturesUnderCursor<CR>", { label = "Show highlights under cursor" })
nnoremap("<leader>ve", "<cmd>e $MYVIMRC<CR>", { label = "Open VIMRC" })
nnoremap("<leader>vs", "<cmd>luafile $MYVIMRC<CR>", { label = "Source VIMRC" })
nnoremap("<leader>vz", "<cmd>e ~/.zshrc<CR>", { label = "Open ZSHRC" })
nnoremap("<leader>v:", "<cmd>FzfLua commands<CR>", { label = "Vim commands" })
nnoremap("<Leader>vv", function()
  require("fzf-lua").files({
    cwd = "~/.config/nvim",
  })
end, {
  label = "Search neovim config files",
  silent = true,
})
nnoremap("<Leader>v.", function()
  require("fzf-lua").files({
    cwd = "~/gitrepos/dotfiles",
  })
end, {
  label = "Search dotfiles",
  silent = true,
})
nnoremap("<Leader>vg", function()
  require("fzf-lua").files({
    cwd = "~/gitrepos",
  })
end, {
  label = "Search git repos",
  silent = true,
})

nnoremap("<leader>:w", function()
  vim.fn.mkdir(vim.fn.expand("%:p:h"), "p")
  vim.notify("Created " .. vim.fn.expand("%:p:h"))
  vim.cmd(":w")
end, { label = "Force write after creating folder" })
