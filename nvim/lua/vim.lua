api.nvim_exec([[
set nocompatible              " be iMproved, required
filetype off                  " required

colorscheme dracula

filetype plugin indent on    " required
syntax enable | " enable syntax processing

let g:VtrStripLeadingWhitespace = 0
let g:VtrClearEmptyLines = 0
let g:VtrAppendNewline = 1

" vim-markdown
let g:vim_markdown_emphasis_multiline = 0
let g:vim_markdown_folding_disabled = 1
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_fenced_languages = ['julia=jl', 'python=py']

let g:latex_to_unicode_auto = 1
let g:latex_to_unicode_tab = 0
let g:latex_to_unicode_cmd_mapping = ['<C-j>']

" TODO: add shortcut to transform string
let g:unicoder_cancel_normal = 1
let g:unicoder_cancel_insert = 1
let g:unicoder_cancel_visual = 1
let g:unicoder_no_map = 1

" Markdown Preview
" Don't start markdown preview automatically, use :MarkdownPreview
let g:mkdp_auto_start = 0

let g:python3_host_prog = expand('~/miniconda3/bin/python3')

" Merge Tool
" 3-way merge
let g:mergetool_layout = 'bmr'
let g:mergetool_prefer_revision = 'local'

" Camelcase Motion
" Sets up within word motions to use ,
let g:camelcasemotion_key = ','

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_color_change_percent = 1
let g:indent_guides_exclude_filetypes = ['help', 'fzf', 'openterm', 'neoterm', 'calendar']

let g:clever_f_across_no_line    = 1
let g:clever_f_fix_key_direction = 1

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
noremap gj G
noremap ge G$
noremap gk gg
noremap gi 0
noremap gh ^
noremap gl $
noremap gt H20k
noremap gb L20j
noremap ga <C-^>

noremap zj <C-e>
noremap zk <C-y>

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

nnoremap <silent> <TAB>    :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap <silent> <S-TAB>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

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

"""""""""""""""""""""""""""""""""""""""" commentary.vim

autocmd FileType julia setlocal commentstring=#\ %s

" Clear highlighting
nnoremap <silent> <leader><leader> :nohl<CR>:delmarks! \| delmarks a-zA-Z0-9<CR><ESC>

" Clears hlsearch after doing a search, otherwise just does normal <CR> stuff
nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <leader>\ :vsplit\|wincmd l\|terminal<CR>

nnoremap <silent> <leader>/ :split\|wincmd l\|terminal<CR>

vnoremap <leader>y "+y

vnoremap <leader>d "+ygvd

nnoremap <leader>p "+p<CR>
vnoremap <leader>p "+p<CR>

nnoremap <leader>P "+P<CR>
vnoremap <leader>P "+P<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <leader>wc :close<CR>

nnoremap <silent> <leader>w/ :split<CR>

nnoremap <silent> <leader>w\ :vsplit<CR>

nnoremap <silent> <leader>wh <C-w>h

nnoremap <silent> <leader>wj <C-w>j

nnoremap <silent> <leader>wl <C-w>l

nnoremap <silent> <leader>wk <C-w>k

nnoremap <silent> <leader>wH <C-w>H

nnoremap <silent> <leader>wJ <C-w>J

nnoremap <silent> <leader>wL <C-w>L

nnoremap <silent> <leader>wK <C-w>K

nnoremap <silent> <leader>wo :only<CR>

nnoremap <silent> <leader>w= <C-w>=

nnoremap <silent> <leader>w+ 20<C-w>+

nnoremap <silent> <leader>w- 20<C-w>-

nnoremap <silent> <leader>w< 20<C-w><

nnoremap <silent> <leader>w> 20<C-w>>

nnoremap <silent> <leader>wp :wincmd P<CR>

nnoremap <silent> <leader>wz :wincmd z<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <leader>oq  :copen<CR>

nnoremap <silent> <leader>ol  :lopen<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>qt :Tabularize<CR>
nnoremap <leader>qt :Tabularize<CR>
nnoremap <leader>qjf :JuliaFormatterFormat<CR>
vnoremap <leader>qjf :JuliaFormatterFormat<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

noremap <leader>gw :Gwrite<CR>

noremap <leader>gc :Gcommit<CR>

noremap <leader>go :Gbrowse<CR>
vnoremap <leader>go :Gbrowse<CR>

noremap <leader>gp :Gpush<CR>

noremap <leader>gP :Gpull<CR>

noremap <leader>gb :Gblame<CR>

noremap <leader>gd :Gvdiff<CR>

noremap <leader>gr :Gremove<CR>

noremap <leader>gj :GitGutterNextHunk<CR>

noremap <leader>gk :GitGutterPrevHunk<CR>

noremap <leader>gg :LazyGit<CR>

let g:lazygit_floating_window_use_plenary = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! DeleteCurrentBuffer()
  let l:buffernumber = bufnr('%')
  execute ":bn" | execute ":bd " . l:buffernumber
endfunction
command! BufferDelete :call DeleteCurrentBuffer()

nnoremap <silent> <leader>bd :BufferDelete<CR>

nnoremap <silent> <leader>bw :write<CR>

nnoremap <silent> <leader>bj :bnext<CR>

nnoremap <silent> <leader>bk :bprev<CR>

nnoremap <silent> <leader>bq :copen<CR>

nnoremap <silent> <leader>bQ :cclose<CR>

" nnoremap <silent> <leader>bb :FzfBuffers<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Using lua functions
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>

nnoremap <leader>fi <cmd>lua require('telescope').extensions.gh.issues()<cr>
nnoremap <leader>fp <cmd>lua require('telescope').extensions.gh.pull_request()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>dct <cmd>lua require"dap".continue()<CR>
nnoremap <leader>dsv <cmd>lua require"dap".step_over()<CR>
nnoremap <leader>dsi <cmd>lua require"dap".step_into()<CR>
nnoremap <leader>dso <cmd>lua require"dap".step_out()<CR>
nnoremap <leader>dtb <cmd>lua require"dap".toggle_breakpoint()<CR>

nnoremap <leader>dsc <cmd>lua require"dap.ui.variables".scopes()<CR>
nnoremap <leader>dhh <cmd>lua require"dap.ui.variables".hover()<CR>
nnoremap <leader>dhv <cmd>lua require"dap.ui.variables".visual_hover()<CR>

nnoremap <leader>duh <cmd>lua require"dap.ui.widgets".hover()<CR>
nnoremap <leader>duf <cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>

nnoremap <leader>dsbr <cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>
nnoremap <leader>dsbm <cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>
nnoremap <leader>dro <cmd>lua require"dap".repl.open()<CR>
nnoremap <leader>drl <cmd>lua require"dap".repl.run_last()<CR>
nnoremap <leader>dcc <cmd>lua require"telescope".extensions.dap.commands{}<CR>
nnoremap <leader>dco <cmd>lua require"telescope".extensions.dap.configurations{}<CR>
nnoremap <leader>dlb <cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>
nnoremap <leader>dv <cmd>lua require"telescope".extensions.dap.variables{}<CR>
nnoremap <leader>df <cmd>lua require"telescope".extensions.dap.frames{}<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <silent> <C-u> <C-\><C-O>:call unicode#Fuzzy()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <leader>ld :Lspsaga preview_definition<CR>

nnoremap <silent> <leader>lh :Lspsaga hover_doc<CR>

nnoremap <silent> <leader>ls :Lspsaga signature_help<CR>

nnoremap <silent> <leader>lr :Lspsaga rename<CR>

nnoremap <silent> <leader>lf :Lspsaga lsp_finder<CR>

nnoremap <silent> <leader>l0 :lua vim.lsp.buf.document_symbol()<CR>

nnoremap <silent> <leader>lw :lua vim.lsp.buf.workspace_symbol()<CR>

nnoremap <silent> <leader>lg <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>

nnoremap <silent> <leader>ll :lua vim.lsp.buf.declaration()<CR>

nnoremap <silent> <leader>lj :NextDiagnosticCycle<CR>

nnoremap <silent> <leader>lk :PreviousDiagnosticCycle<CR>

nnoremap <silent> <leader>] :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <leader>[ :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

nnoremap <silent> <leader>lc :Lspsaga code_action<CR>
vnoremap <silent> <leader>lc :<C-U>Lspsaga range_code_action<CR>

autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * lua require'lsp_extensions'.inlay_hints{ only_current_line = true, prefix = '» ', highlight = "Comment", }

autocmd CursorHold * lua require'lspsaga.diagnostic'.show_cursor_diagnostics()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> <leader>ve :e $MYVIMRC<CR>

nnoremap <silent> <leader>vs :source $MYVIMRC<CR>

nnoremap <silent> <leader>vl :luafile %<CR>

nnoremap <silent> <leader>vz :e ~/.zshrc<CR>

nnoremap <silent> <leader>v- :NnnPicker '%:p:h'<CR>

nnoremap <silent> <leader>v= :terminal<CR>

nnoremap          <leader>v. :cd %:p:h<CR>:pwd<CR>

nnoremap <leader>vu :UndotreeToggle<CR>

command! ZoomToggle :call zoom#toggle()
nnoremap <leader>vz :ZoomToggle<CR>
let g:lsp_log_file = luaeval('vim.lsp.get_log_path()')
command! LspLogFile execute 'edit ' . g:lsp_log_file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <F5> :lua require("nabla").place_inline()<CR>

let bufferline = get(g:, 'bufferline', {})
]], false)
