local get_git_directory = require("kd/utils").get_git_directory
local utils = require("kd/utils")

local function git_root()
  local git_dir = utils.strip_trailing_slash(vim.fn.fnamemodify(get_git_directory(), ":p"))
  local cur_dir = utils.strip_trailing_slash(vim.fn.fnamemodify(vim.loop.cwd(), ":p"))
  local dir = git_dir
  if #cur_dir >= #git_dir then
    dir = cur_dir
  end
  local parent = vim.fn.fnamemodify(git_dir, ":h") .. "/"
  dir = utils.strip_trailing_slash(dir:gsub(parent, ""))
  return dir
end

local Mode = require("lualine.component"):new()
local get_mode = require("lualine.utils.mode").get_mode

Mode.update_status = function()
  local m = vim.fn.complete_info().mode
  local t = {
    keyword = "Keyword",
    ctrl_x = "CTRL-X",
    whole_line = "Whole Lines",
    files = "File Names",
    tags = "Tags",
    path_defines = "Definition Completion",
    path_patterns = "Include Completion",
    dictionary = "Dictionary",
    thesaurus = "Thesaurus",
    cmdline = "Vim Command",
    omni = "Omni completion",
    spell = "Spelling suggestions",
    eval = "Complete Completion",
    unknown = get_mode(),
  }
  t["function"] = "User Defined Completion"

  if t[m] == nil then
    return get_mode()
  else
    return t[m]
  end
end

local function ZoomToggleStatus()
  return vim.fn["zoom#statusline"]()
end

local function HighlightSearchStatus()
  if vim.v.hlsearch == 0 then
    return ""
  end
  local result = vim.fn.searchcount({ recompute = 1 })
  if vim.fn.empty(result) == 1 or result.total == 0 then
    return ""
  elseif result.incomplete == 1 then
    return vim.fn.getreg("/") .. " [? // ??]"
  elseif result.incomplete == 2 then
    if result.total > result.maxcount and result.current > result.maxcount then
      return vim.fn.getreg("/") .. " [" .. result.current .. "/" .. result.total .. "]"
    elseif result.total > result.maxcount then
      return vim.fn.getreg("/") .. " [" .. result.current .. "/" .. result.total .. "]"
    end
  end
  return vim.fn.getreg("/") .. " [" .. result.current .. "/" .. result.total .. "]"
end

require("lualine").setup({
  extensions = { "fzf", "fugitive", "quickfix" },
  options = { theme = "auto", globalstatus = true },
  tabline = {
    lualine_a = {
      "buffers",
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "tabs" },
  },
  sections = {
    lualine_a = { git_root },
    lualine_b = {
      { "branch", icon = "" },
      { "diff", symbols = { added = "", modified = "", removed = "" } },
    },
    lualine_c = {
      function()
        return " "
      end,
    },
    lualine_x = {
      function()
        return " "
      end,
      { "diagnostics", sources = { "nvim_diagnostic", "coc" } },
      require("lsp-status").status_progress,
    },
    lualine_y = { "progress", "location", "encoding", "fileformat", "filetype" },
    lualine_z = {
      ZoomToggleStatus,
      HighlightSearchStatus,
      Mode.update_status,
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { git_root, { "filename", path = 1 } },
    lualine_c = {
      function()
        return " "
      end,
    },
    lualine_x = {
      function()
        return " "
      end,
    },
    lualine_y = { "filetype", "progress", "mode" },
    lualine_z = {},
  },
})
