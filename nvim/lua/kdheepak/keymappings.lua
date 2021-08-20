vim.api.nvim_set_keymap("n", "<space>", "<nop>", { noremap = true, silent = true })

-- -- clear highlights
-- vim.api.nvim_set_keymap('n', '<leader><leader>', ':noh<cr>', { noremap = true, silent = true })

-- simplify split movements
vim.api.nvim_set_keymap("n", "<c-h>", "<c-w><c-h>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-j>", "<c-w><c-j>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-k>", "<c-w><c-k>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-l>", "<c-w><c-l>", { noremap = true, silent = true })

-- move through wrapped lines
vim.api.nvim_set_keymap("n", "j", "gj", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "k", "gk", { noremap = true, silent = true })

-- reselect after visual indent
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- search visually selected text (consistent `*` behaviour)
vim.api.nvim_set_keymap("n", "*", [[*N]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "*", [[y/\V<c-r>=escape(@",'/\')<cr><cr>N]], { noremap = true, silent = true })

-- bubble lines
vim.api.nvim_set_keymap("x", "J", ":move '>+1<cr>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "K", ":move '<-2<cr>gv=gv", { noremap = true, silent = true })
