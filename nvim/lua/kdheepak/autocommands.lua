vim.cmd([[
autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
]])

vim.api.nvim_command([[

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell

function s:AddTerminalMappings()
    echom &filetype
    if &filetype ==# ''
        tnoremap <buffer> <silent> <Esc> <C-\><C-n>
        tnoremap <buffer> <silent> <C-\><Esc> <Esc>
    endif
endfunction

augroup TermBuffer
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
    autocmd VimEnter * if !empty($NVIM_LISTEN_ADDRESS) && $NVIM_LISTEN_ADDRESS !=# v:servername
        \ |let g:r=jobstart(['nc', '-U', $NVIM_LISTEN_ADDRESS],{'rpc':v:true})
        \ |let g:f=fnameescape(expand('%:p'))
        \ |noau bwipe
        \ |call rpcrequest(g:r, "nvim_command", "edit ".g:f)
        \ |call rpcrequest(g:r, "nvim_command", "call lib#SetNumberDisplay()")
        \ |qa
        \ |endif
    " TermEnter is required here since otherwise fzf filetype is not set
    autocmd TermEnter * call s:AddTerminalMappings()
augroup END

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
augroup END

autocmd BufEnter * EnableStripWhitespaceOnSave
let g:strip_whitespace_confirm=0
let g:strip_only_modified_lines=1

autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

" autocmd! BufWritePost * make

]])
