vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                                                                   {virtual_text = false, underline = true, signs = true, update_in_insert = false})
-- Send diagnostics to quickfix list
do
    local method = "textDocument/publishDiagnostics"
    local default_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
        default_handler(err, method, result, client_id, bufnr, config)
        local diagnostics = vim.lsp.diagnostic.get_all()
        local qflist = {}
        for bufnr, diagnostic in pairs(diagnostics) do
            for _, d in ipairs(diagnostic) do
                d.bufnr = bufnr
                d.lnum = d.range.start.line + 1
                d.col = d.range.start.character + 1
                d.text = d.message
                table.insert(qflist, d)
            end
        end
        vim.lsp.util.set_qflist(qflist)
    end
end
local lsp_status = require 'lsp-status'
lsp_status.register_progress()

local capabilities = lsp_status.capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {properties = {'documentation', 'detail', 'additionalTextEdits'}}

capabilities.textDocument.codeAction = {
    dynamicRegistration = true,
    codeActionLiteralSupport = {
        codeActionKind = {
            valueSet = (function()
                local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                table.sort(res)
                return res
            end)()
        }
    }
}

local lspconfig = require 'lspconfig'
local on_attach_vim = function(client, bufnr)
    require"lsp_signature".on_attach({bind = true, use_lspsaga = true, floating_window = true, fix_pos = true, hint_enable = true})
    require'lsp-status'.on_attach(client)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = {noremap = true, silent = true}

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead ctermbg=236 guibg=#363a4e cterm=bold gui=bold
        hi LspReferenceText ctermbg=236 guibg=#363a4e cterm=bold gui=bold
        hi LspReferenceWrite ctermbg=236 guibg=#363a4e cterm=bold gui=bold
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end
-- lspconfig.julials.setup({on_attach = on_attach_vim})
lspconfig.bashls.setup({on_attach = on_attach_vim, capabilities = capabilities})
lspconfig.ccls.setup({on_attach = on_attach_vim, capabilities = capabilities})
lspconfig.tsserver.setup({on_attach = on_attach_vim, capabilities = capabilities})
lspconfig.jsonls.setup({on_attach = on_attach_vim, capabilities = capabilities})
lspconfig.nimls.setup({on_attach = on_attach_vim, capabilities = capabilities})
lspconfig.rust_analyzer.setup({
    on_attach = on_attach_vim,
    capabilities = capabilities,
    settings = {['rust-analyzer'] = {cargo = {allFeatures = true, autoReload = true}, checkOnSave = {enable = true, command = "clippy"}}}
})
lspconfig.vimls.setup({on_attach = on_attach_vim, capabilities = capabilities})
lspconfig.cssls.setup({on_attach = on_attach_vim, capabilities = capabilities})

local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache') .. '/nvim_lsp/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup({
    capabilities = capabilities,
    on_attach = on_attach_vim,
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
})
lspconfig.html.setup({on_attach = on_attach_vim, capabilities = capabilities})
lspconfig.pyls.setup {
    on_attach = on_attach_vim,
    capabilities = capabilities,
    settings = {
        pyls = {
            configurationSources = {pycodestyle, flake8},
            plugins = {
                mccabe = {enabled = false},
                preload = {enabled = true},
                pycodestyle = {enabled = true, ignore = {"E501"}},
                pydocstyle = {enabled = false},
                pyflakes = {enabled = true},
                pylint = {enabled = false},
                rope_completion = {enabled = true},
                black = {enabled = false}
            }
        }
    }
}

require"lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {"lua", "julia"},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            lua = {
                {
                    formatCommand = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb",
                    formatStdin = true
                }
            },
            julia = {require'juliaformatter'.efmConfig}
        }
    }
}

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        sorting_strategy = "ascending",
        mappings = {
            n = {["<esc>"] = actions.close, ["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous},
            i = {["<esc>"] = actions.close, ["<C-j>"] = actions.move_selection_next, ["<C-k>"] = actions.move_selection_previous}
        }
    },
    extensions = {fzy_native = {override_generic_sorter = false, override_file_sorter = true}}
}
