vim.cmd([[
autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
]])

vim.cmd([[

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd TermOpen * setlocal nonumber
autocmd TermOpen * setlocal norelativenumber
autocmd TermOpen * let g:last_terminal_job_id = b:terminal_job_id | IndentGuidesDisable
autocmd BufWinEnter term://* IndentGuidesDisable

" Ensure comments don't go to beginning of line by default
autocmd! FileType * setlocal nosmartindent
" Disable autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" resize panes when host window is resized
autocmd VimResized * wincmd =

autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType gitcommit,gitrebase,gitconfig setl bufhidden=delete

augroup BgHighlight
autocmd!
autocmd WinEnter * set cursorline
autocmd WinLeave * set nocursorline
autocmd BufEnter * EnableStripWhitespaceOnSave
augroup END

let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=1

autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

" autocmd! BufWritePost * make

]])
