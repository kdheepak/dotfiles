vim.api.nvim_exec([[

cnoremap <expr> <C-k>  pumvisible() ? "<C-p>"  : "<Up>"
cnoremap <expr> <C-j>  pumvisible() ? "<C-n>"  : "<Down>"

" Use virtual replace mode all the time
nnoremap r gr
nnoremap R gR

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
nnoremap > >>_
nnoremap < <<_

" Navigate jump list
nnoremap g, <C-o>
nnoremap g. <C-i>

" highlight last inserted text
nnoremap gV `[v`]

" move vertically by visual line
nnoremap j gj
nnoremap k gk
" move vertically by actual line
nnoremap J j
nnoremap K k

" move to beginning of the line
noremap H ^
" move to end of the line
noremap L $

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" copy to the end of line
nnoremap Y y$

" allow W, Q to be used instead of w and q
command! W w
command! -bang Q q
command! -bang Qa qa

" kakoune like mapping
noremap ge G$
noremap gj G
noremap gk gg
noremap gi 0
noremap gh ^
noremap gl $
noremap gt H20k
noremap gb L20j
noremap ga <C-^>

" Macros
nnoremap Q @q
vnoremap Q :norm @@<CR>

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" redo
nnoremap U <C-R>

" Repurpose cursor keys
nnoremap <silent> <Up> :cprevious<CR>
nnoremap <silent> <Down> :cnext<CR>
nnoremap <silent> <Left> :cpfile<CR>
nnoremap <silent> <Right> :cnfile<CR>

nnoremap <kPlus> <C-a>
nnoremap <kMinus> <C-x>
nnoremap + <C-a>
nnoremap - <C-x>
vnoremap + g<C-a>gv
vnoremap - g<C-x>gv

nmap <Plug>SpeedDatingFallbackUp   <Plug>(CtrlXA-CtrlA)
nmap <Plug>SpeedDatingFallbackDown <Plug>(CtrlXA-CtrlX)

nmap <silent> tt :tabnew<CR>

" backtick goes to the exact mark location, single quote just the line; swap 'em
nnoremap ` '
nnoremap ' `

" delete buffer
" works nicely in terminal mode as well
nnoremap <silent> <C-d><C-d> :confirm bdelete<CR>

nnoremap <silent> <TAB>    :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:BufferNext<CR>
nnoremap <silent> <S-TAB>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:BufferPrevious<CR>

" Opens line below or above the current line
inoremap <S-CR> <C-O>o
inoremap <C-CR> <C-O>O

" Sizing window horizontally
nnoremap <c-,> <C-W><
nnoremap <c-.> <C-W>>

let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"

let g:prettier#config#prose_wrap = 'always'

" make searching with * use vim-asterisk
map *  <Plug>(asterisk-z*)zzzv
map #  <Plug>(asterisk-z#)zzzv
map g* <Plug>(asterisk-gz*)zzzv
map g# <Plug>(asterisk-gz#)zzzv
nmap n <Plug>(anzu-n-with-echo)zzzv
nmap N <Plug>(anzu-N-with-echo)zzzv

let g:asterisk#keeppos = 1

let g:medieval_langs = ['python=python3', 'julia', 'sh', 'console=bash']
nnoremap <buffer> Z! :<C-U>EvalBlock<CR>
let g:slime_target = "neovim"

autocmd FileType julia setlocal commentstring=#\ %s

" Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()

inoremap <silent> <C-u> <C-\><C-O>:call unicode#Fuzzy()<CR>

command! ZoomToggle :call zoom#toggle()
nnoremap <leader>vz :ZoomToggle<CR>

let g:lsp_log_file = luaeval('vim.lsp.get_log_path()')
command! LspLogFile execute 'edit ' . g:lsp_log_file

]], false)
