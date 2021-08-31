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
local path = require("fzf-lua.path")
local utils = require("fzf-lua.utils")
local config = require("fzf-lua.config")
local actions = require("fzf-lua.actions")

local get_grep_cmd = function(opts)
  local command = nil
  if opts.cmd and #opts.cmd > 0 then
    command = opts.cmd
  elseif vim.fn.executable("rg") == 1 then
    command = string.format("rg %s %s", opts.rg_opts, table.concat(Config.options.search.args, " "))
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

local get_git_indicator = function(file, diff_files, untracked_files)
  -- remove colors from `rg` output
  file = file:gsub("%[%d+m", "")
  if diff_files and diff_files[file] then
    return diff_files[file]
  end
  if untracked_files and untracked_files[file] then
    return untracked_files[file]
  end
  return utils.nbsp
end

local make_entry_file = function(opts, x)
  local icon
  local prefix = ""
  local start, finish, kw = Highlight.match(x)
  P(start, finish, kw)
  if opts.cwd_only and path.starts_with_separator(x) then
    local cwd = opts.cwd or vim.loop.cwd()
    if not path.is_relative(x, cwd) then
      return nil
    end
  end
  if opts.cwd and #opts.cwd > 0 then
    x = path.relative(x, opts.cwd)
  end
  if opts.file_icons then
    local ext = path.extension(x)
    icon = core.get_devicon(x, ext)
    if opts.color_icons then
      icon = utils.ansi_codes[config.globals.file_icon_colors[ext] or "dark_grey"](icon)
    end
    prefix = prefix .. icon
  end
  if opts.git_icons then
    local filepath = x:match("^[^:]+")
    local indicator = get_git_indicator(filepath, opts.diff_files, opts.untracked_files)
    icon = indicator
    if config.globals.git.icons[indicator] then
      icon = config.globals.git.icons[indicator].icon
      if opts.color_icons then
        icon = utils.ansi_codes[config.globals.git.icons[indicator].color or "dark_grey"](icon)
      end
    end
    prefix = prefix .. utils._if(#prefix > 0, utils.nbsp, "") .. icon
  end
  if #prefix > 0 then
    x = prefix .. utils.nbsp .. x
  end
  return x
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
  opts.fzf_cli_args = string.format([[%s --header="Find Todo"]], opts.fzf_cli_args)

  opts = config.normalize_opts(opts, config.globals.grep)

  if opts.continue_last_search or opts.repeat_last_search then
    opts.search = config._grep_last_search
  end

  -- if user did not provide a search term
  -- provide an input prompt
  if not opts.search or #opts.search == 0 then
    opts.search = vim.fn.input(opts.input_prompt)
  end

  if not opts.search or #opts.search == 0 then
    utils.info("Please provide a valid search string")
    return
  end

  -- save the search query so the use can
  -- call the same search again
  config._grep_last_search = opts.search

  local command = opts.raw_cmd

  opts.fzf_fn = fzf_helpers.cmd_line_transformer(command, function(x)
    return make_entry_file(opts, x)
  end)

  --[[ opts.cb_selected = function(_, x)
    return x
  end ]]

  opts = core.set_fzf_line_args(opts)
  core.fzf_files(opts)
  opts.search = nil
end

nnoremap("<leader>fT", todo, { silent = true })
