execute = vim.api.nvim_command
fn = vim.fn
cmd = vim.cmd
lsp = vim.lsp
api = vim.api
g = vim.g      -- a table to access global variables

-- For debugging purpose
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

require'kdheepak/plugins'

require'kdheepak/options'

require'kdheepak/keymappings'

require'kdheepak/autocommands'

require'kdheepak/vim'

require'kdheepak/config'

require'kdheepak/which-key'
