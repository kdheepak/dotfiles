local augroup = require("kd/utils").augroup
local autocmd = require("kd/utils").autocmd

local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown" }
  capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
      codeActionKind = {
        valueSet = (function()
          local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
          table.sort(res)
          return res
        end)(),
      },
    },
  }
  return capabilities
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  underline = false,
  signs = true,
  update_in_insert = false,
})

vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler

augroup("LSPDiagVistaNearest", function()
  autocmd("VimEnter", "*", "call vista#RunForNearestMethodOrFunction()")
  autocmd("CursorHold", "*", function()
    vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })
  end)
end)

local lsp_status = require("lsp-status")
lsp_status.register_progress()

local lspconfig = require("lspconfig")
local on_attach_vim = function(client, bufnr)
  -- require("lsp_signature").on_attach({ bind = true, floating_window = true, fix_pos = true, hint_enable = true })
  require("lsp-status").on_attach(client)
  -- require'illuminate'.on_attach(client)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
end

local lsp = require("lspconfig")
-- require'packer'.loader 'coq_nvim coq.artifacts'
local function coq_setup(name, config)
  lsp[name].setup(config)
end

coq_setup("julials", {
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    on_attach_vim(client, bufnr)
  end,
  capabilities = create_capabilities(),
})
coq_setup("bashls", { on_attach = on_attach_vim, capabilities = create_capabilities() })
coq_setup("ccls", { on_attach = on_attach_vim, capabilities = create_capabilities() })
coq_setup("tsserver", { on_attach = on_attach_vim, capabilities = create_capabilities() })
coq_setup("jsonls", { on_attach = on_attach_vim, capabilities = create_capabilities() })
coq_setup("nimls", { on_attach = on_attach_vim, capabilities = create_capabilities() })
coq_setup("rust_analyzer", {
  on_attach = on_attach_vim,
  capabilities = create_capabilities(),
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true, autoReload = true },
      checkOnSave = { enable = true, command = "clippy" },
    },
  },
})
coq_setup("vimls", { on_attach = on_attach_vim, capabilities = create_capabilities() })
coq_setup("cssls", { on_attach = on_attach_vim, capabilities = create_capabilities() })

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has("win32") == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath("cache") .. "/nvim_lsp/sumneko_lua/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

coq_setup("sumneko_lua", {
  capabilities = create_capabilities(),
  on_attach = on_attach_vim,
  cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
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
coq_setup("html", { on_attach = on_attach_vim, capabilities = create_capabilities() })
coq_setup("vuels", { on_attach = on_attach_vim, capabilities = create_capabilities() })

coq_setup("pyright", { on_attach = on_attach_vim, capabilities = create_capabilities() })

local null_ls = require("null-ls")
local builtins = null_ls.builtins
local generator = null_ls.generator

null_ls.config({
  sources = {
    builtins.formatting.stylua.with({
      args = { "--indent-width=2", "--quote-style=AutoPreferDouble", "--indent-type=Spaces", "-" },
    }),
    -- builtins.formatting.prettier,
    builtins.formatting.shfmt.with({
      args = { "-i", "4", "-ci" },
    }),
    -- builtins.diagnostics.write_good,
    -- builtins.diagnostics.markdownlint,
    builtins.diagnostics.shellcheck,
    builtins.diagnostics.hadolint,
    {
      name = "checkmake",
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "make" },
      generator = generator({
        command = "checkmake",
        args = {
          "--format={{.LineNumber}}:{{.Rule}}:{{.Violation}}",
          "$FILENAME",
        },
        on_output = function(line)
          line = line:gsub("\r", "")
          local items = vim.split(line, ":")
          return {
            row = tonumber(items[1]),
            source = "checkmake",
            message = items[3],
            severity = vim.lsp.protocol.DiagnosticSeverity.Warning,
          }
        end,
        to_stderr = true,
        ignore_errors = true,
        format = "line",
      }),
    },
  },
})

lspconfig["null-ls"].setup({
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()")
    end
  end,
})
