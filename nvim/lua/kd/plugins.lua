M = {}

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  execute("packadd packer.nvim")
end

function M.reload_config()
  require("plenary.reload").reload_module("kd/plugins/lualine", true)
  vim.cmd("source ~/.config/nvim/init.lua")
  vim.cmd("source ~/.config/nvim/lua/kd/plugins.lua")
  vim.cmd(":PackerCompile")
  vim.cmd(":PackerClean")
  vim.cmd(":PackerInstall")
end

local packer = require("packer")
local use = packer.use

packer.reset()
packer.init({ max_jobs = 16 })

packer.startup({
  function()
    -- Packer can manage itself

    use("wbthomason/packer.nvim")

    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = "maintained",
          autotag = { enable = true },
          highlight = { enable = true },
          incremental_selection = { enable = true },
          indent = { enable = true },
          refactor = {
            highlight_definitions = { enable = true },
            highlight_current_scope = { enable = false },
            smart_rename = {
              enable = true,
              keymaps = {
                smart_rename = "grr",
              },
            },
            navigation = {
              enable = true,
              keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
              },
            },
          },
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
          autopairs = { enable = true },
          context_commentstring = { enable = true },
        })
      end,
      requires = {
        { "nvim-treesitter/playground" },
        { "nvim-treesitter/nvim-treesitter-refactor" },
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        {
          "windwp/nvim-autopairs",
          after = { "nvim-compe" },
          config = function()
            require("nvim-autopairs").setup()
            require("nvim-autopairs.completion.compe").setup({
              map_cr = true, --  map <CR> on insert mode
              map_complete = true, -- it will auto insert `(` after select function or method item
            })
          end,
        },
        { "windwp/nvim-ts-autotag" },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
      },
    })

    use({
      "terrortylor/nvim-comment",
      config = function()
        require("nvim_comment").setup()
      end,
      event = "BufRead",
    })

    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("gitsigns").setup({
          signs = {
            add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
            change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
            delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
            topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
            changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
          },
          numhl = false,
          linehl = false,
          keymaps = {
            -- Default keymap options
            noremap = true,

            ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
            ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
            ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
          },
        })
      end,
      event = "BufRead",
    })

    use({
      "neovim/nvim-lspconfig",
      requires = {
        { "jose-elias-alvarez/null-ls.nvim" },
        { "RishabhRD/popfix" },
        { "RishabhRD/nvim-lsputils" },
        {
          "nvim-lua/lsp-status.nvim",
          config = function()
            require("lsp-status").register_progress()
          end,
        },
        { "folke/lsp-colors.nvim" },
        { "simrat39/rust-tools.nvim" },
        {
          "ray-x/lsp_signature.nvim",
          config = function()
            require("lsp_signature").setup({})
          end,
        },
        {
          "ray-x/navigator.lua",
          requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
          config = function()
            -- require("navigator").setup()
          end,
        },
      },
      config = function()
        require("kd/plugins/nvim-lspconfig")
      end,
    })

    use({ "kabouzeid/nvim-lspinstall", event = "BufRead" })

    use({
      "kosayoda/nvim-lightbulb",
      config = function()
        local augroup = require("kd/utils").augroup
        local autocmd = require("kd/utils").autocmd
        augroup("KDLightbulb", function()
          autocmd("CursorHold,CursorHoldI", "*", require("nvim-lightbulb").update_lightbulb)
        end)
      end,
      event = "BufRead",
    })

    use({ "nvim-lua/plenary.nvim" })

    use({ "nvim-lua/popup.nvim" })

    use({ "nanotee/luv-vimdocs", event = "BufRead" })

    use({ "Pocco81/DAPInstall.nvim", event = "BufRead" })

    use({
      "mfussenegger/nvim-dap",
      requires = { { "theHamsta/nvim-dap-virtual-text", "mfussenegger/nvim-dap-python" } },
      config = function()
        require("kd/plugins/debug")
      end,
    })

    use({
      "folke/which-key.nvim",
      config = function()
        require("kd/plugins/which-key")
      end,
    })

    use({ "junegunn/fzf", run = ":call fzf#install()" })

    use({ "junegunn/fzf.vim" })

    use({
      "ibhagwan/fzf-lua",
      requires = {
        "kyazdani42/nvim-web-devicons", -- optional for icons
        "vijaymarupudi/nvim-fzf",
      },
      config = function()
        require("fzf-lua").setup({
          previewers = { bat = { cmd = "bat", args = "", config = "~/.config/bat/config" } },
          async_or_timeout = 3000,
        })
      end,
    })

    use({
      "~/gitrepos/mergetool.nvim",
      config = function()
        require("mergetool").setup({})
      end,
    })

    use({
      "~/gitrepos/moonshine.nvim",
      config = function()
        require("moonshine")
      end,
    })

    use({
      "~/gitrepos/tabline.nvim",
      config = function()
        require("tabline").setup({ options = { always_show_tabline = true } })
      end,
    })

    use({ "wsdjeg/luarefvim" })

    use({
      "samoshkin/vim-mergetool",
      config = function()
        vim.g.mergetool_layout = "mr"
        vim.g.mergetool_prefer_revision = "local"
      end,
    })

    use({ "moll/vim-bbye" })

    use({ "aymericbeaumet/vim-symlink" })

    use({
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup({})
      end,
    })

    use({ "mattn/emmet-vim", ft = { "html", "vue", "css" } })

    use({
      "hrsh7th/nvim-compe",
      requires = {
        { "GoldsteinE/compe-latex-symbols" },
        { "L3MON4D3/LuaSnip" },
        { "onsails/lspkind-nvim" },
        { "hrsh7th/vim-vsnip" },
        { "hrsh7th/vim-vsnip-integ" },
        { "rafamadriz/friendly-snippets" },
      },
      config = function()
        require("kd/plugins/nvim-compe")
      end,
    })

    use({ "junegunn/vim-peekaboo", event = "BufRead" })

    use({ "Yilin-Yang/vim-markbar", event = "BufRead" })

    use({ "kshenoy/vim-signature", event = "BufRead" })

    use({ "ggandor/lightspeed.nvim", event = "BufRead" }) -- load s and S to search

    use("kevinhwang91/nvim-bqf") -- The goal of nvim-bqf is to make Neovim's quickfix window better.
    use({
      "kevinhwang91/rnvimr",
      config = function()
        vim.g.rnvimr_enable_ex = 1
        vim.g.rnvimr_enable_picker = 1
      end,
    })

    use({ "tyru/open-browser-github.vim", requires = { { "tyru/open-browser.vim" } }, event = "BufRead" }) -- opens github repo or github issue in browser

    use({
      "rhysd/git-messenger.vim",
      config = function()
        vim.g.git_messenger_no_default_mappings = true
      end,
      event = "BufRead",
    }) -- reveal a hidden message from git under the cursor quickly

    use({ "tpope/vim-fugitive", event = "BufRead" }) -- vim plugin for Git that is so awesome, it should be illegal

    use({ "rbong/vim-flog", event = "BufRead" })

    use({ "junegunn/gv.vim", event = "BufRead" })

    use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim", event = "BufRead" })

    use({ "tpope/vim-rhubarb", event = "BufRead" }) -- vim plugin for github

    use({ "~/gitrepos/lazygit.nvim", cmd = "LazyGit" }) -- lazygit

    use({
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
      event = "BufRead",
    })

    use({ "euclidianAce/BetterLua.vim", event = "BufRead" })

    use({ "bfredl/nvim-luadev", event = "BufRead" })

    use({ "itchyny/vim-cursorword", event = "BufRead" }) -- underlines the word under the cursor

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

    use({ "godlygeek/tabular", event = "BufRead" }) -- line up text

    use({ "tpope/vim-unimpaired", event = "BufRead" }) -- complementary pairs of mappings

    use({ "tpope/vim-abolish", event = "BufRead" }) -- convert camel to snake

    use({ "tpope/vim-surround", event = "BufRead" }) -- all about surroundings: parentheses, brackets, quotes, XML tags, and more.

    use({ "tpope/vim-repeat", event = "BufRead" }) -- repeat.vim remaps . in a way that plugins can tap into it.

    use({ "vim-utils/vim-vertical-move", event = "BufRead" })

    use({
      "rmagatti/auto-session",
      config = function()
        local opts = { auto_session_enabled = false, auto_save_enabled = false, auto_restore_enabled = false }
        require("auto-session").setup(opts)
      end,
    })

    use({ "tpope/vim-jdaddy", event = "BufRead" }) -- mappings for working with json in vim

    use({ "tpope/vim-speeddating", event = "BufRead" }) -- Tools for working with dates

    use({ "tpope/vim-eunuch", event = "BufRead" }) -- vim sugar for UNIX shell commands like :Rename

    use({ "tpope/vim-sleuth", event = "BufRead" }) -- This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file

    use({ "inkarkat/vim-visualrepeat", event = "BufRead" }) -- repetition of vim built-in normal mode commands via . for visual mode

    use({ "Konfekt/vim-CtrlXA", event = "BufRead" }) -- Increment and decrement and toggle keywords

    use({ "dhruvasagar/vim-zoom", event = "BufRead" }) -- toggle zoom of current window within the current tab

    use({ "kana/vim-niceblock", event = "BufRead" }) -- makes blockwise Visual mode more loadful and intuitive

    use({ "mbbill/undotree", event = "BufRead" }) -- visualizes undo history and makes it easier to browse and switch between different undo branches

    use({ "reedes/vim-wordy", event = "BufRead" }) -- uncover usage problems in your writing

    use("farmergreg/vim-lastplace") -- intelligently reopen files at your last edit position

    use({
      "ntpeters/vim-better-whitespace",
      config = function()
        local augroup = require("kd/utils").augroup
        local autocmd = require("kd/utils").autocmd
        augroup("StripWhitespace", function()
          autocmd("BufEnter", "*", "EnableStripWhitespaceOnSave")
        end)
        vim.g.strip_whitespace_confirm = 0
        vim.g.strip_only_modified_lines = 1
      end,
      event = "BufRead",
    }) -- caloads all trailing whitespace characters to be highlighted

    use({ "dhruvasagar/vim-table-mode", event = "BufRead" }) -- automatic table creator & formatter allowing one to create neat tables as you type

    use("editorconfig/editorconfig-vim") -- editorconfig plugin for vim

    use({ "osyo-manga/vim-anzu", event = "BufRead" }) -- show total number of matches and current match number

    use({
      "haya14busa/vim-asterisk",
      event = "BufRead",
      config = function()
        vim.g["asterisk#keeppos"] = 1
      end,
    }) -- asterisk.vim provides improved search * motions

    use({ "segeljakt/vim-isotope", event = "BufRead" }) -- insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,

    use({ "sedm0784/vim-you-autocorrect", event = "BufRead" }) -- Automatic autocorrect

    use({ "inkarkat/vim-ingo-library", event = "BufRead" }) -- Spellcheck dependency

    use({ "inkarkat/vim-spellcheck", event = "BufRead" }) -- Add vim spell check errors to quicklist

    -- load 'beloglazov/vim-online-thesaurus'
    use({ "takac/vim-hardtime", event = "BufRead" }) -- vim hardtime

    use({ "chrisbra/unicode.vim", event = "BufRead" }) -- vim unicode helper

    use({ "posva/vim-vue", ft = { "vue" } })

    use({ "Vimjas/vim-python-pep8-indent", ft = { "python" } }) -- a nicer Python indentation style for vim

    use({ "rust-lang/rust.vim", ft = { "rust" } }) -- rust file detection, syntax highlighting, formatting, Syntastic integration, and more

    use({ "JuliaEditorSupport/julia-vim" }) -- julia support for vim

    use({ "kdheepak/gridlabd.vim", ft = "gridlabd" }) -- gridlabd syntax support

    use({ "zah/nim.vim", ft = "nim" }) -- syntax highlighting auto indent for nim in vim

    use({
      "gpanders/vim-medieval",
      ft = "markdown",
      config = function()
        vim.g.medieval_langs = { "python=python3", "julia", "sh", "console=bash" }
      end,
    }) -- evaluate markdown code blocks within vim

    use({
      "iamcco/markdown-preview.nvim",
      run = "cd app && yarn install",
      cmd = "MarkdownPreview",
      ft = "markdown",
      config = function()
        vim.g.mkdp_auto_start = 0
      end,
    })

    use({
      "plasticboy/vim-markdown",
      ft = "markdown",
      config = function()
        vim.g.vim_markdown_emphasis_multiline = false
        vim.g.vim_markdown_folding_disabled = true
        vim.g.tex_conceal = ""
        vim.g.vim_markdown_math = true
        vim.g.vim_markdown_frontmatter = true
        vim.g.vim_markdown_strikethrough = true
        vim.g.vim_markdown_fenced_languages = { "julia=jl", "python=py" }
        vim.g.latex_to_unicode_auto = true
        vim.g.latex_to_unicode_tab = false
        vim.g.latex_to_unicode_cmd_mapping = { "<C-j>" }
      end,
    }) -- Syntax highlighting, matching rules and mappings for the original Markdown and extensions.

    use({ "kana/vim-textobj-user", event = "BufRead" })

    use({ "kana/vim-textobj-line", event = "BufRead" })

    use({ "GCBallesteros/vim-textobj-hydrogen", ft = { "ipynb", "python", "markdown" } })

    use({ "GCBallesteros/jupytext.vim", ft = { "ipynb", "python", "markdown" } })

    use({ "bfredl/nvim-ipy", ft = "python" })

    use({ "~/gitrepos/JuliaFormatter.vim", ft = "Julia" }) -- formatter for Julia

    use({ "sindrets/diffview.nvim", event = "BufRead" })

    use({ "jbyuki/one-small-step-for-vimkind", ft = "lua" })

    use({ "npxbr/glow.nvim", branch = "main", run = ":GlowInstall", ft = "markdown" })

    use({ "rust-lang/vscode-rust", ft = "rust" })

    use({ "jbyuki/nabla.nvim", ft = "markdown" }) -- Take your scentific notes in Neovim.

    use({
      "shadmansaleh/lualine.nvim",
      config = function()
        require("kd/plugins/lualine")
      end,
      requires = { { "kyazdani42/nvim-web-devicons", opt = true }, { "liuchengxu/vista.vim" } },
    })

    use({ "jbyuki/venn.nvim", event = "BufRead" }) -- Draw ASCII diagrams in Neovim.

    use({
      "pwntester/octo.nvim",
      config = function()
        require("octo").setup()
      end,
      event = "BufRead",
    })

    use({
      "akinsho/nvim-toggleterm.lua",
      config = function()
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

    -- colorschemes
    use({
      "projekt0n/github-nvim-theme",
      config = function()
        vim.g.termguicolors = true
        require("github-theme").setup({
          themeStyle = "light",
          keywordStyle = "NONE",
          functionStyle = "NONE",
          variableStyle = "NONE",
          commentStyle = "italic",
          colors = { lsp = { referenceText = nil } },
        })
      end,
      event = "VimEnter",
    })

    use({
      "jghauser/mkdir.nvim",
      event = "BufRead",
    })

    use({
      "numToStr/Navigator.nvim",
      config = function()
        require("Navigator").setup()
      end,
      event = "BufRead",
    })

    use({ "famiu/nvim-reload" })
  end,
  config = { display = { open_fn = require("packer.util").float } },
})

return M
