execute = vim.api.nvim_command
fn = vim.fn
cmd = vim.cmd
lsp = vim.lsp
api = vim.api

require('plugins')

require('options')

require('keymappings')

require('autocommands')

require('vim')

require('config')

vim.notify = function (msg, log_level, _opts)
   if msg:match("exit code") then return end
   if log_level == vim.log.levels.ERROR then
       vim.api.nvim_err_writeln(msg)
   else
   vim.api.nvim_echo({{msg}}, true, {})
   end
end
