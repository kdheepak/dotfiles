local M = {}
local augroup = require("kd/utils").augroup
local autocmd = require("kd/utils").autocmd
local nnoremap = require("kd/utils").nnoremap
local vnoremap = require("kd/utils").vnoremap
local lsp_status = require("lsp-status")
local navic = require("nvim-navic")

local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
  capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)
  return capabilities
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  border = border,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
  focusable = true,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
  focusable = true,
})

augroup("LSPDiagVistaNearest", function()
  autocmd("CursorHold", function()
    vim.diagnostic.open_float(0, {
      scope = "cursor",
      focusable = false,
      border = border,
      close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinLeave" },
    })
  end)
end)

M._should_format = true

function M.on_save()
  if M._should_format then
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end
end

function M.toggle_format_on_save()
  M._should_format = not M._should_format
  if M._should_format then
    require("notify").notify("Enabled format on save", nil, { title = "kdheepak/dotfiles" })
  else
    require("notify").notify("Disabled format on save", nil, { title = "kdheepak/dotfiles" })
  end
end

vim.cmd([[command LspToggleFormatOnSave lua require'kd/plugins/nvim-lspconfig'.toggle_format_on_save()]])

local lspconfig = require("lspconfig")

local function on_attach(client, bufnr)
  navic.attach(client, bufnr)
  lsp_status.on_attach(client)
  client.config.flags = client.config.flags or {}
  if
    client.name == "dockerls"
    or client.name == "tsserver"
    or client.name == "ccls"
    or client.name == "jsonls"
    or client.name == "svelte"
    or client.name == "sumneko_lua"
    or client.name == "html"
  then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  else
    local opt = { silent = true, buffer = bufnr }
    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting or client.server_capabilities.documentFormattingProvider then
      nnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opt)
      vnoremap("<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opt)
    end
    if client.server_capabilities.document_formatting or client.server_capabilities.documentFormattingProvider then
      autocmd("BufWritePre", require("kd/plugins/nvim-lspconfig").on_save)
    end
  end

  -- set up buffer keymaps, etc.
end

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.sumneko_lua.setup({
  capabilities = create_capabilities(),
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
})

local servers = {
  pyright = {},
  rust_analyzer = {},
  dockerls = {},
  tailwindcss = {},
  vimls = {},
  svelte = {},
  tsserver = {},
  julials = {
    -- This just adds dirname(fname) as a fallback (see nvim-lspconfig#1768).
    root_dir = function(fname)
      local util = require("lspconfig.util")
      return util.root_pattern("Project.toml")(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  sqlls = {},
  bashls = {},
  cmake = {},
  dotls = {},
  cssls = {},
  html = {},
  jsonls = {},
  vuels = {},
  nimls = {},
}

for name, config in pairs(servers) do
  config = vim.tbl_extend("keep", config or {}, {
    on_attach = on_attach,
    capabilities = create_capabilities(),
  })
  require("lspconfig")[name].setup(config)
end

return M
