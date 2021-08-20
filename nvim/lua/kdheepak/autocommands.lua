vim.cmd([[
autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
]])

vim.cmd([[

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell

" Ensure comments don't go to beginning of line by default
autocmd! FileType * setlocal nosmartindent
" resize panes when host window is resized
autocmd VimResized * wincmd =

autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType gitcommit,gitrebase,gitconfig setl bufhidden=delete

let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=1

set autoread
autocmd FocusGained * silent! :checktime

" autocmd! BufWritePost * make

]])
