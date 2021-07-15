require('plenary.reload').reload_module('lualine', true)
local colors = require 'monochrome.colors'
colors.bg = '#011627'
local theme = {
  normal = {
    a = { fg = colors.black, bg = colors.neutral_green, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  insert = {
    a = { fg = colors.black, bg = colors.faded_blue, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  visual = {
    a = { fg = colors.black, bg = colors.faded_yellow, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  replace = {
    a = { fg = colors.black, bg = colors.faded_red, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  command = {
    a = { fg = colors.black, bg = colors.faded_aqua, gui = 'bold' },
    b = { fg = colors.fg, bg = colors.gray1 },
    c = { fg = colors.fg, bg = colors.bg },
  },
  inactive = {
    a = { fg = colors.white, bg = colors.fg, gui = 'bold' },
    b = { fg = colors.white, bg = colors.gray1 },
    c = { fg = colors.white, bg = colors.bg },
  },
}

require'lualine'.setup {
  extensions = { 'fzf', 'nvim-tree', 'fugitive' },
  options = { theme = theme },
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
  inactive_sections = { a = {}, b = {}, c = { 'filename' }, x = { 'location' }, y = {}, z = {} },
}
