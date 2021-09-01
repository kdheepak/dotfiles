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

local function edit_or_qf(selected)
  if should_qf(selected) then
    actions.file_sel_to_qf(selected)
    vim.cmd("cc")
  else
    actions.file_edit(selected)
  end
end

require("fzf-lua").setup({
  fzf_layout = "reverse", -- fzf '--layout='
  fzf_binds = { -- fzf '--bind=' options
    "ctrl-h:toggle-preview",
    "ctrl-d:preview-half-page-down",
    "ctrl-u:preview-half-page-up",
    "ctrl-f:page-down",
    "ctrl-b:page-up",
    "ctrl-a:toggle-all",
    "ctrl-l:clear-query",
  },
  previewers = {
    builtin = {
      keymap = {
        toggle_hide = "<c-h>",
        toggle_full = "<c-o>",
        page_up = "<c-u>",
        page_down = "<c-d>",
        page_reset = "<c-r>",
      },
    },
  },
  files = {
    prompt = "Files❯ ",
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
