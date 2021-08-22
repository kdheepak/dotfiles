set nowrap
setlocal commentstring=#\ %s
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd BufWritePre *.jl lua vim.lsp.buf.formatting_sync()
