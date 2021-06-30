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


require('kdheepak/plugins')

require('kdheepak/options')

require('kdheepak/keymappings')

require('kdheepak/autocommands')

require('kdheepak/vim')

require('kdheepak/config')

vim.notify = function (msg, log_level, _)
   if msg:match("exit code") then return end
   if log_level == vim.log.levels.ERROR then
       vim.api.nvim_err_writeln(msg)
   else
   vim.api.nvim_echo({{msg}}, true, {})
   end
end
