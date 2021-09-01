local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.load_extension("fzf")
telescope.load_extension("dap")
telescope.load_extension("gh")
telescope.load_extension("lsp_handlers")
telescope.load_extension("heading")
telescope.load_extension("emoji")
telescope.load_extension("session-lens")
telescope.load_extension("openbrowser")
telescope.load_extension("docker")
telescope.load_extension("termfinder")
telescope.load_extension("octo_commands")
telescope.load_extension("jumps")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-c>"] = false,
        ["<C-j>"] = actions.move_selection_worse,
        ["<C-k>"] = actions.move_selection_better,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default + actions.center,
        ["<C-v>"] = actions.select_vertical,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-t>"] = actions.select_tab,
        ["<C-y>"] = actions.preview_scrolling_up,
        ["<C-e>"] = actions.preview_scrolling_down,
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-d>"] = actions.delete_buffer,
        ["<C-H>"] = actions.move_to_top,
        ["<C-M>"] = actions.move_to_middle,
        ["<C-L>"] = actions.move_to_bottom,
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
    lsp_handlers = {
      code_action = {
        telescope = require("telescope.themes").get_dropdown({}),
      },
    },
    -- Add bookmark urls
    openbrowser = {
      bookmarks = {
        ["luv docs"] = "https://github.com/luvit/luv/blob/master/docs.md",
      },
      bookmark_filepath = "~/config/nvim/telescope_openbrowser_bookamarks",
    },
  },
})
