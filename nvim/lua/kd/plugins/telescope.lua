local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.load_extension("fzf")
telescope.load_extension("dap")
telescope.load_extension("fzf_writer")
telescope.load_extension("gh")
telescope.load_extension("lsp_handlers")
telescope.load_extension("heading")
telescope.load_extension("emoji")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

function actions.fzf_multi_select(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local num_selections = table.getn(picker:get_multi_selection())

  if num_selections > 1 then
    local picker = action_state.get_current_picker(prompt_bufnr)
    for _, entry in ipairs(picker:get_multi_selection()) do
      vim.cmd(string.format("%s %s", ":e!", entry.value))
    end
    vim.cmd("stopinsert")
  else
    actions.file_edit(prompt_bufnr)
  end
end

telescope.setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    lsp_handlers = {
      code_action = {
        telescope = require("telescope.themes").get_dropdown({}),
      },
    },
  },
})
