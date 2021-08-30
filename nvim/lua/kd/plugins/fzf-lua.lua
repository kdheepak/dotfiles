local nnoremap = require("kd/utils").nnoremap
local action = require("fzf.actions").action
local core = require("fzf-lua.core")
local grep = require("fzf-lua.providers.grep").grep
local utils = require("fzf-lua.utils")
local config = require("fzf-lua.config")
local actions = require("fzf-lua.actions")
local Config = require("todo-comments.config")
local Highlight = require("todo-comments.highlight")

local function todo(opts)
  if not opts then
    opts = {}
  end
  opts.search = [[(WARN|FIX|PERFORMANCE|OPTIMIZE|NOTE|BUG|FIXIT|ISSUE|TODO|OPTIM|HACK|PERF|FIXME|WARNING|XXX|INFO):]]
  return grep(opts)
end

nnoremap("<leader>fT", todo)
