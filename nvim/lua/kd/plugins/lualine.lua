-- require("plenary.reload").reload_module("lualine", true)

local theme = {
  command = { a = { bg = "#14ce14", fg = "#ffffff" }, b = { bg = "#f6f8fa", fg = "#bc05bc" } },
  inactive = {
    a = { bg = "#bc05bc", fg = "#ffffff" },
    b = { bg = "#f6f8fa", fg = "#0451a5" },
    c = { bg = "#f6f8fa", fg = "#586069" },
  },
  insert = { a = { bg = "#14ce14", fg = "#ffffff" }, b = { bg = "#f6f8fa", fg = "#14ce14" } },
  normal = {
    a = { bg = "#bc05bc", fg = "#ffffff", gui = "bold" },
    b = { bg = "#f6f8fa", fg = "#0451a5" },
    c = { bg = "#ffffff", fg = "#586069" },
  },
  replace = { a = { bg = "#d03d3d", fg = "#ffffff" }, b = { bg = "#f6f8fa", fg = "#d03d3d" } },
  visual = { a = { bg = "#949800", fg = "#ffffff" }, b = { bg = "#f6f8fa", fg = "#949800" } },
}

function git_root()
  local original_current_dir = vim.fn.expand("%:p:h")
  local current_dir = original_current_dir
  while true do
    if vim.fn.globpath(current_dir, ".git", 1) ~= "" then
      return vim.fn.fnamemodify(current_dir, ":t")
    end
    local temp_dir = current_dir
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
    if temp_dir == current_dir then
      break
    end
  end
  return original_current_dir
end

local function VistaNearestMethodOrFunction()
  return vim.b.vista_nearest_method_or_function or ""
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

local sections = {
  lualine_a = { { "filename", path = 1 } },
  lualine_b = { "branch" },
  lualine_c = { VistaNearestMethodOrFunction },
  lualine_x = {
    require("lsp-status").status_progress,
    { "diagnostics", sources = { "nvim_lsp" } },
    "encoding",
    "fileformat",
    "filetype",
  },
  lualine_y = { "progress" },
  lualine_z = { "location", Mode.update_status },
}

-- local tabline = require 'tabline'

require("plenary.reload").reload_module("lualine", true)
require("lualine").setup({
  extensions = { "fzf", "fugitive", "quickfix" },
  options = { theme = theme },
  -- tabline = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = { require'tabline'.tabline_buffers },
  --   lualine_x = { require'tabline'.tabline_tabs },
  --   lualine_y = {},
  --   lualine_z = {},
  -- },
  sections = vim.deepcopy(sections),
  inactive_sections = {
    lualine_a = {},
    lualine_b = { git_root, { "filename", path = 1 } },
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "location", "mode" },
    lualine_z = {},
  },
})
