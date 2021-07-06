vim.api.nvim_set_keymap('n', '<space>', '<nop>', { noremap = true, silent = true })

vim.g.nvim_tree_bindings = {
  { key = '/', cb = require'nvim-tree.config'.nvim_tree_callback('vsplit') },
  { key = '\\', cb = require'nvim-tree.config'.nvim_tree_callback('split') },
}

-- -- clear highlights
-- vim.api.nvim_set_keymap('n', '<leader><leader>', ':noh<cr>', { noremap = true, silent = true })

-- simplify split movements
vim.api.nvim_set_keymap('n', '<c-h>', '<c-w><c-h>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-j>', '<c-w><c-j>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-k>', '<c-w><c-k>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<c-l>', '<c-w><c-l>', { noremap = true, silent = true })

-- move through wrapped lines
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })

-- reselect after visual indent
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })

-- search visually selected text (consistent `*` behaviour)
vim.api.nvim_set_keymap('n', '*', [[*N]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '*', [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { noremap = true, silent = true })

-- bubble lines
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<cr>gv=gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<cr>gv=gv', { noremap = true, silent = true })

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t '<Plug>(vsnip-expand-or-jump)'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t '<Plug>(vsnip-jump-prev)'
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t '<S-Tab>'
  end
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
