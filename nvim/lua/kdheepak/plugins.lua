M = {}
local V = require("kdheepak/utils")

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  execute("packadd packer.nvim")
end

function M.reload_config()
  require("plenary.reload").reload_module("kdheepak/statusline", true)
  vim.cmd("source ~/.config/nvim/init.lua")
  vim.cmd("source ~/.config/nvim/lua/kdheepak/plugins.lua")
  vim.cmd(":PackerCompile")
  vim.cmd(":PackerClean")
  vim.cmd(":PackerInstall")
end

local packer = require("packer")
local use = packer.use

local load = function(use_table)
  use(use_table)
  -- if type(use_table) == "string" then
  --   use(use_table)
  -- else
  --   local index = use_table[1]:match("^.*()/")
  --   local plugin_name = string.sub(use_table[1], index + 1)
  --   local plugin_file = vim.fn.stdpath("config") .. "/lua/plugins/" .. plugin_name .. ".lua"
  --   if vim.fn.filereadable(plugin_file) then
  --     -- use_table.config = "require('plugins.' .. '" .. plugin_name .. "')"
  --   end
  --   use(use_table)
  -- end
end

packer.reset()
packer.init({ max_jobs = 8 })

packer.startup({
  function()
    -- Packer can manage itself

    load("wbthomason/packer.nvim")

    load({
      "iamcco/markdown-preview.nvim",
      run = "cd app && yarn install",
      cmd = "MarkdownPreview",
      ft = "markdown",
      config = function()
        vim.g.mkdp_auto_start = 0
      end,
    })

    load({
      "windwp/nvim-autopairs",
      after = { "nvim-compe" },
      config = function()
        require("nvim-autopairs").setup()
        require("nvim-autopairs.completion.compe").setup({
          map_cr = true, --  map <CR> on insert mode
          map_complete = true, -- it will auto insert `(` after select function or method item
        })
        require("nvim-treesitter.configs").setup({ autopairs = { enable = true } })
      end,
      event = "BufRead",
    })

    load({
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-treesitter.configs").setup({ autotag = { enable = true } })
      end,
    })

    load({
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        require("nvim-treesitter.configs").setup({ context_commentstring = { enable = true } })
      end,
    })

    load({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = "maintained",
          autotag = { enable = true },
          highlight = { enable = true },
          incremental_selection = { enable = true },
          textobjects = { enable = true },
          indent = { enable = true },
        })
      end,
      requires = { { "nvim-treesitter/playground" } },
    })

    load({
      "nvim-treesitter/nvim-treesitter-textobjects",
      config = function()
        require("nvim-treesitter.configs").setup({
          textobjects = {
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
            textobjects = {
              lsp_interop = {
                enable = true,
                border = "none",
                peek_definition_code = { ["df"] = "@function.outer", ["dF"] = "@class.outer" },
              },
            },
          },
        })
      end,
    })

    load({
      "terrortylor/nvim-comment",
      config = function()
        require("nvim_comment").setup()
      end,
    })

    load({
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
          watch_index = { interval = 1000, follow_files = true },
          current_line_blame = false,
          current_line_blame_delay = 1000,
          current_line_blame_position = "eol",
          sign_priority = 6,
          update_debounce = 100,
          status_formatter = nil, -- load default
          word_diff = false,
          load_internal_diff = true, -- If luajit is present
        })
      end,
    })

    load({
      "neovim/nvim-lspconfig",
      requires = { "jose-elias-alvarez/null-ls.nvim" },
      config = function()
        require("kdheepak/plugins/lspconfig")
      end,
    })

    load({ "kabouzeid/nvim-lspinstall" })

    load("liuchengxu/vista.vim") -- viewer and finder for lsp symbols

    load({
      "kosayoda/nvim-lightbulb",
      event = "BufRead",
      config = function()
        vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
      end,
    })

    load({
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup({})
      end,
    })

    load({
      "ray-x/navigator.lua",
      requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
      config = function()
        require("navigator").setup()
      end,
    })

    load({
      "nvim-lua/lsp-status.nvim",
      config = function()
        require("lsp-status").register_progress()
      end,
    })

    load("RishabhRD/popfix")

    load("RishabhRD/nvim-lsputils")

    load("folke/lsp-colors.nvim")

    load({ "nvim-lua/plenary.nvim" })

    load({ "nvim-lua/popup.nvim" })

    load({ "nanotee/luv-vimdocs" })

    -- load {
    --   'nvim-telescope/telescope.nvim',
    --   requires = { 'nvim-telescope/telescope-fzy-native.nvim' },
    --   -- config = function()
    --   --   require 'kdheepak/telescope'
    --   -- end,
    -- }
    -- load 'tamago324/telescope-openbrowser.nvim'
    -- load 'nvim-telescope/telescope-github.nvim'
    -- load 'gbrlsnchs/telescope-lsp-handlers.nvim'
    -- load 'nvim-telescope/telescope-dap.nvim'

    load("Pocco81/DAPInstall.nvim")

    load({
      "mfussenegger/nvim-dap",
      config = function()
        require("kdheepak/plugins/debug")
      end,
    })

    load("theHamsta/nvim-dap-virtual-text")

    load("mfussenegger/nvim-dap-python")

    load({
      "folke/which-key.nvim",
      config = function()
        require("kdheepak/plugins/which-key")
      end,
    })

    load({ "junegunn/fzf", run = ":call fzf#install()" })

    load({ "junegunn/fzf.vim" })

    load({
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

    load({
      "~/gitrepos/mergetool.nvim",
      config = function()
        require("mergetool").setup({})
      end,
    })

    load({
      "~/gitrepos/moonshine.nvim",
      config = function()
        require("moonshine")
      end,
    })

    load({
      "mjlbach/babelfish.nvim",
      config = function()
        if pcall(require, "nvim-treesitter.parsers") then
          local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

          parser_config.markdown = {
            install_info = {
              url = "https://github.com/ikatyang/tree-sitter-markdown",
              files = { "src/parser.c", "src/scanner.cc" },
            },
          }
        end
      end,
    })

    load({
      "~/gitrepos/tabline.nvim",
      config = function()
        require("tabline").setup({ options = { always_show_tabline = true } })
      end,
    })

    load({ "wsdjeg/luarefvim" })

    load({
      "samoshkin/vim-mergetool",
      config = function()
        vim.g.mergetool_layout = "mr"
        vim.g.mergetool_prefer_revision = "local"
      end,
    })

    load({ "moll/vim-bbye" })

    load({ "aymericbeaumet/vim-symlink" })

    load({
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
        require("trouble").setup({
          -- your configuration comes here
          -- or leave it empty to load the default settings
          -- refer to the configuration section below
        })
      end,
    })

    load({ "mattn/emmet-vim", ft = { "html", "vue", "css" } })

    load({
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
        require("lspkind").init({
          with_text = true,
          preset = "default",
        })
        -- Key mapping
        local function map(mode, key, result, opts)
          opts = vim.tbl_extend("keep", opts or {}, {
            noremap = true,
            silent = true,
            expr = false,
          })
          vim.api.nvim_set_keymap(mode, key, result, opts)
        end

        local nvim_compe = require("compe")
        nvim_compe.setup({
          enabled = true,
          autocomplete = true,
          documentation = true,
          debug = false,
          min_length = 1,
          preselect = "disable",
          throttle_time = 80,
          source_timeout = 200,
          incomplete_delay = 400,
          allow_prefix_unmatch = false,
          source = {
            path = true,
            calc = true,
            spell = true,
            vsnip = true,
            emoji = false,
            buffer = true,
            nvim_lsp = true,
            nvim_lua = true,
            latex_symbols = false,
          },
        })

        local t = function(str)
          return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        local luasnip = require("luasnip")

        local check_back_space = function()
          local col = vim.fn.col(".") - 1
          if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            return true
          else
            return false
          end
        end

        _G.tab_complete = function()
          if vim.fn.pumvisible() == 1 then
            return t("<C-n>")
          elseif luasnip.expand_or_jumpable() then
            return t("<Plug>luasnip-expand-or-jump")
          elseif vim.fn["vsnip#available"](1) == 1 then
            return t("<Plug>(vsnip-expand-or-jump)")
          elseif check_back_space() then
            return t("<Tab>")
          else
            return vim.fn["compe#complete"]()
          end
        end

        _G.s_tab_complete = function()
          if vim.fn.pumvisible() == 1 then
            return t("<C-p>")
          elseif luasnip.jumpable(-1) then
            return t("<Plug>luasnip-jump-prev")
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            return t("<Plug>(vsnip-jump-prev)")
          else
            return t("<S-Tab>")
          end
        end

        _G.enter_complete = function()
          if luasnip.choice_active() then
            return t("<Plug>luasnip-next-choice")
          end
          return vim.fn["compe#confirm"](t("<CR>"))
        end

        map("i", "<CR>", "v:lua.enter_complete()", { expr = true })

        map("i", "<Tab>", "v:lua.tab_complete()", { noremap = false, expr = true })
        map("s", "<Tab>", "v:lua.tab_complete()", { noremap = false, expr = true })

        map("i", "<S-Tab>", "v:lua.s_tab_complete()", { noremap = false, expr = true })
        map("s", "<S-Tab>", "v:lua.s_tab_complete()", { noremap = false, expr = true })

        map("i", "<C-u>", "compe#scroll({ 'delta': +4 })", { noremap = false, expr = true })
        map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", { noremap = false, expr = true })

        vim.o.completeopt = "menuone,noselect"
      end,
    })

    -- load { 'tversteeg/registers.nvim', event = 'BufRead' } -- Show register content when you try to access it in NeoVim.

    load("junegunn/vim-peekaboo")

    load("Yilin-Yang/vim-markbar")

    load("kshenoy/vim-signature")

    load({ "ggandor/lightspeed.nvim", event = "BufRead" }) -- load s and S to search

    load({
      "mcchrish/nnn.vim",
      config = function()
        vim.g["nnn#set_default_mappings"] = false
      end,
    })

    load("kevinhwang91/nvim-bqf") -- The goal of nvim-bqf is to make Neovim's quickfix window better.

    load({ "tyru/open-browser.vim" }) -- opens url in browser

    load({ "tyru/open-browser-github.vim", event = "BufRead" }) -- opens github repo or github issue in browser

    load({
      "rhysd/git-messenger.vim",
      event = "BufRead",
      config = function()
        vim.g.git_messenger_no_default_mappings = true
      end,
    }) -- reveal a hidden message from git under the cursor quickly

    load({ "tpope/vim-fugitive" }) -- vim plugin for Git that is so awesome, it should be illegal

    load({ "rbong/vim-flog" })

    load("junegunn/gv.vim")

    load({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })

    load({ "tpope/vim-rhubarb", event = "BufRead" }) -- vim plugin for github

    load({ "~/gitrepos/lazygit.nvim", event = "BufRead" }) -- lazygit

    load({
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
    })

    load({ "euclidianAce/BetterLua.vim" })

    load({ "bfredl/nvim-luadev" })

    load("itchyny/vim-cursorword") -- underlines the word under the cursor

    load({
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
    })

    load({ "godlygeek/tabular", event = "BufRead" }) -- line up text

    load({ "tpope/vim-unimpaired", event = "BufRead" }) -- complementary pairs of mappings

    load({ "tpope/vim-abolish", event = "BufRead" }) -- convert camel to snake

    load({ "tpope/vim-surround", event = "BufRead" }) -- all about surroundings: parentheses, brackets, quotes, XML tags, and more.

    load({ "tpope/vim-repeat", event = "BufRead" }) -- repeat.vim remaps . in a way that plugins can tap into it.

    load({ "vim-utils/vim-vertical-move", event = "BufRead" })

    load({
      "rmagatti/auto-session",
      config = function()
        local opts = { auto_session_enabled = false, auto_save_enabled = false, auto_restore_enabled = false }
        require("auto-session").setup(opts)
      end,
    })

    load({ "tpope/vim-jdaddy", event = "BufRead" }) -- mappings for working with json in vim

    load({ "tpope/vim-speeddating", event = "BufRead" }) -- Tools for working with dates

    load({ "tpope/vim-eunuch", event = "BufRead" }) -- vim sugar for UNIX shell commands like :Rename

    load({ "tpope/vim-sleuth", event = "BufRead" }) -- This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file

    load({ "inkarkat/vim-visualrepeat", event = "BufRead" }) -- repetition of vim built-in normal mode commands via . for visual mode

    load({ "Konfekt/vim-CtrlXA", event = "BufRead" }) -- Increment and decrement and toggle keywords

    load({ "dhruvasagar/vim-zoom" }) -- toggle zoom of current window within the current tab

    load({ "kana/vim-niceblock" }) -- makes blockwise Visual mode more loadful and intuitive

    load({ "mbbill/undotree", event = "BufRead" }) -- visualizes undo history and makes it easier to browse and switch between different undo branches

    load({ "reedes/vim-wordy" }) -- uncover usage problems in your writing

    load("farmergreg/vim-lastplace") -- intelligently reopen files at your last edit position

    load({
      "ntpeters/vim-better-whitespace",
      event = "BufRead",
      config = function()
        local utils = require("kdheepak/utils")
        local augroup = utils.augroup
        local autocmd = utils.autocmd
        augroup("StripWhitespace", function()
          autocmd("BufEnter", "*", "EnableStripWhitespaceOnSave")
        end)
        vim.g.strip_whitespace_confirm = 0
        vim.g.strip_only_modified_lines = 1
      end,
    }) -- caloads all trailing whitespace characters to be highlighted

    load({ "dhruvasagar/vim-table-mode", event = "BufRead" }) -- automatic table creator & formatter allowing one to create neat tables as you type

    load({ "joom/latex-unicoder.vim", event = "BufRead" }) -- a plugin to type Unicode chars in Vim, using their LaTeX names

    load("editorconfig/editorconfig-vim") -- editorconfig plugin for vim

    load({ "osyo-manga/vim-anzu", event = "BufRead" }) -- show total number of matches and current match number

    load({ "jeffkreeftmeijer/vim-numbertoggle", event = "BufRead" })

    load({ "haya14busa/vim-asterisk", event = "BufRead" }) -- asterisk.vim provides improved search * motions

    load({ "segeljakt/vim-isotope", event = "BufRead" }) -- insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,

    load({ "sedm0784/vim-you-autocorrect", event = "BufRead" }) -- Automatic autocorrect

    load({ "inkarkat/vim-ingo-library", event = "BufRead" }) -- Spellcheck dependency

    load({ "inkarkat/vim-spellcheck", event = "BufRead" }) -- Add vim spell check errors to quicklist

    -- load 'beloglazov/vim-online-thesaurus'
    load({ "takac/vim-hardtime", event = "BufRead" }) -- vim hardtime

    load({ "chrisbra/unicode.vim", event = "BufRead" }) -- vim unicode helper

    load({ "posva/vim-vue", ft = { "vue" } })

    load({ "Vimjas/vim-python-pep8-indent", ft = { "python" } }) -- a nicer Python indentation style for vim

    load({ "rust-lang/rust.vim", ft = { "rust" } }) -- rust file detection, syntax highlighting, formatting, Syntastic integration, and more

    load("simrat39/rust-tools.nvim")

    load({ "JuliaEditorSupport/julia-vim" }) -- julia support for vim

    load({ "kdheepak/gridlabd.vim", ft = "gridlabd" }) -- gridlabd syntax support

    load({ "zah/nim.vim", ft = "nim" }) -- syntax highlighting auto indent for nim in vim

    load({ "gpanders/vim-medieval", ft = "markdown" }) -- evaluate markdown code blocks within vim

    load({ "plasticboy/vim-markdown", ft = "markdown" }) -- Syntax highlighting, matching rules and mappings for the original Markdown and extensions.

    load({ "kana/vim-textobj-loadr", event = "BufRead" })

    load({ "kana/vim-textobj-line", event = "BufRead" })

    load({ "GCBallesteros/vim-textobj-hydrogen", ft = { "ipynb", "python", "markdown" } })

    load({ "GCBallesteros/jupytext.vim", ft = { "ipynb", "python", "markdown" } })

    load({ "bfredl/nvim-ipy", ft = "python" })

    load({ "~/gitrepos/JuliaFormatter.vim" }) -- formatter for Julia

    load({ "sindrets/diffview.nvim" })

    load({ "christoomey/vim-conflicted" })

    load({ "jbyuki/one-small-step-for-vimkind", ft = "lua" })

    load({ "npxbr/glow.nvim", branch = "main", run = ":GlowInstall" })

    load({ "rust-lang/vscode-rust", ft = "rust" })

    load({ "jbyuki/nabla.nvim", ft = "markdown" }) -- Take your scentific notes in Neovim.

    load({ "shadmansaleh/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

    load({ "jbyuki/venn.nvim", event = "BufRead" }) -- Draw ASCII diagrams in Neovim.

    load({
      "pwntester/octo.nvim",
      config = function()
        require("octo").setup()
      end,
      event = "BufRead",
    })

    load({
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
    })

    -- colorschemes
    load({
      "kdheepak/github-nvim-theme",
      branch = "fix-bar-bar-colors",
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
    })

    load({
      "jghaloadr/mkdir.nvim",
    })

    load({
      "numToStr/Navigator.nvim",
      config = function()
        require("Navigator").setup()
      end,
    })

    load("famiu/nvim-reload")
  end,
  config = { display = { open_fn = require("packer.util").float } },
})

return M
