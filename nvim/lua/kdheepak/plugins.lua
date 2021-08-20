M = {}
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
  execute("packadd packer.nvim")
end

function M.reload_config()
  vim.cmd("source ~/.config/nvim/init.lua")
  vim.cmd("source ~/.config/nvim/lua/kdheepak/plugins.lua")
  vim.cmd(":PackerCompile")
  vim.cmd(":PackerClean")
  vim.cmd(":PackerInstall")
end

-- Need to replace this once lua api has vim modes
vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua lua require'kdheepak/plugins'.reload_config()
  augroup end
]],
  false
)

local inspected_buffers = {}
-- this function is called b4 a buffer is opened, so we need to manually open the file and count the lines.
function limit_by_line_count(max_lines)
  local fname = vim.fn.expand("%:p")
  local cache = inspected_buffers[fname]
  if cache ~= nil then
    return cache
  end

  max_lines = max_lines or 1000
  local lines = 0
  for _ in io.lines(fname) do
    lines = lines + 1
    if lines > max_lines then
      break
    end
  end
  inspected_buffers[fname] = (lines <= max_lines)
  return inspected_buffers[fname]
end

local packer = require("packer")
local use = packer.use

packer.reset()
packer.init({ max_jobs = 8 })

packer.startup({
  function()
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    use({ "iamcco/markdown-preview.nvim", run = "cd app && yarn install", cmd = "MarkdownPreview", ft = "markdown" })

    -- use {
    --   'windwp/nvim-autopairs',
    --   after = { 'nvim-compe' },
    --   config = function()
    --     require('nvim-autopairs').setup()
    --     require('nvim-autopairs.completion.compe').setup({
    --       map_cr = true, --  map <CR> on insert mode
    --       map_complete = true, -- it will auto insert `(` after select function or method item
    --     })
    --     require('nvim-treesitter.configs').setup { autopairs = { enable = true } }
    --   end,
    --   event = 'BufRead',
    -- }
    use({
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-treesitter.configs").setup({ autotag = { enable = true } })
      end,
    })
    use({
      "JoosepAlviste/nvim-ts-context-commentstring",
      config = function()
        require("nvim-treesitter.configs").setup({ context_commentstring = { enable = true } })
      end,
    })
    use({
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
    use({
      "nvim-treesitter/nvim-treesitter-textobjects",
      config = function()
        require("nvim-treesitter.configs").setup({
          textobjects = {
            select = {
              enable = true,
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
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

    use({
      "terrortylor/nvim-comment",
      config = function()
        require("nvim_comment").setup()
      end,
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
          watch_index = { interval = 1000, follow_files = true },
          current_line_blame = false,
          current_line_blame_delay = 1000,
          current_line_blame_position = "eol",
          sign_priority = 6,
          update_debounce = 100,
          status_formatter = nil, -- Use default
          word_diff = false,
          use_internal_diff = true, -- If luajit is present
        })
      end,
    })

    use({
      "neovim/nvim-lspconfig",
      requires = { "jose-elias-alvarez/null-ls.nvim" },
      config = function()
        require("kdheepak/lspconfig")
      end,
    })

    use({ "kabouzeid/nvim-lspinstall" })

    use("liuchengxu/vista.vim") -- viewer and finder for lsp symbols

    use({
      "kosayoda/nvim-lightbulb",
      event = "BufRead",
      config = function()
        vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
      end,
    })

    use({
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup({})
      end,
    })
    use({
      "ray-x/navigator.lua",
      requires = { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
      config = function()
        require("navigator").setup()
      end,
    })

    use({
      "nvim-lua/lsp-status.nvim",
      config = function()
        require("lsp-status").register_progress()
      end,
    })
    use("RishabhRD/popfix")
    use("RishabhRD/nvim-lsputils")

    use("folke/lsp-colors.nvim")

    --     use {
    --       'gelguy/wilder.nvim',
    --       config = function()
    --         vim.cmd [[
    --               call wilder#enable_cmdline_enter()
    --               set wildcharm=<Tab>
    --               cmap <expr> <Tab> wilder#in_context() ? wilder#next() : "\<Tab>"
    --               cmap <expr> <S-Tab> wilder#in_context() ? wilder#previous() : "\<S-Tab>"
    --
    --               " only / and ? are enabled by default
    --               call wilder#set_option('modes', ['/', '?', ':'])
    --             ]]
    --       end,
    --     }
    --
    use({ "nvim-lua/plenary.nvim" })
    use({ "nvim-lua/popup.nvim" })
    use({ "nanotee/luv-vimdocs" })
    -- use {
    --   'nvim-telescope/telescope.nvim',
    --   requires = { 'nvim-telescope/telescope-fzy-native.nvim' },
    --   -- config = function()
    --   --   require 'kdheepak/telescope'
    --   -- end,
    -- }
    -- use 'tamago324/telescope-openbrowser.nvim'
    -- use 'nvim-telescope/telescope-github.nvim'
    -- use 'gbrlsnchs/telescope-lsp-handlers.nvim'
    -- use 'nvim-telescope/telescope-dap.nvim'

    use("Pocco81/DAPInstall.nvim")
    use({
      "mfussenegger/nvim-dap",
      config = function()
        require("kdheepak/debug")
      end,
    })
    use("theHamsta/nvim-dap-virtual-text")
    use("mfussenegger/nvim-dap-python")

    use({
      "folke/which-key.nvim",
      config = function()
        require("kdheepak/which-key")
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
          fzf_args = "--color=dark",
          previewers = { bat = { cmd = "bat", args = "", config = "~/.config/bat/config" } },
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

    use("folke/trouble.nvim")

    use({ "mattn/emmet-vim", ft = { "html", "vue", "css" } })

    -- Snippets
    use({
      "hrsh7th/nvim-compe",
      requires = {
        { "GoldsteinE/compe-latex-symbols" },
        { "L3MON4D3/LuaSnip" },
        { "onsails/lspkind-nvim" },
      },
      config = function()
        require("lspkind").init({
          with_text = true,
          preset = "default",
        })
        -- Key mapping
        function map(mode, key, result, opts)
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
          documentation = false,
          debug = false,
          min_length = 1,
          preselect = "always",
          throttle_time = 80,
          source_timeout = 200,
          incomplete_delay = 400,
          allow_prefix_unmatch = false,
          source = {
            path = true,
            calc = true,
            spell = true,
            vsnip = true,
            emoji = true,
            buffer = true,
            nvim_lsp = true,
            nvim_lua = true,
            latex_symbols = true,
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
      end,
    })

    -- use { 'tversteeg/registers.nvim', event = 'BufRead' } -- Show register content when you try to access it in NeoVim.
    use("junegunn/vim-peekaboo")
    use("Yilin-Yang/vim-markbar")
    use("kshenoy/vim-signature")

    use({ "ggandor/lightspeed.nvim", event = "BufRead" }) -- use s and S to search

    use({
      "kyazdani42/nvim-tree.lua",
      config = function()
        vim.g.nvim_tree_icons = {
          default = "",
          symlink = "",
          git = { unstaged = "", staged = "✓", unmerged = "", renamed = "➜", untracked = "" },
          folder = { default = "", open = "", symlink = "" },
        }
        vim.g.nvim_tree_auto_open = 0
        vim.g.nvim_tree_auto_close = 0
        vim.g.nvim_tree_quit_on_open = 0
        vim.g.nvim_tree_indent_markers = 1
        vim.g.nvim_tree_highlight_opened_files = 1
        vim.g.nvim_tree_disable_netrw = 1
        vim.g.nvim_tree_follow = 1
      end,
    })
    use("kevinhwang91/nvim-bqf") -- The goal of nvim-bqf is to make Neovim's quickfix window better.
    use({ "tyru/open-browser.vim" }) -- opens url in browser
    use({ "tyru/open-browser-github.vim", event = "BufRead" }) -- opens github repo or github issue in browser
    use({
      "rhysd/git-messenger.vim",
      event = "BufRead",
      config = function()
        vim.g.git_messenger_no_default_mappings = true
      end,
    }) -- reveal a hidden message from git under the cursor quickly
    use({ "tpope/vim-fugitive" }) -- vim plugin for Git that is so awesome, it should be illegal
    use({ "rbong/vim-flog" })
    use("junegunn/gv.vim")
    use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
    use({ "tpope/vim-rhubarb", event = "BufRead" }) -- vim plugin for github
    use({ "~/gitrepos/lazygit.nvim", event = "BufRead" }) -- lazygit
    --  use 'bkad/CamelCaseMotion' -- motions for inside camel case
    use({
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
    })
    -- use {
    --   'RRethy/vim-hexokinase',
    --   run = 'make hexokinase',
    --   config = function()
    --     vim.g.Hexokinase_highlighters = { 'backgroundfull' }
    --     vim.g.Hexokinase_optInPatterns = { 'full_hex', 'triple_hex', 'rgb', 'rgba', 'hsl', 'hsla' }
    --   end,
    -- }
    use({ "euclidianAce/BetterLua.vim" })
    use({ "bfredl/nvim-luadev" })
    use({
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end,
    })
    use("itchyny/vim-cursorword") -- underlines the word under the cursor
    -- use 'yamatsum/nvim-cursorline'
    -- use { 'RRethy/vim-illuminate' }
    --  use 'junegunn/vim-easy-align' -- helps alignment
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
    -- use 'tpope/vim-tbone'                                                                                                                            -- basic tmux support for vim
    use({ "tpope/vim-jdaddy", event = "BufRead" }) -- mappings for working with json in vim
    -- use 'tpope/vim-obsession'                                                                                                                        -- no hassle vim sessions
    use({ "tpope/vim-speeddating", event = "BufRead" }) -- Tools for working with dates
    use({ "tpope/vim-eunuch", event = "BufRead" }) -- vim sugar for UNIX shell commands like :Rename
    use({ "tpope/vim-sleuth", event = "BufRead" }) -- This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
    use({ "inkarkat/vim-visualrepeat", event = "BufRead" }) -- repetition of vim built-in normal mode commands via . for visual mode
    use({ "Konfekt/vim-CtrlXA", event = "BufRead" }) -- Increment and decrement and toggle keywords
    use({ "dhruvasagar/vim-zoom" }) -- toggle zoom of current window within the current tab
    use({ "kana/vim-niceblock" }) -- makes blockwise Visual mode more useful and intuitive
    use({ "mbbill/undotree", event = "BufRead" }) -- visualizes undo history and makes it easier to browse and switch between different undo branches
    use({ "reedes/vim-wordy" }) -- uncover usage problems in your writing
    use("farmergreg/vim-lastplace") -- intelligently reopen files at your last edit position
    use({
      "ntpeters/vim-better-whitespace",
      event = "BufRead",
      config = function()
        vim.cmd([[
          augroup StripWhitespace
            autocmd!
            autocmd BufEnter * EnableStripWhitespaceOnSave
          augroup END
        ]])
      end,
    }) -- causes all trailing whitespace characters to be highlighted
    use({ "dhruvasagar/vim-table-mode", event = "BufRead" }) -- automatic table creator & formatter allowing one to create neat tables as you type
    use({ "joom/latex-unicoder.vim", event = "BufRead" }) -- a plugin to type Unicode chars in Vim, using their LaTeX names
    use("editorconfig/editorconfig-vim") -- editorconfig plugin for vim
    use({ "osyo-manga/vim-anzu", event = "BufRead" }) -- show total number of matches and current match number
    use({ "jeffkreeftmeijer/vim-numbertoggle", event = "BufRead" })
    use({ "haya14busa/vim-asterisk", event = "BufRead" }) -- asterisk.vim provides improved search * motions
    use({ "segeljakt/vim-isotope", event = "BufRead" }) -- insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,
    -- use 'kshenoy/vim-signature'                                                                                                                      -- toggle display and navigate marks
    use({ "sedm0784/vim-you-autocorrect", event = "BufRead" }) -- Automatic autocorrect
    use({ "inkarkat/vim-ingo-library", event = "BufRead" }) -- Spellcheck dependency
    use({ "inkarkat/vim-spellcheck", event = "BufRead" }) -- Add vim spell check errors to quicklist
    -- use 'beloglazov/vim-online-thesaurus'
    use({ "takac/vim-hardtime", event = "BufRead" }) -- vim hardtime
    use({ "chrisbra/unicode.vim", event = "BufRead" }) -- vim unicode helper
    use({ "posva/vim-vue", ft = { "vue" } })

    use({ "Vimjas/vim-python-pep8-indent", ft = { "python" } }) -- a nicer Python indentation style for vim
    use({ "rust-lang/rust.vim", ft = { "rust" } }) -- rust file detection, syntax highlighting, formatting, Syntastic integration, and more
    use("simrat39/rust-tools.nvim")
    use({ "JuliaEditorSupport/julia-vim" }) -- julia support for vim
    use({ "kdheepak/gridlabd.vim", ft = "gridlabd" }) -- gridlabd syntax support
    use({ "zah/nim.vim", ft = "nim" }) -- syntax highlighting auto indent for nim in vim
    use({ "gpanders/vim-medieval", ft = "markdown" }) -- evaluate markdown code blocks within vim
    use({ "plasticboy/vim-markdown", ft = "markdown" }) -- Syntax highlighting, matching rules and mappings for the original Markdown and extensions.
    use({ "kana/vim-textobj-user", event = "BufRead" })
    use({ "kana/vim-textobj-line", event = "BufRead" })
    use({ "GCBallesteros/vim-textobj-hydrogen", ft = { "ipynb", "python", "markdown" } })
    use({ "GCBallesteros/jupytext.vim", ft = { "ipynb", "python", "markdown" } })
    use({ "bfredl/nvim-ipy", ft = "python" })
    use({ "~/gitrepos/JuliaFormatter.vim" }) -- formatter for Julia
    use({ "sindrets/diffview.nvim" })
    use({ "christoomey/vim-conflicted" })
    -- use {
    --   'romgrk/barbar.nvim',
    --   config = function()
    --     vim.g.bufferline.icons = 'both'
    --     vim.api.nvim_set_keymap('n', '<TAB>', ':BufferNext<CR>', { noremap = true, silent = true })
    --     vim.api.nvim_set_keymap('n', '<S-TAB>', ':BufferPrevious<CR>', { noremap = true, silent = true })
    --     vim.api.nvim_set_keymap('n', '<C-c><C-c>', ':BufferClose<CR>', { noremap = true, silent = true })
    --   end,
    --   event = 'BufRead',
    -- }
    use({ "jbyuki/one-small-step-for-vimkind", ft = "lua" })
    use({ "npxbr/glow.nvim", branch = "main", run = ":GlowInstall" })
    use({ "rust-lang/vscode-rust", ft = "rust" })
    use({ "jbyuki/nabla.nvim", ft = "markdown" }) -- Take your scentific notes in Neovim.
    -- use { 'glepnir/galaxyline.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use({ "hoob3rt/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })
    use({ "jbyuki/venn.nvim", event = "BufRead" }) -- Draw ASCII diagrams in Neovim.
    use({
      "pwntester/octo.nvim",
      config = function()
        require("octo").setup()
      end,
      event = "BufRead",
    })
    -- use { 'glepnir/galaxyline.nvim' }
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
    })
    -- colorschemes
    -- use 'RRethy/nvim-base16'
    -- use 'kdheepak/vim-one' -- light and dark vim colorscheme
    -- use 'Th3Whit3Wolf/one-nvim'
    -- use 'navarasu/onedark.nvim'
    -- use 'marko-cerovac/material.nvim'
    -- use 'lourenci/github-colors'
    -- use 'ishan9299/nvim-solarized-lua'
    -- use 'dracula/vim'
    -- use { 'yashguptaz/calvera-dark.nvim' }
    -- use 'marko-cerovac/material.nvim'
    -- use { 'cocopon/iceberg.vim' }
    -- use 'ntk148v/vim-horizon'
    use({
      "folke/tokyonight.nvim",
      config = function()
        vim.g.termguicolors = true
        -- vim.g.tokyonight_style = 'night'
        -- vim.cmd('colorscheme tokyonight')
      end,
    })
    -- use 'bluz71/vim-moonfly-colors'
    use({
      "srcery-colors/srcery-vim",
      config = function()
        -- vim.g.termguicolors = true
        -- vim.o.background = 'dark'
        -- vim.cmd('colorscheme srcery')
      end,
    })
    use({
      "axvr/photon.vim",
      -- config = function()
      --   vim.g.termguicolors = true
      --   -- vim.o.background = 'dark'
      --   -- vim.cmd('colorscheme photon')
      -- end,
    })
    use({
      "~/gitrepos/monochrome.nvim",
      -- config = function()
      --   vim.g.termguicolors = true
      --   vim.o.background = 'dark'
      --   vim.g.monochrome_style = 'coolgray'
      --   vim.cmd('colorscheme monochrome')
      -- end,
    })
    use({
      "bluz71/vim-nightfly-guicolors",
      config = function()
        vim.g.termguicolors = true
        -- vim.cmd('colorscheme nightfly')
      end,
    })
    -- use 'mhartington/oceanic-next'
    -- use 'https://git.sr.ht/~novakane/kosmikoa.nvim'
    use({
      "fenetikm/falcon",
      config = function()
        vim.g.termguicolors = true
        -- vim.cmd [[colorscheme falcon]]
      end,
    })
    use({
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
    -- use {
    --   'tomasr/molokai',
    --   config = function()
    --     vim.o.termguicolors = true
    --     vim.cmd('colorscheme github')
    --     require('github-theme').setup({ themeStyle = 'dark' })
    --   end,
    -- }
    use({
      "jghauser/mkdir.nvim",
      config = function()
        require("mkdir")
      end,
    })
    use({
      "numToStr/Navigator.nvim",
      config = function()
        require("Navigator").setup()
      end,
    })
    use({
      "norcalli/nvim-terminal.lua",
      config = function()
        require("terminal").setup()
      end,
    })
    use({
      "lithammer/nvim-diagnosticls",
      config = function()
        require("diagnosticls")
      end,
    })
    use("famiu/nvim-reload")
    use({
      "folke/twilight.nvim",
      config = function()
        require("twilight").setup({})
      end,
    })
  end,
  config = { display = { open_fn = require("packer.util").float } },
})

require("kdheepak/statusline")
require("kdheepak/settings")
require("kdheepak/config")
require("kdheepak/keymappings")
require("kdheepak/autocommands")

return M
