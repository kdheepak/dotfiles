local colors = {
  black = '#011627',
  darkgray = '#081e2f',
  brightwhite = '#D0D0D0',
  white = '#6C6F93',
  red = '#F43E5C',
  green = '#09F7A0',
  blue = '#25B2BC',
  yellow = '#F09383',
  gray = '#E95678',
  -- darkgray = '#1A1C23',
  lightgray = '#2E303E',
  inactivegray = '#1C1E26',
  darkblue = '#092236',
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
    a = { bg = colors.black, fg = colors.brightwhite, gui = 'bold' },
    b = { bg = colors.black, fg = colors.brightwhite },
    c = { bg = colors.black, fg = colors.brightwhite },
  },
}

require'lualine'.setup {
  extensions = { 'fzf', 'nvim-tree', 'fugitive' },
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
