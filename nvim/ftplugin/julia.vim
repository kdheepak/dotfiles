autocmd BufWritePre *.jl lua vim.lsp.buf.formatting_sync()
