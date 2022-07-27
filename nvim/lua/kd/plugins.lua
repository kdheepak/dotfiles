M = {}

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  execute("packadd packer.nvim")
end

local packer = require("packer")
local use = packer.use

function M.reload_config()
  -- require("plenary.reload").reload_module("kd/plugins/lualine", true)
  vim.cmd("source ~/.config/nvim/init.lua")
  vim.cmd("source ~/.config/nvim/lua/kd/plugins.lua")
  vim.cmd(":PackerCompile")
  vim.cmd(":PackerClean")
  vim.cmd(":PackerInstall")
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd User PackerComplete lua vim.notify('PackerComplete Done', 2, {title = "kdheepak/dotfiles"})
    autocmd User PackerCompileDone lua vim.notify('PackerCompile Done', 2, {title = "kdheepak/dotfiles"})
  augroup end
]])

packer.reset()
packer.init({ max_jobs = 16 })

packer.startup({
  function()
    -- Packer can manage itself

    use("wbthomason/packer.nvim")
    use("nvim-lua/plenary.nvim")
    use("lewis6991/impatient.nvim")

    -- colorscheme
    -- use({
    --   "projekt0n/github-nvim-theme",
    --   config = function()
    --     vim.g.background = "light"
    --     vim.g.termguicolors = true
    --     require("github-theme").setup({
    --       theme_style = "light",
    --       keyword_style = "NONE",
    --       function_style = "NONE",
    --       variable_style = "NONE",
    --       comment_style = "italic",
    --       overrides = function(c)
    --         return {
    --           CursorLine = { bg = c.bg_nc_statusline },
    --           ColorColumn = { bg = c.bg_nc_statusline },
    --         }
    --       end,
    --     })
    --   end,
    -- })

    use({
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        local catppuccin = require("catppuccin")
        catppuccin.setup({})
        vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
        vim.cmd([[colorscheme catppuccin]])
      end,
    })

    use({
      "neovim/nvim-lspconfig",
      requires = {
        {
          "kdheepak/lsp-status.nvim",
          branch = "fork",
          config = function()
            require("lsp-status").register_progress()
          end,
        },
        {
          "jose-elias-alvarez/null-ls.nvim",
          config = function()
            require("kd/plugins/null-ls")
          end,
        },
        { "folke/lsp-colors.nvim" },
        { "williamboman/mason.nvim", config = function()
            require("mason").setup({
              ui = {
                icons = {
                  server_installed = "",
                  server_pending = "",
                  server_uninstalled = "",
                },
              },
            })
          end,
        },
        { "SmiteshP/nvim-navic", config = function()
          vim.g.navic_silence = true
        end,
        },
      },
      config = function()
        require("kd/plugins/nvim-lspconfig")
      end,
    })

    use({
      "gelguy/wilder.nvim",
      requires = { { "romgrk/fzy-lua-native", after = "wilder.nvim" }, { "nixprime/cpsm" } },
      event = "CmdlineEnter",
      config = function()
        require("kd/plugins/wilder")
      end,
    })

    use({
      "hrsh7th/nvim-cmp",
      requires = {
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "rcarriga/cmp-dap" },
        { "antoinemadec/FixCursorHold.nvim" },
        { "rafamadriz/friendly-snippets" },
        -- {
        --   "L3MON4D3/LuaSnip",
        --   config = function()
        --     require("luasnip.config").set_config({
        --       history = true,
        --       updateevents = "TextChanged,TextChangedI",
        --       enable_autosnippets = true,
        --     })
        --     local imap = require("kd/utils").imap
        --     local smap = require("kd/utils").smap
        --     imap("<Esc>", [[<Esc><cmd>silent LuaSnipUnlinkCurrent<CR>]])
        --     smap("<Esc>", [[<Esc><cmd>silent LuaSnipUnlinkCurrent<CR>]])
        --   end,
        -- },
        -- { "saadparwaiz1/cmp_luasnip" },
        { "onsails/lspkind-nvim" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-emoji" },
        { "hrsh7th/cmp-calc" },
        { "kdheepak/cmp-latex-symbols" },
        { "Saecki/crates.nvim", requires = { "nvim-lua/plenary.nvim" } },
        {
          "petertriho/cmp-git",
          requires = { "nvim-lua/plenary.nvim" },
          config = function()
            require("cmp_git").setup()
          end,
        },
        { "f3fora/cmp-spell" },
        { "lukas-reineke/cmp-rg" },
        { "lukas-reineke/cmp-under-comparator" },
        { "hrsh7th/cmp-nvim-lsp-document-symbol" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
        {
          "aspeddro/cmp-pandoc.nvim",
          requires = {
            "nvim-lua/plenary.nvim",
            "jbyuki/nabla.nvim", -- optional
          },
          config = function()
            require("cmp_pandoc").setup()
          end,
        },
        {
          "uga-rosa/cmp-dictionary",
          config = function()
            require("cmp_dictionary").setup({
              dic = {
                ["*"] = { "/usr/share/dict/words" },
              },
              -- The following are default values, so you don't need to write them if you don't want to change them
              exact = 2,
              first_case_insensitive = false,
              async = false,
              capacity = 5,
              debug = false,
            })
          end,
        },
      },
      config = function()
        require("kd/plugins/nvim-cmp")
      end,
    })

    use({
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require("nvim-treesitter.configs").setup({
          playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = "o",
              toggle_hl_groups = "i",
              toggle_injected_languages = "t",
              toggle_anonymous_nodes = "a",
              toggle_language_display = "I",
              focus_language = "f",
              unfocus_language = "F",
              update = "R",
              goto_node = "<cr>",
              show_help = "?",
            },
          },
          ensure_installed = "all",
          ignore_install = { "phpdoc" },
          autotag = { enable = true },
          highlight = { enable = true, disable = { "julia" } },
          indent = { enable = true },
          textobjects = {
            enable = true,
            select = {
              enable = true,
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
              keymaps = {
                -- You can load the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
              },
              lsp_interop = {
                enable = true,
                border = "none",
                peek_definition_code = { ["df"] = "@function.outer", ["dF"] = "@class.outer" },
              },
            },
            swap = {
              enable = true,
              swap_next = { ["<leader>a"] = "@parameter.inner" },
              swap_previous = { ["<leader>A"] = "@parameter.inner" },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
              goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
              goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
              goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
            },
          },
          context_commentstring = { enable = true },
        })
      end,
      requires = {
        { "nvim-treesitter/playground" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        { "windwp/nvim-ts-autotag" },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
      },
    })

    use({
      "ibhagwan/fzf-lua",
      requires = {
        "vijaymarupudi/nvim-fzf",
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("kd/plugins/fzf-lua")
      end,
    })

    use({
      "nvim-telescope/telescope.nvim",
      requires = { { "nvim-lua/plenary.nvim" }, { "kdheepak/lazygit.nvim" } },
      config = function()
        require("telescope").load_extension("lazygit")
      end,
    })

    use({
      "nvim-lualine/lualine.nvim",
      config = function()
        require("kd/plugins/lualine")
      end,
      requires = {
        { "kyazdani42/nvim-web-devicons", opt = true },
        { "kdheepak/tabline.nvim", config = function()
          -- require 'tabline'.setup {
          --   -- Defaults configuration options
          --   enable = true,
          -- }
        end },
        {
          "liuchengxu/vista.vim",
          config = function()
            local augroup = require("kd/utils").augroup
            local autocmd = require("kd/utils").autocmd
            augroup("VistaNearest", function()
              autocmd("CursorHold", function()
                autocmd("VimEnter", "call vista#RunForNearestMethodOrFunction()")
              end)
            end)
          end,
        },
      },
    })

    use({
      "rcarriga/neotest",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim"
      }
    })

    use({
      "folke/which-key.nvim",
      config = function()
        require("kd/plugins/which-key")
      end,
    })

    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })

    use({
      "haya14busa/vim-asterisk",
      config = function()
        vim.g["asterisk#keeppos"] = 1
        local map = require("kd/utils").map
        map("*", "<Plug>(asterisk-z*)")
        map("#", "<Plug>(asterisk-z#)")
        map("g*", "<Plug>(asterisk-gz*)")
        map("g#", "<Plug>(asterisk-gz#)")
      end,
    })

    use({
      "rcarriga/nvim-notify",
      config = function()
        vim.notify = require("notify")
        require("notify").setup({
          timeout = 2000,
        })
      end,
    })

    use({
      "hood/popui.nvim",
      requires = { "RishabhRD/popfix" },
      config = function()
        vim.ui.select = require("popui.ui-overrider")
        vim.ui.input = require("popui.input-overrider")
      end,
    })

    use("farmergreg/vim-lastplace") -- intelligently reopen files at your last edit position

    use({ "arp242/auto_mkdir2.vim", event = "BufRead" })

    use({ "moll/vim-bbye", event = "BufRead" }) -- close buffers without changing vim layout

    use({ "ggandor/lightspeed.nvim", event = "BufRead" }) -- load s and S to search, overrides f and t for multiline

    -- Lua
    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup({
        })
      end
    })

    -- -----------------------------------------------------------------------------------------------------------------
    --
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup({
          signs = {
            add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
            change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
            delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
            topdelete = {
              hl = "GitSignsDelete",
              text = "‾",
              numhl = "GitSignsDeleteNr",
              linehl = "GitSignsDeleteLn",
            },
            changedelete = {
              hl = "GitSignsChange",
              text = "~",
              numhl = "GitSignsChangeNr",
              linehl = "GitSignsChangeLn",
            },
          },
          numhl = false,
          linehl = false,
          keymaps = {
            -- Default keymap options
            noremap = true,

            ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
            ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

            -- Text objects
            ["o ih"] = ":<C-U>lua require\"gitsigns.actions\".select_hunk()<CR>",
            ["x ih"] = ":<C-U>lua require\"gitsigns.actions\".select_hunk()<CR>",
          },
        })
      end,
      event = "BufRead",
    })

    use({ "mfussenegger/nvim-dap" })
    use({ 'theHamsta/nvim-dap-virtual-text', config = function()
      require("nvim-dap-virtual-text").setup()
    end })
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = function()
      require("dapui").setup()
    end }

    use({ "jbyuki/one-small-step-for-vimkind", ft = "lua" }) -- DAP adapter for neovim lua language

    use({ 'mfussenegger/nvim-dap-python', config = function()
      require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
      require('dap-python').test_runner = 'pytest'
    end })

    use({ "euclidianAce/BetterLua.vim", event = "BufRead" })

    use({ "tpope/vim-fugitive", event = "BufRead" }) -- vim plugin for Git that is so awesome, it should be illegal
    use({
      "ruanyl/vim-gh-line",
      config = function()
        vim.g.gh_line_map = "<leader>go"
        vim.g.gh_line_blame_map = "<leader>gb"
      end,
    })

    use({
      "pwntester/octo.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = function()
        require("octo").setup()
      end,
    })

    use({
      "lalitmee/browse.nvim",
      requires = { "nvim-telescope/telescope.nvim" },
    })

    use({ "tpope/vim-rhubarb", event = "BufRead" }) -- vim plugin for github

    use({
      "whiteinge/diffconflicts",
      config = function()
        vim.cmd([[
          " Disable one diff window during a three-way diff allowing you to cut out the
          " noise of a three-way diff and focus on just the changes between two versions
          " at a time. Inspired by Steve Losh's Splice
          function! DiffToggle(window)
            " Save the cursor position and turn on diff for all windows
            let l:save_cursor = getpos('.')
            windo :diffthis
            " Turn off diff for the specified window (but keep scrollbind) and move
            " the cursor to the left-most diff window
            exe a:window . "wincmd w"
            diffoff
            set scrollbind
            set cursorbind
            exe a:window . "wincmd " . (a:window == 1 ? "l" : "h")
            " Update the diff and restore the cursor position
            diffupdate
            call setpos('.', l:save_cursor)
          endfunction

          " Toggle diff view on the left, center, or right windows
          nmap <silent> <leader>dl :call DiffToggle(1)<cr>
          nmap <silent> <leader>dc :call DiffToggle(2)<cr>
          nmap <silent> <leader>dr :call DiffToggle(3)<cr>
        ]])
      end,
      event = "BufRead",
    })

    use({
      "akinsho/git-conflict.nvim",
      config = function()
        require("git-conflict").setup()
      end,
    })

    use({
      "ruifm/gitlinker.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("gitlinker").setup({
          opts = {
            action_callback = function(url)
              require("gitlinker.actions").copy_to_clipboard(url)
              vim.notify("Copied " .. url .. " to clipboard", nil, { title = "ruifm/gitlinker.nvim" })
            end,
          },
        })
      end,
    })

    use({ "tpope/vim-unimpaired", event = "BufRead" }) -- complementary pairs of mappings

    use({ "tpope/vim-abolish", event = "BufRead" }) -- convert camel to snake

    use({ "tpope/vim-surround", event = "BufRead" }) -- all about surroundings: parentheses, brackets, quotes, XML tags, and more.

    use({ "tpope/vim-repeat", event = "BufRead" }) -- repeat.vim remaps . in a way that plugins can tap into it.

    use({ "tpope/vim-speeddating", event = "BufRead" }) -- Tools for working with dates

    use({ "tpope/vim-eunuch", event = "BufRead" }) -- vim sugar for UNIX shell commands like :Rename

    use({ "tpope/vim-sleuth", event = "BufRead" }) -- This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file

    use({ "tpope/vim-dadbod" }) -- Database interface
    use({ "kristijanhusak/vim-dadbod-ui" }) -- UI Database interface

    use({ "inkarkat/vim-visualrepeat", event = "BufRead" }) -- repetition of vim built-in normal mode commands via . for visual mode

    use({ "Konfekt/vim-CtrlXA", event = "BufRead" }) -- Increment and decrement and toggle keywords

    use({ "dhruvasagar/vim-zoom", event = "BufRead" }) -- toggle zoom of current window within the current tab

    use({
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup({})
      end,
      event = "BufRead",
    })

    use({ "mbbill/undotree", event = "BufRead" }) -- visualizes undo history and makes it easier to browse and switch between different undo branches

    use({ "reedes/vim-wordy", event = "BufRead" }) -- uncover usage problems in your writing

    use({
      "ntpeters/vim-better-whitespace",
      config = function()
        local augroup = require("kd/utils").augroup
        local autocmd = require("kd/utils").autocmd
        augroup("StripWhitespace", function()
          autocmd("BufEnter", "EnableStripWhitespaceOnSave")
        end)
        vim.g.strip_whitespace_confirm = 0
        vim.g.strip_only_modified_lines = 1
      end,
      event = "BufRead",
    }) -- caloads all trailing whitespace characters to be highlighted

    use({ "godlygeek/tabular", event = "BufRead" }) -- line up text

    use({ "dhruvasagar/vim-table-mode", event = "BufRead" }) -- automatic table creator & formatter allowing one to create neat tables as you type

    use({ "chrisbra/unicode.vim", event = "BufRead" }) -- vim unicode helper

    use { 'kevinhwang91/nvim-bqf', ft = 'qf' }

    use({ 'spywhere/detect-language.nvim', config = function()
      require('detect-language').setup {}
    end })

    use({
      "akinsho/toggleterm.nvim",
      config = function()
        local nnoremap = require("kd/utils").nnoremap
        nnoremap("<leader>/", "<cmd>ToggleTerm direction=horizontal<CR>", { label = "Split terminal horizontally" })
        nnoremap("<leader>\\", "<cmd>ToggleTerm direction=vertical<CR>", { label = "Split terminal vertically" })
        require("toggleterm").setup({
          -- size can be a number or function which is passed the current terminal
          open_mapping = [[<c-\><c-\>]],
          hide_numbers = true, -- hide the number column in toggleterm buffers
          shade_terminals = false,
          start_in_insert = false,
          insert_mappings = true, -- whether or not the open mapping applies in insert mode
          persist_size = true,
          direction = "float",
          close_on_exit = true, -- close the terminal window when the process exits
          -- This field is only relevant if direction is set to 'float'
          float_opts = { border = "curved" },
        })
      end,
      event = "BufRead",
    })

    use({ "hkupty/iron.nvim", config = function()

      local iron = require("iron.core")

      iron.setup {
        config = {
          -- If iron should expose `<plug>(...)` mappings for the plugins
          should_map_plug = false,
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              command = { "zsh" }
            }
          },
          repl_open_cmd = require('iron.view').curry.bottom(40),
          -- how the REPL window will be opened, the default is opening
          -- a float window of height 40 at the bottom.
        },
        -- Iron doesn't set keymaps by default anymore. Set them here
        -- or use `should_map_plug = true` and map from you vim files
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true
        }
      }
    end })

    use({
      "nacro90/numb.nvim", -- peek lines of the buffer
      config = function()
        require("numb").setup()
      end,
      event = "BufRead",
    })

    -- languages
    use({ "nanotee/luv-vimdocs", ft = "lua" })

    use({ "wsdjeg/luarefvim", ft = "lua" })

    use({ "GutenYe/json5.vim", ft = "json" })

    use({ "posva/vim-vue", ft = { "vue" } })

    use({ "Vimjas/vim-python-pep8-indent", ft = { "python" } }) -- a nicer Python indentation style for vim

    use({ "evanleck/vim-svelte", ft = { "svelte" } })

    use({ "rust-lang/rust.vim", ft = { "rust" } }) -- rust file detection, syntax highlighting, formatting, Syntastic integration, and more

    -- use({ "~/gitrepos/JuliaFormatter.vim", ft = "julia" }) -- Julia formatter support

    use({ "kdheepak/gridlabd.vim", ft = "gridlabd" }) -- gridlabd syntax support

    use({ "zah/nim.vim", ft = "nim" }) -- syntax highlighting auto indent for nim in vim

    use({
      "iamcco/markdown-preview.nvim",
      run = "cd app && yarn install",
      cmd = "MarkdownPreview",
      ft = "markdown",
      config = function()
        vim.g.mkdp_auto_start = 0
      end,
    })

    -- use({
    --   "preservim/vim-markdown",
    --   ft = "markdown",
    --   config = function()
    --     vim.g.vim_markdown_frontmatter = true
    --   end,
    -- })

    use({ 'lervag/vimtex' })

    use({
      "vim-pandoc/vim-pandoc-syntax",
      ft = "markdown",
      config = function()
        local augroup = require("kd/utils").augroup
        local autocmd = require("kd/utils").autocmd
        augroup("kdvimpandocsyntax", function()
          autocmd("BufNewFile,BufFilePre,BufRead", "set filetype=markdown.pandoc", { pattern = "*.md" })
        end)
      end,
    })

    use({ "GCBallesteros/jupytext.vim", ft = { "ipynb", "python", "markdown" } })

    use({ "sindrets/diffview.nvim", event = "BufRead" })

    use({ "jbyuki/nabla.nvim", ft = "markdown" }) -- Take your scentific notes in Neovim.

    use({ "jbyuki/venn.nvim", event = "BufRead" }) -- Draw ASCII diagrams in Neovim.

    use({ "Pocco81/HighStr.nvim", config = function()
      local vnoremap = require("kd/utils").vnoremap
      local nnoremap = require("kd/utils").nnoremap
      vnoremap("<leader>h1", ":<c-u>HSHighlight 1<CR>", { label = "Highlight 1" })
      vnoremap("<leader>h2", ":<c-u>HSHighlight 2<CR>", { label = "Highlight 2" })
      vnoremap("<leader>h3", ":<c-u>HSHighlight 3<CR>", { label = "Highlight 3" })
      vnoremap("<leader>h4", ":<c-u>HSHighlight 4<CR>", { label = "Highlight 4" })
      vnoremap("<leader>h5", ":<c-u>HSHighlight 5<CR>", { label = "Highlight 5" })
      vnoremap("<leader>h6", ":<c-u>HSHighlight 6<CR>", { label = "Highlight 6" })
      vnoremap("<leader>h7", ":<c-u>HSHighlight 7<CR>", { label = "Highlight 7" })
      vnoremap("<leader>h8", ":<c-u>HSHighlight 8<CR>", { label = "Highlight 8" })
      vnoremap("<leader>h9", ":<c-u>HSHighlight 9<CR>", { label = "Highlight 9" })
      vnoremap("<leader>h0", ":<c-u>HSRmHighlight<CR>", { label = "Highlight Remove" })
      vnoremap("<leader>hh", ":<c-u>HSRmHighlight rm_all<CR>", { label = "Highlight Remove all" })
      nnoremap("<leader>hh", ":<c-u>HSRmHighlight rm_all<CR>", { label = "Highlight Remove all" })
    end })
  end,
  config = {
    display = { open_fn = require("packer.util").float },
  },
})

return M
