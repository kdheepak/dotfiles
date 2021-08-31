local M = {}

_G.kd = { g = {} }

function M.augroup(name, callback)
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

kd.g.autocommand_callbacks = {}

-- Wrapper for simple autocmd use cases. `cmd` may be a string or a Lua function.
function M.autocmd(name, pattern, cmd, opts)
  opts = opts or {}
  local cmd_type = type(cmd)
  if cmd_type == "function" then
    local key = M.get_key_for_fn(cmd, kd.g.autocommand_callbacks)
    kd.g.autocommand_callbacks[key] = cmd
    cmd = "lua kd.g.autocommand_callbacks." .. key .. "()"
  elseif cmd_type ~= "string" then
    error("autocmd(): unsupported cmd type: " .. cmd_type)
  end
  local bang = opts.bang and "!" or ""
  vim.cmd("autocmd" .. bang .. " " .. name .. " " .. pattern .. " " .. cmd)
end

kd.g.map_callbacks = {}

function M._map(mode, lhs, rhs, opts)
  opts = opts or {}
  local rhs_type = type(rhs)
  local key
  if rhs_type == "function" then
    key = M.get_key_for_fn(rhs, kd.g.map_callbacks)
    kd.g.map_callbacks[key] = rhs
    rhs = ":lua kd.g.map_callbacks." .. key .. "()<CR>"
  elseif rhs_type ~= "string" then
    error("map(): unsupported rhs type: " .. rhs_type)
  end

  local buffer = opts.buffer
  if buffer == true then
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
  elseif buffer ~= nil then
    vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, opts)
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
      kd.g.map_callbacks[key] = nil
    end,
  }
end

function M.cnoremap(lhs, rhs, opts)
  opts = opts or {}
  M.map(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.inoremap(lhs, rhs, opts)
  opts = opts or {}
  M.imap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.nnoremap(lhs, rhs, opts)
  opts = opts or {}
  M.nmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.vnoremap(lhs, rhs, opts)
  opts = opts or {}
  M.vmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.xnoremap(lhs, rhs, opts)
  opts = opts or {}
  M.xmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.snoremap(lhs, rhs, opts)
  opts = opts or {}
  M.smap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.noremap(lhs, rhs, opts)
  opts = opts or {}
  M.map(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.cmap(lhs, rhs, opts)
  opts = opts or {}
  M._map("c", lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
  opts = opts or {}
  M._map("i", lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
  opts = opts or {}
  M._map("n", lhs, rhs, opts)
end

function M.xmap(lhs, rhs, opts)
  opts = opts or {}
  M._map("x", lhs, rhs, opts)
end

function M.smap(lhs, rhs, opts)
  opts = opts or {}
  M._map("s", lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
  opts = opts or {}
  M._map("v", lhs, rhs, opts)
end

function M.map(lhs, rhs, opts)
  opts = opts or {}
  M._map("", lhs, rhs, opts)
end

kd.g.command_callbacks = {}

function M.command(name, repl, opts)
  opts = opts or {}
  local repl_type = type(repl)
  if repl_type == "function" then
    local key = M.get_key_for_fn(repl, kd.g.command_callbacks)
    kd.g.command_callbacks[key] = repl
    repl = "lua kd.g.command_callbacks." .. key .. "()"
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

function M.T(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.P(...)
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

function M.setlocal(name, ...)
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

function M.syntax(item, ...)
  local t = { ... }
  local expansion = ""
  for _, s in ipairs(t) do
    expansion = expansion .. " " .. s
  end
  vim.cmd("syntax " .. item .. " " .. expansion)
end

function M.highlight(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if group == "default" and guifg == "link" then
    local lhs = guibg
    local rhs = ctermfg
    vim.cmd("highlight def link " .. lhs .. " " .. rhs)
  else
    attr = attr or ""
    guisp = guisp or ""

    local command = ""

    if guifg ~= "" then
      command = command .. " guifg=#" .. guifg
    end
    if guibg ~= "" then
      command = command .. " guibg=#" .. guibg
    end
    if ctermfg ~= "" then
      command = command .. " ctermfg=" .. ctermfg
    end
    if ctermbg ~= "" then
      command = command .. " ctermbg=" .. ctermbg
    end
    if attr ~= "" then
      command = command .. " gui=" .. attr .. " cterm=" .. attr
    end
    if guisp ~= "" then
      command = command .. " guisp=#" .. guisp
    end

    if command ~= "" then
      vim.cmd("highlight " .. group .. command)
    end
  end
end

M.check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

_G.command = M.command
_G.cnoremap = M.cnoremap
_G.inoremap = M.inoremap
_G.nnoremap = M.nnoremap
_G.vnoremap = M.vnoremap
_G.xnoremap = M.xnoremap
_G.snoremap = M.snoremap
_G.noremap = M.noremap
_G._map = M._map
_G.map = M.map
_G.cmap = M.cmap
_G.imap = M.imap
_G.nmap = M.nmap
_G.xmap = M.xmap
_G.smap = M.smap
_G.vmap = M.vmap
_G.augroup = M.augroup
_G.autocmd = M.autocmd
_G.T = M.T
_G.P = M.P
_G.setlocal = M.setlocal
_G.syntax = M.syntax
_G.highlight = M.highlight

return M
