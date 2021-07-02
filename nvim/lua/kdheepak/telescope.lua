local M = {}

M.search_dotfiles = function()
  require('telescope.builtin').find_files({ prompt_title = '< dotfiles >', cwd = '$HOME/gitrepos/dotfiles' })
end

M.search_vimconfig = function()
  require('telescope.builtin').find_files({ prompt_title = '< dotfiles >', cwd = '$HOME/gitrepos/dotfiles/nvim' })
end

return M
