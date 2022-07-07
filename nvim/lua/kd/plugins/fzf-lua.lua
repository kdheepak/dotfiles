local actions = require("fzf-lua.actions")

local function should_qf(selected)
  if #selected <= 2 then
    return false
  end

  for _, sel in ipairs(selected) do
    if string.match(sel, "^.+:%d+:%d+:") then
      return true
    end
  end

  return false
end

local function edit_or_qf(selected, opts)
  if should_qf(selected) then
    actions.file_sel_to_qf(selected)
    vim.cmd("cc")
  else
    actions.file_edit(selected, opts)
  end
end

require("fzf-lua").setup({
  fzf_layout = "reverse", -- fzf '--layout='
  previewers = {
    bat = {
      config = vim.fn.expand("~/.config/bat/config"),
    },
    builtin = {
      extensions = {
        ["png"] = { "catimg", "-w", "80" },
        ["jpeg"] = { "catimg", "-w", "80" },
        ["jpg"] = { "catimg", "-w", "80" },
      },
    },
  },
  files = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  git = {
    files = {
      actions = {
        ["default"] = edit_or_qf,
      },
    },
  },
  grep = {
    rg_opts = "--hidden --column --line-number --sort-files --no-heading --color=always --smart-case -g '!{.git,node_modules}/*'",
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  buffers = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  blines = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
  lsp = {
    actions = {
      ["default"] = edit_or_qf,
    },
  },
})

local fzf_lua = require("fzf-lua")
local fzf = require("fzf")
local fzf_helpers = require("fzf.helpers")
local core = require("fzf-lua.core")
local path = require("fzf-lua.path")
local utils = require("fzf-lua.utils")
local config = require("fzf-lua.config")
local actions = require("fzf-lua.actions")

fzf_lua.register_ui_select()

config.globals.git_history = {
  prompt = "Git History> ",
  input_prompt = "Search For> ",
  preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
  cmd = "git log --pretty --oneline",
  actions = {
    ["default"] = actions.git_checkout,
  },
}

local git_history = function(opts)
  opts = config.normalize_opts(opts, config.globals.git_history)
  if not opts then
    return
  end

  opts.cwd = path.git_root(opts.cwd)

  if not opts.search then
    opts.search = vim.fn.input(opts.input_prompt) or ""
  end

  opts.cmd = opts.cmd .. " -S'" .. opts.search .. "'"
  opts.preview = vim.fn.shellescape(path.git_cwd(opts.preview, opts.cwd))
  coroutine.wrap(function()
    local fzf_fn = fzf_helpers.cmd_line_transformer({ cmd = opts.cmd, cwd = opts.cwd }, function(x)
      return x
    end)
    local selected = core.fzf(opts, fzf_fn)
    if not selected then
      return
    end
    actions.act(opts.actions, selected, opts)
  end)()
end
