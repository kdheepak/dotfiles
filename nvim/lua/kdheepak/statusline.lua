local gl = require 'galaxyline'
local gls = gl.section
local devicons = require 'nvim-web-devicons'
local vcs = require 'galaxyline.provider_vcs'
local lspclient = require 'galaxyline.provider_lsp'
local condition = require 'galaxyline.condition'

icons = {
  dos = '', -- e70f
  unix = '', -- f17c
  mac = '', -- f179
  paste = '', -- f691
  circle = '', -- f62e
  git = '', -- f7a1
  branch = '', -- f418
  added = '', -- f457
  removed = '', -- f458
  modified = '', -- f459
  locker = '', -- f023
  not_modifiable = '', -- f05e
  unsaved = '', -- f0c7
  pencil = '', -- f040
  page = '☰', -- 2630
  line_number = '', -- e0a1
  connected = '', -- f817
  disconnected = '', -- f818
  gears = '', -- f085
  poop = '💩', -- 1f4a9
  ok = '', -- f058
  error = '', -- f658
  warning = '', -- f06a
  info = '', -- f05a
  -- hint = "", -- f834
  hint = '', -- f059
}

-- Gruvbox
colors = {
  bg0_h = '#1d2021',
  bg0 = '#282828',
  bg1 = '#3c3836',
  bg2 = '#504945',
  bg3 = '#665c54',
  bg4 = '#7c6f64',
  gray = '#928374',
  fg0 = '#fbf1c7',
  fg1 = '#ebdbb2',
  fg2 = '#d5c4a1',
  fg3 = '#bdae93',
  fg4 = '#a89984',
  bright_red = '#fb4934',
  bright_green = '#b8bb26',
  bright_yellow = '#fabd2f',
  bright_blue = '#83a598',
  bright_purple = '#d3869b',
  bright_aqua = '#8ec07c',
  bright_orange = '#fe8019',
  neutral_red = '#cc241d',
  neutral_green = '#98971a',
  neutral_yellow = '#d79921',
  neutral_blue = '#458588',
  neutral_purple = '#b16286',
  neutral_aqua = '#689d6a',
  neutral_orange = '#d65d0e',
  faded_red = '#9d0006',
  faded_green = '#79740e',
  faded_yellow = '#b57614',
  faded_blue = '#076678',
  faded_purple = '#8f3f71',
  faded_aqua = '#427b58',
  faded_orange = '#af3a03',
}

gl.short_line_list = { 'vim-plug', 'tagbar', 'Mundo', 'MundoDiff', 'coc-explorer', 'startify', 'packer', 'Outline' }

local mode_map = {
  ['n'] = { 'NORMAL', colors.fg3, colors.bg2 },
  -- ["n"] = {"NORMAL", colors.bright_green, colors.faded_green},
  ['i'] = { 'INSERT', colors.bright_blue, colors.faded_blue },
  ['R'] = { 'REPLACE', colors.bright_red, colors.faded_red },
  ['v'] = { 'VISUAL', colors.bright_orange, colors.faded_orange },
  ['V'] = { 'V-LINE', colors.bright_orange, colors.faded_orange },
  ['c'] = { 'COMMAND', colors.bright_yellow, colors.faded_yellow },
  ['s'] = { 'SELECT', colors.bright_orange, colors.faded_orange },
  ['S'] = { 'S-LINE', colors.bright_orange, colors.faded_orange },
  ['t'] = { 'TERMINAL', colors.bright_aqua, colors.faded_aqua },
  [''] = { 'V-BLOCK', colors.bright_orange, colors.faded_orange },
  [''] = { 'S-BLOCK', colors.bright_orange, colors.faded_orange },
  ['Rv'] = { 'VIRTUAL' },
  ['rm'] = { '--MORE' },
}

-- local mode_sign_map = {
--   ["n"] = {"", colors.fg3, colors.bg2},
--   ["i"] = {"", colors.bright_blue, colors.faded_blue},
--   ["R"] = {"", colors.bright_red, colors.faded_red},
--   ["v"] = {"", colors.bright_orange, colors.faded_orange},
--   ["V"] = {"", colors.bright_orange, colors.faded_orange},
--   ["c"] = {"ﲵ", colors.bright_yellow, colors.faded_yellow},
--   ["s"] = {"", colors.bright_orange, colors.faded_orange},
--   ["S"] = {"", colors.bright_orange, colors.faded_orange},
--   ["t"] = {"", colors.bright_aqua, colors.faded_aqua},
--   [""] = {"", colors.bright_orange, colors.faded_orange},
--   [""] = {"", colors.bright_orange, colors.faded_orange},
--   ["rm"] = {""}
-- }

local sep = {
  -- right_filled = "", -- e0b6
  -- left_filled = "", -- e0b4
  -- right_filled = ' ', -- e0ca
  -- left_filled = ' ', -- e0c8
  right_filled = '', -- e0b2
  left_filled = '', -- e0b0
  right = '', -- e0b3
  left = '', -- e0b1
  -- right = "", -- e0b7
  -- left = "", -- e0b5
  -- right = '', -- e621
  -- left = '', -- e621
}

local function mode_hl()
  local mode = mode_map[vim.fn.mode()]
  if mode == nil then
    mode = mode_map['v']
    return { 'V-BLOCK', mode[2], mode[3] }
  end
  return mode
end

local function highlight(group, fg, bg, gui)
  local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)
  if gui ~= nil then
    cmd = cmd .. ' gui=' .. gui
  end
  vim.cmd(cmd)
end

local function buffer_not_empty()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local function diagnostic_exists()
  return not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
end

local function diag(severity)
  local n = vim.lsp.diagnostic.get_count(0, severity)
  if n == 0 then
    return ''
  end
  local diag_mapping = {
    ['Warning'] = icons.warning,
    ['Error'] = icons.error,
    ['Information'] = icons.info,
    ['Hint'] = icons.hint,
  }
  return string.format(' %s %d ', diag_mapping[severity], n)
end

local function wide_enough(width)
  if vim.fn.winwidth(0) > width then
    return true
  end
  return false
end

gls.left[1] = {
  ViMode = {
    provider = function()
      local label, fg, nested_fg = unpack(mode_hl())
      highlight('GalaxyViMode', nested_fg, fg)
      highlight('GalaxyViModeInv', fg, nested_fg)
      highlight('GalaxyViModeNested', fg, nested_fg)
      highlight('GalaxyViModeInvNested', nested_fg, colors.bg1)
      local mode = '   ' .. label .. ' '
      if vim.o.paste then
        mode = mode .. sep.left .. ' ' .. icons.paste .. ' Paste '
      end
      return mode
    end,
    separator = sep.left_filled,
    separator_highlight = 'GalaxyViModeInv',
  },
}
gls.left[2] = {
  FileIcon = {
    provider = function()
      local extention = vim.fn.expand('%:e')
      local icon, iconhl = devicons.get_icon(extention)
      if icon == nil then
        return ''
      end

      local fg = vim.fn.synIDattr(vim.fn.hlID(iconhl), 'fg')
      local _, _, bg = unpack(mode_hl())
      highlight('GalaxyFileIcon', fg, bg)

      return ' ' .. icon .. ' '
    end,
    condition = buffer_not_empty,
  },
}
gls.left[3] = {
  FileName = {
    provider = function()
      if vim.bo.buftype == 'terminal' then
        return ''
      end
      if not buffer_not_empty() then
        return ''
      end

      local fname
      if wide_enough(120) then
        fname = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
        if #fname > 35 then
          fname = vim.fn.expand '%:t'
        end
      else
        fname = vim.fn.expand '%:t'
      end
      if #fname == 0 then
        return ''
      end

      if vim.bo.readonly then
        fname = fname .. ' ' .. icons.locker
      end
      if not vim.bo.modifiable then
        fname = fname .. ' ' .. icons.not_modifiable
      end
      if vim.bo.modified then
        fname = fname .. ' ' .. icons.pencil
      end

      return ' ' .. fname .. ' '
    end,
    highlight = 'GalaxyViModeNested',
    condition = buffer_not_empty,
  },
}
gls.left[4] = {
  LeftSep = {
    provider = function()
      return sep.left_filled
    end,
    highlight = 'GalaxyViModeInvNested',
  },
}
gls.left[5] = {
  GitIcon = {
    provider = function()
      highlight('DiffAdd', colors.bright_green, colors.bg1)
      highlight('DiffChange', colors.bright_orange, colors.bg1)
      highlight('DiffDelete', colors.bright_red, colors.bg1)

      local branch = vcs.get_git_branch()

      if wide_enough(85) and branch ~= nil then
        return '  ' .. icons.git .. ' '
      end

      return ''
    end,
    highlight = { colors.bright_red, colors.bg1 },
  },
}
gls.left[6] = {
  GitBranch = {
    provider = function()
      local branch = vcs.get_git_branch()

      if wide_enough(85) and branch ~= nil then
        return branch .. ' '
      end

      return ''
    end,
    highlight = { colors.fg2, colors.bg1 },
  },
}
gls.left[7] = {
  DiffAdd = {
    provider = function()
      if condition.check_git_workspace() and wide_enough(100) then
        return vcs.diff_add()
      end
      return ''
    end,
    icon = icons.added .. ' ',
    highlight = { colors.bright_green, colors.bg1 },
  },
}
gls.left[8] = {
  DiffModified = {
    provider = function()
      if condition.check_git_workspace() and wide_enough(100) then
        return vcs.diff_modified()
      end
      return ''
    end,
    icon = icons.modified .. ' ',
    highlight = { colors.bright_orange, colors.bg1 },
  },
}
gls.left[9] = {
  DiffRemove = {
    provider = function()
      if condition.check_git_workspace() and wide_enough(100) then
        return vcs.diff_remove()
      end
      return ''
    end,
    icon = icons.removed .. ' ',
    highlight = { colors.bright_red, colors.bg1 },
  },
}

gls.right[1] = {
  LspIcon = {
    provider = function()
      if diagnostic_exists() then
        return icons.gears .. ' '
      end
    end,
    highlight = { colors.bright_purple, colors.bg1 },
  },
}
gls.right[2] = {
  LspServer = {
    provider = function()
      if diagnostic_exists() then
        local client = lspclient.get_lsp_client()
        local client_short = string.match(client, '(.-)_.*')
        if client_short then
          return client_short .. ' '
        end
        return client .. ' '
      end
    end,
    highlight = { colors.fg4, colors.bg1 },
  },
}
gls.right[3] = {
  DiagnosticOk = {
    provider = function()
      if not diagnostic_exists() then
        return ''
      end
      local w = vim.lsp.diagnostic.get_count(0, 'Warning')
      local e = vim.lsp.diagnostic.get_count(0, 'Error')
      local i = vim.lsp.diagnostic.get_count(0, 'Information')
      local h = vim.lsp.diagnostic.get_count(0, 'Hint')
      if w ~= 0 or e ~= 0 or i ~= 0 or h ~= 0 then
        return ''
      end
      return icons.ok .. ' '
    end,
    highlight = { colors.bright_green, colors.bg1 },
  },
}
gls.right[4] = {
  DiagnosticError = {
    provider = function()
      return diag('Error')
    end,
    highlight = { colors.bright_red, colors.bg1 },
  },
}
gls.right[5] = {
  DiagnosticWarn = {
    provider = function()
      return diag('Warning')
    end,
    highlight = { colors.bright_yellow, colors.bg1 },
  },
}
gls.right[6] = {
  DiagnosticInfo = {
    provider = function()
      return diag('Information')
    end,
    highlight = { colors.bright_blue, colors.bg1 },
  },
}
gls.right[7] = {
  DiagnosticHint = {
    provider = function()
      return diag('Hint')
    end,
    highlight = { colors.bright_aqua, colors.bg1 },
  },
}
gls.right[8] = {
  RightSepNested = {
    provider = function()
      return sep.right_filled
    end,
    highlight = 'GalaxyViModeInvNested',
  },
}
gls.right[9] = {
  FileFormat = {
    provider = function()
      if not buffer_not_empty() or not wide_enough(70) then
        return ''
      end
      local icon = icons[vim.bo.fileformat] or ''
      return string.format('  %s %s ', icon, vim.bo.fileencoding)
    end,
    highlight = 'GalaxyViModeNested',
  },
}
gls.right[10] = {
  RightSep = {
    provider = function()
      return sep.right_filled
    end,
    highlight = 'GalaxyViModeInv',
  },
}
gls.right[11] = {
  PositionInfo = {
    provider = function()
      if not buffer_not_empty() or not wide_enough(60) then
        return ''
      end
      return string.format('  %s %s:%s ', icons.line_number, vim.fn.line('.'), vim.fn.col('.'))
    end,
    highlight = 'GalaxyViMode',
  },
}
gls.right[12] = {
  PercentInfo = {
    provider = function()
      if not buffer_not_empty() or not wide_enough(65) then
        return ''
      end
      local percent = math.floor(100 * vim.fn.line('.') / vim.fn.line('$'))
      return string.format(' %s %s%s', icons.page, percent, '% ')
    end,
    highlight = 'GalaxyViMode',
    separator = sep.right,
    separator_highlight = 'GalaxyViMode',
  },
}

local short_map = {
  ['nvim-tree'] = 'Explorer',
  ['startify'] = 'Starfity',
  ['tagbar'] = 'Tagbar',
  ['packer'] = 'Packer',
  ['Outline'] = 'Outline',
  ['Mundo'] = 'History',
  ['MundoDiff'] = 'Diff',
}

local function has_file_type()
  local f_type = vim.bo.filetype
  if not f_type or f_type == '' then
    return false
  end
  return true
end

gls.short_line_left[1] = {
  BufferType = {
    provider = function()
      local _, fg, nested_fg = unpack(mode_hl())
      highlight('GalaxyViMode', nested_fg, fg)
      highlight('GalaxyViModeInv', fg, nested_fg)
      highlight('GalaxyViModeInvNested', nested_fg, colors.bg1)
      local name = short_map[vim.bo.filetype] or 'Editor'
      return string.format('  %s ', name)
    end,
    highlight = 'GalaxyViMode',
    condition = has_file_type,
    separator = sep.left_filled,
    separator_highlight = 'GalaxyViModeInv',
  },
}
gls.short_line_left[2] = {
  ShortLeftSepNested = {
    provider = function()
      return sep.left_filled
    end,
    highlight = 'GalaxyViModeInvNested',
  },
}
gls.short_line_right[1] = {
  ShortRightSepNested = {
    provider = function()
      return sep.right_filled
    end,
    highlight = 'GalaxyViModeInvNested',
  },
}
gls.short_line_right[2] = {
  ShortRightSep = {
    provider = function()
      return sep.right_filled
    end,
    highlight = 'GalaxyViModeInv',
  },
}
