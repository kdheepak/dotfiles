local success, impatient = pcall(require, "impatient")
-- if success then
--   require("impatient").enable_profile()
-- end

pcall(require, "packer_compiled")

require("kd/utils")

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
