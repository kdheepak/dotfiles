-- For debugging purpose

vim.cmd([[
runtime! plugin/rplugin.vim
]])

require("kd/utils")

-- Disable some unused built-in Neovim plugins
vim.g.loaded_man = false
vim.g.loaded_gzip = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false

vim.g.JuliaFormatter_always_launch_server = true

require("kd/plugins")

require("kd/config")

vim.cmd([[
function! g:Scriptnames_capture() abort
  try
    redir => out
    exe 'silent! scriptnames'
  finally
    redir END
  endtry
  call writefile(split(out, "\n", 1), glob('scriptnames.log'), 'b')
  return out
endfunction
]])
