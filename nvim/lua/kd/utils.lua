local M = {}
local wk_status, wk = pcall(require, "which-key")

M._current_autocmd_group_name = nil

function M.augroup(name, callback)
  vim.api.nvim_create_augroup(name, { clear = true })
  M._current_autocmd_group_name = name
  callback()
  M._current_autocmd_group_name = nil
end

function M.ternary(cond, T, F)
  if cond then
    return T
  else
    return F
  end
end

-- Wrapper for simple autocmd use cases. `cmd` may be a string or a Lua function.
function M.autocmd(name, cmd, opts)
  opts = opts or {}
  local cmd_type = type(cmd)
  if cmd_type == "function" then
    opts.callback = cmd
  elseif cmd_type == "string" then
    opts.command = cmd
  else
    error("autocmd(): unsupported cmd type: " .. cmd_type)
  end
  if M._current_autocmd_group_name ~= nil then
    opts.group = M._current_autocmd_group_name
  end
  vim.api.nvim_create_autocmd(name, opts)
end

function M._map(mode, lhs, rhs, opts)
  opts = opts or {}
  local rhs_type = type(rhs)
  if rhs_type == "table" then
    -- Use which key
    if rhs.label == nil then
      error("map(): unsupported rhs table")
    end
    opts.mode = mode
    opts.nowait = false
    opts.silent = opts.silent or false
    local t = {}
    t[lhs] = { name = rhs.label }
    if wk_status then
      return wk.register(t, opts)
    end
  end

  local label = opts.label
  local buffer = opts.buffer
  opts.label = nil
  opts.buffer = nil

  if buffer == true or buffer ~= nil then
    if label == nil then
      vim.api.nvim_buf_set_keymap(M.ternary(buffer, 0, buffer), mode, lhs, rhs, opts)
    else
      if wk_status then
        opts.mode = mode
        opts.nowait = true
        opts.buffer = M.ternary(buffer, vim.fn.bufnr(), buffer)
        opts.silent = opts.silent or false
        local t = {}
        t[lhs] = { rhs, opts.label }
        wk.register(t, opts)
      else
        vim.api.nvim_buf_set_keymap(M.ternary(buffer, 0, buffer), mode, lhs, rhs, opts)
      end
    end
  else
    if label == nil then
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    else
      if wk_status then
        opts.mode = mode
        opts.nowait = false
        opts.silent = opts.silent or false
        local t = {}
        t[lhs] = { rhs, label }
        wk.register(t, opts)
      else
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
      end
    end
  end

  return {
    dispose = function()
      if buffer == true or buffer ~= nil then
        vim.api.nvim_buf_del_keymap(M.ternary(buffer, 0, buffer), mode, lhs)
      else
        vim.api.nvim_del_keymap(mode, lhs)
      end
    end,
  }
end

function M.cnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.cmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.inoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.imap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.nnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.nmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.vnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.vmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.xnoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.xmap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.snoremap(lhs, rhs, opts)
  opts = opts or {}
  return M.smap(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.noremap(lhs, rhs, opts)
  opts = opts or {}
  return M.map(lhs, rhs, vim.tbl_extend("force", opts, { noremap = true }))
end

function M.cmap(lhs, rhs, opts)
  opts = opts or {}
  return M._map("c", lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
  opts = opts or {}
  return M._map("i", lhs, rhs, opts)
end

function M.nmap(lhs, rhs, opts)
  opts = opts or {}
  return M._map("n", lhs, rhs, opts)
end

function M.xmap(lhs, rhs, opts)
  opts = opts or {}
  return M._map("x", lhs, rhs, opts)
end

function M.smap(lhs, rhs, opts)
  opts = opts or {}
  return M._map("s", lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
  opts = opts or {}
  return M._map("v", lhs, rhs, opts)
end

function M.map(lhs, rhs, opts)
  opts = opts or {}
  return M._map("", lhs, rhs, opts)
end

function M.command(name, cmd, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, cmd, opts)
end

function M.prequire(...)
  local status, lib = pcall(require, ...)
  if status then
    return lib
  end
  return nil
end

function M.T(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.feedkeys(key, mode)
  return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
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
      return vim.api.nvim_err_writeln("setlocal(): operator \"-=\" requires list type but got " .. option.type)
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

function M.strip_trailing_slash(dir)
  if string.sub(dir, -1, -1) == "/" then
    dir = string.sub(dir, 1, -2)
  end
  return dir
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

M.has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.get_visual_selection = function()
  vim.cmd([[visual]])
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  P(start_row, start_col, end_row, end_col)
  local lines = vim.fn.getline(start_row, end_row)
  local n = 0
  for _ in pairs(lines) do
    n = n + 1
  end
  if n <= 0 then
    return nil
  end
  lines[n] = string.sub(lines[n], 1, end_col)
  lines[1] = string.sub(lines[1], start_col)
  P(lines)
  return table.concat(lines, "\n")
end

function M.get_git_directory()
  local Job = require("plenary.job")
  local s, ret = Job
    :new({
      command = "git",
      args = { "rev-parse", "--show-superproject-working-tree", "--show-toplevel" },
    })
    :sync()
  if ret == 0 then
    return s[1]
  else
    return vim.loop.cwd()
  end
end

function M.check_lsp_client_active(name)
  local clients = vim.lsp.get_active_clients()
  for _, client in pairs(clients) do
    if client.name == name then
      return true
    end
  end
  return false
end

_G.T = M.T
_G.P = M.P

return M
