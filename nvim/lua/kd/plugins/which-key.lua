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
local vnoremap = require("kd/utils").vnoremap

nnoremap("<Space>", "<NOP>", { silent = true })

nnoremap("<Tab>", "<cmd>TablineBufferNext<CR>", { label = "Jump to next buffer", silent = true })

nnoremap("<S-Tab>", "<cmd>TablineBufferPrevious<CR>", { label = "Jump to next buffer", silent = true })

nnoremap("<Leader><Leader>", ":nohlsearch<CR>", { label = "Clear Highlighting", silent = true })

vnoremap("<leader>p", '"+p', { label = "Paste from clipboard" })

vnoremap("<leader>P", '"+P', { label = "Paste from clipboard (before)" })

vnoremap("<leader>y", '"+y', { label = "Yank to clipboard" })

vnoremap("<leader>Y", '"+Y', { label = "Yank line to clipboard" })

vnoremap("<leader>d", '"+ygvd', { label = "Cut line to clipboard" })

nnoremap("<leader>p", '"+p', { label = "Paste from clipboard" })

nnoremap("<leader>P", '"+P', { label = "Paste from clipboard (before)" })

nnoremap("<leader>y", '"+y', { label = "Yank to clipboard" })

nnoremap("<leader>Y", '"+Y', { label = "Yank line to clipboard" })

nnoremap("<leader>v:", "<cmd>Telescope commands<CR>", { label = "Vim commands" })

nnoremap("<leader>/", "<cmd>ToggleTerm direction=horizontal<CR>", { label = "Split terminal horizontally" })

nnoremap("<leader>\\", "<cmd>ToggleTerm direction=vertical<CR>", { label = "Split terminal vertically" })

nnoremap("<C-w>/", "<cmd>split<CR>", { label = "Split window horizontally" })
nnoremap("<C-w>\\", "<cmd>vsplit<CR>", { label = "Split window vertically" })
nnoremap("<C-w>z", "<cmd>call zoom#toggle()<CR>", { label = "Zoom toggle" })

nnoremap("<leader>q", { label = "+Format" })
nnoremap("<leader>qt", "<cmd>Tabularize<CR>", { label = "Tabularize" })
nnoremap("<leader>qf", "<cmd>JuliaFormatterFormat<CR>", { label = "Format Julia file" })
nnoremap("<leader>qq", "<cmd>lua require('telescope.builtin').quickfix()<CR>", { label = "Quickfix" })

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
nnoremap("<leader>gg", "<cmd>LazyGit<CR>", { label = "Git Status" })
nnoremap("<leader>gC", "<cmd>Git commit<CR>", { label = "Git commit" })
nnoremap("<leader>go", "<cmd>GBrowse<CR>", { label = "Open file in browser" })
vnoremap("<leader>go", "<cmd>'<,'>GBrowse<CR>", { label = "Open file in browser" })
nnoremap("<leader>gS", "<cmd>Git<CR>", { label = "Status" })
nnoremap("<leader>gw", "<cmd>Gwrite<CR>", { label = "Stage" })
nnoremap("<leader>gD", "<cmd>Gdiffsplit<CR>", { label = "Diff" })
nnoremap("<leader>gd", "<cmd>DiffviewOpen<CR>", { label = "Diff ALL" })
nnoremap("<leader>gdt", ":call difftoggle#DiffToggle(1)<CR>", { label = "Diff toggle left" })
nnoremap("<leader>gdt", ":call difftoggle#DiffToggle(2)<CR>", { label = "Diff toggle middle" })
nnoremap("<leader>gdt", ":call difftoggle#DiffToggle(3)<CR>", { label = "Diff toggle right" })
nnoremap("<leader>gdu", ":diffupdate<CR>", { label = "Diff update" })
nnoremap("<leader>gdc", [[/\v^[<=>]{7}( .*\|$)<CR>]], { label = "Show commit markers" })
nnoremap("<leader>ghs", '<cmd>lua require"gitsigns".stage_hunk()<CR>', { label = "Stage Hunk" })
nnoremap("<leader>ghu", '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>', { label = "Undo Stage Hunk" })
nnoremap("<leader>ghr", '<cmd>lua require"gitsigns".reset_hunk()<CR>', { label = "Reset Hunk" })
nnoremap("<leader>ghR", '<cmd>lua require"gitsigns".reset_buffer()<CR>', { label = "Reset Buffer" })
nnoremap("<leader>ghp", '<cmd>lua require"gitsigns".preview_hunk()<CR>', { label = "Preview Hunk" })
nnoremap("<leader>ghb", '<cmd>lua require"gitsigns".blame_line(true)<CR>', { label = "Blame line" })

nnoremap("<leader>gc", function()
  require("telescope.builtin").git_commits({})
end, { label = "Git Commits" })

nnoremap("<leader>g%", function()
  require("telescope.builtin").git_bcommits({})
end, { label = "Git Buffer Commits" })

nnoremap("<leader>gr", function()
  local actions = require("telescope.actions")
  require("telescope.builtin").git_branches({
    attach_mappings = function(_, map)
      map("i", "<c-d>", actions.git_delete_branch)
      return true
    end,
  })
end, {
  label = "Git Branches",
})

nnoremap("<leader>gs", function()
  require("telescope.builtin").git_status({})
end, { label = "Git Status" })

nnoremap("<leader>s", { label = "+Session" })
nnoremap("<leader>ss", ":SaveSession<CR>", { label = "Save Session" })
nnoremap("<leader>ss", ":silent! bufdo Bdelete<CR>:silent! RestoreSession<CR>", { label = "Load Session" })

nnoremap("<leader>d", { label = "Debug Adapter" })
nnoremap("<leader>ds", { label = "+Step" })
nnoremap("<leader>dsu", '<cmd>lua require"dap".step_over()<CR>', { label = "Step Over" })
nnoremap("<leader>dsi", '<cmd>lua require"dap".step_into()<CR>', { label = "Step Into" })
nnoremap("<leader>dso", '<cmd>lua require"dap".step_out()<CR>', { label = "Step Out" })
nnoremap("<leader>dsv", '<cmd>lua require"dap.ui.variables".scopes()<CR>', { label = "Variable Scopes" })

nnoremap("<leader>dsb", { label = "+Breakpoint" })
nnoremap(
  "<leader>dsbr",
  '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
  { label = "Set Breakpoint condition" }
)
nnoremap("<leader>dsc", '<cmd>lua require"dap".continue()<CR>', { label = "Continue" })
nnoremap(
  "<leader>dsbm",
  '<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
  { label = "Set Breakpoint log point" }
)
nnoremap(
  "<leader>dsbl",
  '<cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>',
  { label = "Telescope List Breakpoints" }
)
nnoremap("<leader>dsbt", '<cmd>lua require"dap".toggle_breakpoint()<CR>', { label = "Toggle Breakpoint" })

nnoremap("<leader>dh", { label = "+Hover" })
nnoremap("<leader>dhh", '<cmd>lua require"dap.ui.variables".hover()<CR>', { label = "Variable Hover" })
nnoremap("<leader>dhv", '<cmd>lua require"dap.ui.variables".visual_hover()<CR>', { label = "Variable Visual Hover" })
nnoremap("<leader>dhu", '<cmd>lua require"dap.ui.widgets".hover()<CR>', { label = "Widget Hover" })
nnoremap(
  "<leader>dhf",
  '<cmd>lua require"dap.ui.widgets".centered_float(widgets.scopes)<CR>',
  { label = "Widgets Centered Float Scopes" }
)

nnoremap("<leader>dr", { label = "+REPL" })
nnoremap("<leader>dro", '<cmd>lua require"dap".repl.open()<CR>', { label = "REPL Open" })
nnoremap("<leader>drl", '<cmd>lua require"dap".repl.run_last()<CR>', { label = "REPL run last" })

nnoremap("<leader>dt", { label = "+Telescope" })
nnoremap("<leader>dtc", '<cmd>lua require"telescope".extensions.dap.commands{}<CR>', { label = "Telescope Commands" })
nnoremap(
  "<leader>dtC",
  '<cmd>lua require"telescope".extensions.dap.configurations{}<CR>',
  { label = "Telescope Configurations" }
)
nnoremap("<leader>dtv", '<cmd>lua require"telescope".extensions.dap.variables{}<CR>', { label = "Telescope Variables" })
nnoremap("<leader>dtf", '<cmd>lua require"telescope".extensions.dap.frames{}<CR>', { label = "Telescope Frames" })

nnoremap("<leader>f", { label = "+Fuzzy" })

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function actions.fzf_multi_select(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = table.getn(picker:get_multi_selection())

  if num_selections > 1 then
    picker = action_state.get_current_picker(prompt_bufnr)
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s", ":e!", entry.value))
    end
    vim.cmd("stopinsert")
  else
    actions.file_edit(prompt_bufnr)
  end
end

nnoremap("<leader>ft", "<cmd>TodoTelescope<CR>", { label = "Todos" })

nnoremap("<leader>fB", function()
  require("telescope.builtin").current_buffer_fuzzy_find({})
end, {
  label = "Current Buffer",
})

nnoremap("<Leader>fb", function()
  require("telescope.builtin").buffers({
    attach_mappings = function(_, map)
      map("i", "<C-d>", actions.delete_buffer)
      return true
    end,
  })
end, {
  label = "Buffers",
})

nnoremap("<leader>ff", function(opts)
  opts = opts or {}
  if vim.loop.cwd() == vim.loop.os_homedir() then
    vim.api.nvim_echo({
      {
        "find_files on $HOME is danger. Launch file_browser instead.",
        "WarningMsg",
      },
    }, true, {})
    opts.attach_mappings = function(_, map)
      map("i", "<cr>", actions.fzf_multi_select)
      return true
    end
    require("telescope.builtin").file_browser(opts)
  elseif vim.fn.isdirectory(vim.loop.cwd() .. "/.git") == 1 then
    opts.attach_mappings = function(_, map)
      map("i", "<cr>", actions.fzf_multi_select)
      return true
    end
    require("telescope.builtin").git_files(opts)
  else
    -- add hidden files to find_files
    opts.hidden = true
    opts.attach_mappings = function(_, map)
      map("i", "<cr>", actions.fzf_multi_select)
      return true
    end
    require("telescope.builtin").find_files(opts)
  end
end, {
  label = "Files",
  silent = true,
})

nnoremap("<leader>f:", function()
  require("telescope.builtin").command_history({})
end, {
  label = "Command History",
  silent = true,
})

nnoremap("<leader>fG", function(opts)
  opts = opts or {}
  opts.attach_mappings = function(_, map)
    map("i", "<cr>", actions.fzf_multi_select)
    return true
  end
  require("telescope.builtin").grep_string(opts)
end, {
  label = "Grep String",
  silent = true,
})

nnoremap("<leader>fh", function()
  require("telescope.builtin").help_tags({ lang = "en" })
end, { label = "Help Tags" })

nnoremap("<leader>fP", function()
  require("telescope").load_extension("packer").plugins({})
end, { label = "Packer" })

nnoremap("<leader>fm", function()
  require("telescope.builtin").man_pages({ sections = { "ALL" } })
end, {
  label = "Man pages",
})

nnoremap("<leader>fs", function()
  require("telescope.builtin").symbols({ sources = { "emoji", "kaomoji", "gitmoji", "latex", "math" } })
end, {
  label = "Symbols",
})

nnoremap("<leader>l", { label = "+LSP" })

nnoremap("<leader>lr", function()
  require("telescope.builtin").lsp_references({})
end, { label = "References" })

nnoremap("<leader>li", function()
  require("telescope.builtin").lsp_implementations({})
end, { label = "Implementation" })

nnoremap("<leader>ls", function()
  require("telescope.builtin").lsp_document_symbols({})
end, {
  label = "Document Symbols",
})

nnoremap("<leader>lS", function()
  require("telescope.builtin").lsp_workspace_symbols({})
end, {
  label = "Workspace Symbols",
})

nnoremap("<leader>la", function()
  require("telescope.builtin").lsp_code_actions({})
end, { label = "Code actions" })

vnoremap("<leader>la", function()
  require("telescope.builtin").lsp_range_code_actions({})
end, {
  label = "Code actions",
})

nnoremap("<leader>lg", function()
  require("telescope.builtin").lsp_document_diagnostics({})
end, {
  label = "Diagnostics",
})

nnoremap("<leader>lG", function()
  require("telescope.builtin").lsp_document_diagnostics({})
end, {
  label = "Diagnostics",
})

nnoremap("<leader>ld", function()
  require("telescope.builtin").lsp_definitions({})
end, {
  label = "Definitions",
})

nnoremap("<leader>l]", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { label = "Next Diagnostic" })
nnoremap("<leader>l[", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { label = "Previous Diagnostic" })
nnoremap("<leader>ll", "<cmd>Trouble<CR>", { label = "Trouble" })
nnoremap("<leader>lR", "<cmd>lua vim.lsp.buf.rename()<CR>", { label = "Rename" })
nnoremap("<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { label = "Declaration" })
nnoremap("<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { label = "Type Definition" })
nnoremap("<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", { label = "Hover Doc" })
nnoremap("<leader>lH", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { label = "Signature" })
nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", { label = "Formatting" })
nnoremap("<leader>lF", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", { label = "Formatting" })
nnoremap("<leader>lc", { label = "+Calls" })
nnoremap("<leader>lco", "<cmd>lua vim.lsp.buf.outgoing_calls()<CR>", { label = "Outgoing calls" })
nnoremap("<leader>lci", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", { label = "Incoming calls" })
nnoremap("<leader>lG", "<cmd>edit " .. vim.lsp.get_log_path() .. "<CR>", { label = "Open LSP Log file" })

nnoremap("<leader>v", { label = "+Neovim" })
nnoremap("<leader>vm", "<cmd>TSHighlightCapturesUnderCursor<CR>", { label = "Show highlights under cursor" })
nnoremap("<leader>ve", "<cmd>e $MYVIMRC<CR>", { label = "Open VIMRC" })
nnoremap("<leader>vs", "<cmd>luafile $MYVIMRC<CR>", { label = "Source VIMRC" })
nnoremap("<leader>vz", "<cmd>e ~/.zshrc<CR>", { label = "Open ZSHRC" })
nnoremap("<Leader>vv", function()
  require("telescope.builtin").find_files({
    prompt_title = " Search Config Files ",
    prompt_prefix = "   ",
    cwd = "~/.config/nvim",
  })
end, {
  label = "Config files",
})
nnoremap("<Leader>v.", function()
  require("telescope.builtin").find_files({
    prompt_title = "Search Dotfiles",
    prompt_prefix = "  ",
    cwd = "~/gitrepos/dotfiles",
  })
end, {
  label = "Search git repos",
})
nnoremap("<Leader>vg", function()
  require("telescope.builtin").find_files({
    prompt_title = "Search Repos",
    prompt_prefix = "  ",
    cwd = "~/gitrepos",
  })
end, {
  label = "Search git repos",
})
