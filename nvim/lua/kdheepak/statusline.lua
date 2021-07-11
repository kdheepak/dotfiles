-- Copyright (c) 2021 Jnhtr
-- MIT license, see LICENSE for more details.
-- LuaFormatter off
local colors = {
  black = '#1c1e26',
  brightwhite = '#D0D0D0',
  white = '#6C6F93',
  red = '#F43E5C',
  green = '#09F7A0',
  blue = '#25B2BC',
  yellow = '#F09383',
  gray = '#E95678',
  darkgray = '#1A1C23',
  lightgray = '#2E303E',
  inactivegray = '#1C1E26',
}
-- LuaFormatter on
local theme = {
  normal = {
    a = { bg = colors.gray, fg = colors.black, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.brightwhite },
    c = { bg = colors.darkgray, fg = colors.white },
  },
  insert = {
    a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.brightwhite },
    c = { bg = colors.darkgray, fg = colors.white },
  },
  visual = {
    a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.brightwhite },
    c = { bg = colors.darkgray, fg = colors.white },
  },
  replace = {
    a = { bg = colors.red, fg = colors.black, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.brightwhite },
    c = { bg = colors.darkgray, fg = colors.white },
  },
  command = {
    a = { bg = colors.green, fg = colors.black, gui = 'bold' },
    b = { bg = colors.lightgray, fg = colors.brightwhite },
    c = { bg = colors.darkgray, fg = colors.white },
  },
  inactive = {
    a = { bg = colors.inactivegray, fg = colors.lightgray, gui = 'bold' },
    b = { bg = colors.inactivegray, fg = colors.brightwhite },
    c = { bg = colors.inactivegray, fg = colors.lightgray },
  },
}

require'lualine'.setup {
  options = { theme = theme },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', file_status = true, full_path = true }, require('lsp-status').status_progress },
    lualine_x = { { 'diagnostics', sources = { 'nvim_lsp' } }, 'encoding', 'fileformat', 'filetype' },
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
