local nnoremap = require("kd/utils").nnoremap
local action = require("fzf.actions").action
local core = require("fzf-lua.core")
local utils = require("fzf-lua.utils")
local grep = require("fzf-lua.providers.grep").grep
local config = require("fzf-lua.config")
local actions = require("fzf-lua.actions")
local Config = require("todo-comments.config")
local Highlight = require("todo-comments.highlight")
local fzf_helpers = require("fzf.helpers")

local get_grep_cmd = function(opts)
  local command = nil
  if opts.cmd and #opts.cmd > 0 then
    command = opts.cmd
  elseif vim.fn.executable("rg") == 1 then
    command = string.format("rg %s", opts.rg_opts)
  else
    command = string.format("grep %s", opts.grep_opts)
  end

  local search_path = ""
  if opts.filespec and #opts.filespec > 0 then
    search_path = opts.filespec
  elseif opts.filename and #opts.filename > 0 then
    search_path = vim.fn.shellescape(opts.filename)
  elseif opts.cwd and #opts.cwd > 0 then
    search_path = vim.fn.shellescape(opts.cwd)
  end

  local search_query = '"' .. opts.search .. '"'

  return string.format("%s %s %s", command, search_query, search_path)
end

local function todo(opts)
  if not opts then
    opts = {}
  end
  opts = config.normalize_opts(opts, config.globals.grep)

  -- TODO: search better syntax highlighting for todo comments
  opts.search = Config.search_regex

  opts.raw_cmd = get_grep_cmd(opts)

  opts.no_header = true

  opts.fzf_cli_args = opts.fzf_cli_args or ""
  opts.fzf_cli_args = string.format([[%s --prompt="TodoComments>"]], opts.fzf_cli_args)

  return grep(opts)
end

nnoremap("<leader>fT", todo, { silent = true, label = "Todo comments" })
