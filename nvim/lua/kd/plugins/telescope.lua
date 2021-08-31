local actions = require("telescope.actions")
local telescope = require("telescope")

telescope.load_extension("fzf")
telescope.load_extension("dap")
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

local telescope = require("telescope")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local layout_strategies = require("telescope.pickers.layout_strategies")

local nnoremap = require("kd/utils").nnoremap
local builtin = function(name)
  return require("telescope.builtin")[name]
end
local extensions = function(name)
  return require("telescope").load_extension(name)
end

nnoremap("<leader>fB", function()
  builtin("current_buffer_fuzzy_find")({})
end)

nnoremap("<Leader>fb", function()
  builtin("buffers")({})
end)

nnoremap("<leader>ff", function()
  if vim.loop.cwd() == vim.loop.os_homedir() then
    vim.api.nvim_echo({
      {
        "find_files on $HOME is danger. Launch file_browser instead.",
        "WarningMsg",
      },
    }, true, {})
    opts.attach_mappings = function(_, map)
      map("i", "<cr>", actions.fzf_multi_select)
      return true
    end
    builtin("file_browser")(opts)
  elseif vim.fn.isdirectory(vim.loop.cwd() .. "/.git") == 1 then
    opts.attach_mappings = function(_, map)
      map("i", "<cr>", actions.fzf_multi_select)
      return true
    end
    builtin("git_files")(opts)
  else
    opts = opts or {}
    -- add hidden files to find_files
    opts.hidden = true
    opts.attach_mappings = function(_, map)
      map("i", "<cr>", actions.fzf_multi_select)
      return true
    end
    builtin("find_files")(opts)
  end
end, {
  silent = true,
})

nnoremap("<leader>f:", function()
  builtin("command_history")({})
end, { silent = true })

nnoremap("<leader>fG", function()
  opts.attach_mappings = function(_, map)
    map("i", "<cr>", actions.fzf_multi_select)
    return true
  end
  builtin("grep_string")(opts)
end, {
  silent = true,
})

nnoremap("<leader>fH", function()
  builtin("help_tags")({ lang = "en" })
end)

nnoremap("<leader>fP", function()
  extensions("packer").plugins({})
end)

nnoremap("<leader>fh", function()
  builtin("help_tags")({})
end)

nnoremap("<leader>fm", function()
  builtin("man_pages")({ sections = { "ALL" } })
end)

nnoremap("<leader>sr", function()
  builtin("lsp_references")({})
end)

nnoremap("<leader>sd", function()
  builtin("lsp_document_symbols")({})
end)

nnoremap("<leader>sw", function()
  builtin("lsp_workspace_symbols")({})
end)

nnoremap("<leader>sc", function()
  builtin("lsp_code_actions")({})
end)

nnoremap("<leader>gc", function()
  builtin("git_commits")({})
end)

nnoremap("<leader>gb", function()
  builtin("git_bcommits")({})
end)

nnoremap("<leader>gr", function()
  builtin("git_branches")({})
end)

nnoremap("<leader>gs", function()
  builtin("git_status")({})
end)

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_worse,
        ["<C-k>"] = actions.move_selection_better,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default + actions.center,
        ["<C-v>"] = actions.select_vertical,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-t>"] = actions.select_tab,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.send_to_qflist,
      },
    },
    layout_config = {
      prompt_position = "top",
    },
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    generic_sorter = require("telescope.sorters").get_fzy_sorter,
    set_env = { ["COLORTERM"] = "truecolor" },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
})
