require('plenary.reload').reload_module('lualine', true)
-- local colors = require 'monochrome.colors'
-- colors.bg = '#011627'
-- local theme = {
--   normal = {
--     a = { fg = colors.black, bg = colors.neutral_green, gui = 'bold' },
--     b = { fg = colors.fg, bg = colors.gray1 },
--     c = { fg = colors.fg, bg = colors.bg },
--   },
--   insert = {
--     a = { fg = colors.black, bg = colors.faded_blue, gui = 'bold' },
--     b = { fg = colors.fg, bg = colors.gray1 },
--     c = { fg = colors.fg, bg = colors.bg },
--   },
--   visual = {
--     a = { fg = colors.black, bg = colors.faded_yellow, gui = 'bold' },
--     b = { fg = colors.fg, bg = colors.gray1 },
--     c = { fg = colors.fg, bg = colors.bg },
--   },
--   replace = {
--     a = { fg = colors.black, bg = colors.faded_red, gui = 'bold' },
--     b = { fg = colors.fg, bg = colors.gray1 },
--     c = { fg = colors.fg, bg = colors.bg },
--   },
--   command = {
--     a = { fg = colors.black, bg = colors.faded_aqua, gui = 'bold' },
--     b = { fg = colors.fg, bg = colors.gray1 },
--     c = { fg = colors.fg, bg = colors.bg },
--   },
--   inactive = {
--     a = { fg = colors.white, bg = colors.fg, gui = 'bold' },
--     b = { fg = colors.white, bg = colors.gray1 },
--     c = { fg = colors.white, bg = colors.bg },
--   },
-- }

local theme = {
  command = { a = { bg = '#14ce14', fg = '#ffffff' }, b = { bg = '#f6f8fa', fg = '#bc05bc' } },
  inactive = {
    a = { bg = '#0451a5', fg = '#14ce14' },
    b = { bg = '#0451a5', fg = '#f6f8fa', gui = 'bold' },
    c = { bg = '#0451a5', fg = '#f6f8fa' },
  },
  insert = { a = { bg = '#14ce14', fg = '#ffffff' }, b = { bg = '#f6f8fa', fg = '#14ce14' } },
  normal = {
    a = { bg = '#bc05bc', fg = '#ffffff' },
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

require'lualine'.setup {
  extensions = { 'fzf', 'nvim-tree', 'fugitive', 'quickfix' },
  options = { theme = theme },
  tabline = {
    lualine_a = { git_root },
    lualine_b = { 'filename' },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = {
      { 'filename', file_status = true, path = 1 }, {
        'diff',
        colored = true, -- displays diff status in color if set to true
        -- all colors are in format #rrggbb
        color_added = nil, -- changes diff's added foreground color
        color_modified = nil, -- changes diff's modified foreground color
        color_removed = nil, -- changes diff's removed foreground color
        symbols = { added = '+', modified = '~', removed = '-' }, -- changes diff symbols
      },
    },
    lualine_x = {
      require('lsp-status').status_progress, { 'diagnostics', sources = { 'nvim_lsp' } }, 'encoding', 'fileformat',
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = { a = {}, b = {}, c = { 'filename' }, x = { 'location' }, y = {}, z = {} },
}
