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

local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    sorting_strategy = 'ascending',
    mappings = {
      n = {
        ['<esc>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
      i = {
        ['<esc>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
    },
  },
  extensions = { fzy_native = { override_generic_sorter = false, override_file_sorter = true } },
}

return M
