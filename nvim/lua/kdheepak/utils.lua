local M = {}

local kdheepak = { g = {}, utils = M }

local function augroup(name, callback)
  vim.cmd("augroup " .. name)
  vim.cmd("autocmd!")
  callback()
  vim.cmd("augroup END")
end

local callback_index = 0

local config_prefix = vim.env.HOME .. "/.config/nvim/"

function M.get_key_for_fn(fn, storage)
  local info = debug.getinfo(fn)
  local key = info.short_src
  if vim.startswith(key, config_prefix) then
    key = key:sub(#config_prefix + 1)
  end
  if vim.endswith(key, ".lua") then -- and sure would be weird if it _didn't_
    key = key:sub(1, #key - 4)
  end
  key = key:gsub("%W", "_")
  key = key .. "_L" .. info.linedefined
  if storage[key] ~= nil then
    key = key .. "_" .. callback_index
    callback_index = callback_index + 1
  end
  return key
end

kdheepak.g.autocommand_callbacks = {}

-- Wrapper for simple autocmd use cases. `cmd` may be a string or a Lua function.
local function autocmd(name, pattern, cmd, opts)
  opts = opts or {}
  local cmd_type = type(cmd)
  if cmd_type == "function" then
    local key = M.get_key_for_fn(cmd, kdheepak.g.autocommand_callbacks)
    kdheepak.g.autocommand_callbacks[key] = cmd
    cmd = "lua kdheepak.g.autocommand_callbacks." .. key .. "()"
  elseif cmd_type ~= "string" then
    error("autocmd(): unsupported cmd type: " .. cmd_type)
  end
  local bang = opts.bang and "!" or ""
  vim.cmd("autocmd" .. bang .. " " .. name .. " " .. pattern .. " " .. cmd)
end

kdheepak.g.map_callbacks = {}

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  local rhs_type = type(rhs)
  local key
  if rhs_type == "function" then
    key = get_key_for_fn(rhs, kdheepak.g.map_callbacks)
    kdheepak.g.map_callbacks[key] = rhs
    rhs = "v:lua.kdheepak.g.map_callbacks." .. key .. "()"
  elseif rhs_type ~= "string" then
    error("map(): unsupported rhs type: " .. rhs_type)
  end
  local buffer = opts.buffer
  opts.buffer = nil
  if buffer == true then
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end

  return {
    dispose = function()
      if buffer == true then
        vim.api.nvim_buf_del_keymap(0, mode, lhs)
      else
        vim.api.nvim_del_keymap(mode, lhs)
      end
      kdheepak.g.map_callbacks[key] = nil
    end,
  }
end

local function cnoremap(lhs, rhs, opts)
  opts = opts or {}
  map("c", lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

local function inoremap(lhs, rhs, opts)
  opts = opts or {}
  map("i", lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

local function nnoremap(lhs, rhs, opts)
  opts = opts or {}
  map("n", lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

local function xnoremap(lhs, rhs, opts)
  opts = opts or {}
  map("x", lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

local function snoremap(lhs, rhs, opts)
  opts = opts or {}
  map("s", lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

local function noremap(lhs, rhs, opts)
  opts = opts or {}
  map("", lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

local function cmap(lhs, rhs, opts)
  opts = opts or {}
  map("c", lhs, rhs, opts)
end

local function imap(lhs, rhs, opts)
  opts = opts or {}
  map("i", lhs, rhs, opts)
end

local function nmap(lhs, rhs, opts)
  opts = opts or {}
  map("n", lhs, rhs, opts)
end

local function xmap(lhs, rhs, opts)
  opts = opts or {}
  map("x", lhs, rhs, opts)
end

local function smap(lhs, rhs, opts)
  opts = opts or {}
  map("s", lhs, rhs, opts)
end

kdheepak.g.command_callbacks = {}

local function command(name, repl, opts)
  opts = opts or {}
  local repl_type = type(repl)
  if repl_type == "function" then
    local key = get_key_for_fn(repl, kdheepak.g.command_callbacks)
    kdheepak.g.command_callbacks[key] = repl
    repl = "lua kdheepak.g.command_callbacks." .. key .. "()"
  elseif repl_type ~= "string" then
    error("command(): unsupported repl type: " .. repl_type)
  end
  local prefix = opts.force == false and "command" or "command!"
  if opts.bang then
    prefix = prefix .. " -bang"
  end
  if opts.complete then
    prefix = prefix .. " -complete=" .. opts.complete
  end
  if opts.nargs then
    prefix = prefix .. " -nargs=" .. opts.nargs
  end
  if opts.range then
    prefix = prefix .. " -range"
  end
  vim.cmd(prefix .. " " .. name .. " " .. repl)
end

local function T(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local options = {
  colorcolumn = { scope = "window", type = "string" },
  concealcursor = { scope = "window", type = "string" },
  expandtab = { scope = "buffer", type = "boolean" },
  foldenable = { scope = "window", type = "boolean" },
  formatprg = { scope = "buffer", type = "string" },
  iskeyword = { scope = "buffer", type = "list" },
  list = { scope = "window", type = "boolean" },
  modifiable = { scope = "buffer", type = "boolean" },
  omnifunc = { scope = "buffer", type = "string" },
  readonly = { scope = "buffer", type = "boolean" },
  shiftwidth = { scope = "buffer", type = "number" },
  smartindent = { scope = "buffer", type = "boolean" },
  spell = { scope = "window", type = "boolean" },
  spellfile = { scope = "buffer", type = "string" },
  spelllang = { scope = "buffer", type = "string" },
  statusline = { scope = "window", type = "string" },
  synmaxcol = { scope = "buffer", type = "number" },
  tabstop = { scope = "buffer", type = "number" },
  textwidth = { scope = "buffer", type = "number" },
  wrap = { scope = "window", type = "boolean" },
  wrapmargin = { scope = "buffer", type = "number" },
}

function M.join(tbl, delimiter)
  delimiter = delimiter or ""
  local result = ""
  local len = #tbl
  for i, item in ipairs(tbl) do
    if i == len then
      result = result .. item
    else
      result = result .. item .. delimiter
    end
  end
  return result
end

local setlocal = function(name, ...)
  local args = { ... }
  local operator = nil
  local value = nil
  if #args == 0 then
    operator = "="
    value = true
  elseif #args == 1 then
    operator = "="
    value = args[1]
  elseif #args == 2 then
    operator = args[1]
    value = args[2]
  else
    return vim.api.nvim_err_writeln("setlocal(): expects 1 or 2 arguments, got " .. #args)
  end

  local option = options[name]
  if option == nil then
    return vim.api.nvim_err_writeln("setlocal(): unsupported option: " .. name)
  end

  local get = option.scope == "buffer" and vim.api.nvim_buf_get_option or vim.api.nvim_win_get_option

  local set = option.scope == "buffer" and vim.api.nvim_buf_set_option or vim.api.nvim_win_set_option

  if operator == "=" then
    set(0, name, value)
  elseif operator == "-=" then
    if option.type ~= "list" then
      return vim.api.nvim_err_writeln('setlocal(): operator "-=" requires list type but got ' .. option.type)
    end
    local current = vim.split(get(0, name), ",")
    print("current " .. vim.inspect(current))
    local new = vim.tbl_filter(function(item)
      return item ~= value
    end, current)
    set(0, name, M.join(new, ","))
  else
    return vim.api.nvim_err_writeln("setlocal(): unsupported operator: " .. operator)
  end
end

function M.range(lower, upper)
  local result = {}
  for i = lower, upper do
    table.insert(result, i)
  end
  return result
end

_G.command = command
_G.cnoremap = cnoremap
_G.inoremap = inoremap
_G.nnoremap = nnoremap
_G.xnoremap = xnoremap
_G.snoremap = snoremap
_G.noremap = noremap
_G.cmap = cmap
_G.imap = imap
_G.nmap = nmap
_G.xmap = xmap
_G.smap = smap
_G.augroup = augroup
_G.autocmd = autocmd
_G.kdheepak = kdheepak
_G.T = T
_G.P = P
_G.setlocal = setlocal

return M
