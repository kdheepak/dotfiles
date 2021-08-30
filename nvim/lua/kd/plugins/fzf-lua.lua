local nnoremap = require("kd/utils").nnoremap
local action = require("fzf.actions").action
local core = require("fzf-lua.core")
local utils = require("fzf-lua.utils")
local config = require("fzf-lua.config")
local actions = require("fzf-lua.actions")
local Config = require("todo-comments.config")
local Highlight = require("todo-comments.highlight")
local fzf_helpers = require("fzf.helpers")

local get_grep_cmd = function(opts, search_query, no_esc)
  if opts.raw_cmd and #opts.raw_cmd > 0 then
    return opts.raw_cmd
  end
  local command = nil
  if opts.cmd and #opts.cmd > 0 then
    command = opts.cmd
  elseif vim.fn.executable("rg") == 1 then
    command = string.format("rg %s", opts.rg_opts)
  else
    command = string.format("grep %s", opts.grep_opts)
  end

  -- filename takes precedence over directory
  -- filespec takes precedence over all and doesn't shellescape
  -- this is so user can send a file populating command instead
  local search_path = ""
  if opts.filespec and #opts.filespec > 0 then
    search_path = opts.filespec
  elseif opts.filename and #opts.filename > 0 then
    search_path = vim.fn.shellescape(opts.filename)
  elseif opts.cwd and #opts.cwd > 0 then
    search_path = vim.fn.shellescape(opts.cwd)
  end

  if search_query == nil then
    search_query = ""
  elseif not no_esc then
    search_query = '"' .. utils.rg_escape(search_query) .. '"'
  end

  return string.format("%s %s %s", command, search_query, search_path)
end

local grep = function(opts)
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

  local command = get_grep_cmd(opts, opts.search, true)

  opts.fzf_fn = fzf_helpers.cmd_line_transformer(command, function(x)
    return core.make_entry_file(opts, x)
  end)

  --[[ opts.cb_selected = function(_, x)
    return x
  end ]]

  opts = core.set_fzf_line_args(opts)
  core.fzf_files(opts)
  opts.search = nil
end

local function todo(opts)
  if not opts then
    opts = {}
  end
  -- TODO: search better syntax highlighting for todo comments
  opts.search = '"' .. Config.search_regex .. '"'
  return grep(opts)
end

nnoremap("<leader>fT", todo, { silent = true })
