require('plenary.reload').reload_module('lualine', true)
require'lualine'.setup {
  extensions = { 'fzf', 'nvim-tree', 'fugitive' },
  options = { theme = 'monochrome' },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', file_status = true, full_path = true } },
    lualine_x = {
      require('lsp-status').status_progress, { 'diagnostics', sources = { 'nvim_lsp' } }, 'encoding', 'fileformat',
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
}
