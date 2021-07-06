local M = {}

M.search_dotfiles = function()
  require('telescope.builtin').find_files({ prompt_title = '< dotfiles >', cwd = '$HOME/gitrepos/dotfiles' })
end

M.search_vimconfig = function()
  require('telescope.builtin').find_files({ prompt_title = '< dotfiles >', cwd = '$HOME/gitrepos/dotfiles/nvim' })
end

require('telescope').load_extension('fzy_native')
require('telescope').load_extension('gh')
require('telescope').load_extension('lsp_handlers')
require('telescope').load_extension('openbrowser')
require('telescope').load_extension('dap')

return M
