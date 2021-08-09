require('plenary.reload').reload_module('lualine', true)

local theme = {
  command = { a = { bg = '#14ce14', fg = '#ffffff' }, b = { bg = '#f6f8fa', fg = '#bc05bc' } },
  inactive = {
    a = { bg = '#bc05bc', fg = '#ffffff' },
    b = { bg = '#f6f8fa', fg = '#0451a5' },
    c = { bg = '#f6f8fa', fg = '#586069' },
  },
  insert = { a = { bg = '#14ce14', fg = '#ffffff' }, b = { bg = '#f6f8fa', fg = '#14ce14' } },
  normal = {
    a = { bg = '#bc05bc', fg = '#ffffff', gui = 'bold' },
    b = { bg = '#f6f8fa', fg = '#0451a5' },
    c = { bg = '#ffffff', fg = '#586069' },
  },
  replace = { a = { bg = '#d03d3d', fg = '#ffffff' }, b = { bg = '#f6f8fa', fg = '#d03d3d' } },
  visual = { a = { bg = '#949800', fg = '#ffffff' }, b = { bg = '#f6f8fa', fg = '#949800' } },
}

function git_root()
  local original_current_dir = vim.fn.expand('%:p:h')
  local current_dir = original_current_dir
  while true do
    if vim.fn.globpath(current_dir, '.git', 1) ~= '' then
      return vim.fn.fnamemodify(current_dir, ':t')
    end
    local temp_dir = current_dir
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
    if temp_dir == current_dir then
      break
    end
  end
  return original_current_dir
end

local sections = {
  lualine_a = { { 'filename', path = 1 } },
  lualine_b = { 'branch' },
  lualine_c = {},
  lualine_x = {
    require('lsp-status').status_progress, { 'diagnostics', sources = { 'nvim_lsp' } }, 'encoding', 'fileformat',
    'filetype',
  },
  lualine_y = { 'progress' },
  lualine_z = { 'location', 'mode' },
}

-- local tabline = require 'tabline'

require'lualine'.setup {
  extensions = { 'fzf', 'nvim-tree', 'fugitive', 'quickfix' },
  options = { theme = theme },
  tabline = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { require'tabline'.tabline_buffers },
    lualine_x = { require'tabline'.tabline_tabs },
    lualine_y = {},
    lualine_z = {},
  },
  sections = vim.deepcopy(sections),
  inactive_sections = {
    lualine_a = {},
    lualine_b = { git_root, { 'filename', path = 1 } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'location', 'mode' },
    lualine_z = {},
  },
}
