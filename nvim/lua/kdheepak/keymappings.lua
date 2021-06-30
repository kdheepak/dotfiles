api.nvim_set_keymap('n', '<space>', '<nop>', {noremap = true, silent = true})

-- -- clear highlights
-- api.nvim_set_keymap('n', '<leader><leader>', ':noh<cr>', { noremap = true, silent = true })

-- simplify split movements
api.nvim_set_keymap('n', '<c-h>', '<c-w><c-h>', {noremap = true, silent = true})
api.nvim_set_keymap('n', '<c-j>', '<c-w><c-j>', {noremap = true, silent = true})
api.nvim_set_keymap('n', '<c-k>', '<c-w><c-k>', {noremap = true, silent = true})
api.nvim_set_keymap('n', '<c-l>', '<c-w><c-l>', {noremap = true, silent = true})

-- move through wrapped lines
api.nvim_set_keymap('n', 'j', 'gj', {noremap = true, silent = true})
api.nvim_set_keymap('n', 'k', 'gk', {noremap = true, silent = true})

-- reselect after visual indent
api.nvim_set_keymap('v', '<', '<gv', {noremap = true, silent = true})
api.nvim_set_keymap('v', '>', '>gv', {noremap = true, silent = true})

-- search visually selected text (consistent `*` behaviour)
api.nvim_set_keymap('n', '*', [[*N]], {noremap = true, silent = true})
api.nvim_set_keymap('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], {noremap = true, silent = true})

-- bubble lines
api.nvim_set_keymap('x', 'J', ":move '>+1<cr>gv=gv", {noremap = true, silent = true})
api.nvim_set_keymap('x', 'K', ":move '<-2<cr>gv=gv", {noremap = true, silent = true})

-- nvim-compe
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t('<c-n>')
    elseif vim.fn.call('vsnip#available', {1}) == 1 then
        return t('<plug>(vsnip-expand-or-jump)')
    elseif check_back_space() then
        return t('<tab>')
    else
        return vim.fn['compe#complete']()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t('<c-p>')
    elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
        return t('<plug>(vsnip-jump-prev)')
    else
        return t('<s-tab>')
    end
end

vim.api.nvim_set_keymap('i', '<tab>', 'v:lua.tab_complete()', {silent = true, expr = true})
vim.api.nvim_set_keymap('s', '<tab>', 'v:lua.tab_complete()', {silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<s-tab>', 'v:lua.s_tab_complete()', {silent = true, expr = true})
vim.api.nvim_set_keymap('s', '<s-tab>', 'v:lua.s_tab_complete()', {silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<cr>', [[compe#confirm('<cr>')]], {silent = true, expr = true})
vim.api.nvim_set_keymap('i', '<c-space>', 'compe#complete()', {silent = true, expr = true})
