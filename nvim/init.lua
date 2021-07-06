-- For debugging purpose
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

require 'kdheepak/plugins'
require 'kdheepak/settings'
require 'kdheepak/config'
require 'kdheepak/autocommands'
require 'kdheepak/keymappings'
require 'kdheepak/which-key'
require 'kdheepak/telescope'
require 'kdheepak/lspconfig'
require 'kdheepak/compe'
require 'kdheepak/debug'

vim.notify = function(msg, log_level, _)
  if msg:match('exit code') then
    return
  end
  if log_level == vim.log.levels.ERROR then
    vim.api.nvim_err_writeln(msg)
  else
    vim.api.nvim_echo({ { msg } }, true, {})
  end
end
