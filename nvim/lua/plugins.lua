local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

-- Need to replace this once lua api has vim modes
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)

local packer = require('packer')

packer.startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, config = function()
        require('gitsigns').setup()
    end
  }

  use 'neovim/nvim-lspconfig'

  use {
    'kabouzeid/nvim-lspinstall', requires = {'neovim/nvim-lspconfig' },
  }

  use {
    'glepnir/lspsaga.nvim', config = function ()
      require('lspsaga').init_lsp_saga{
        code_action_icon = '',
        code_action_prompt = {
          enable = true,
          sign = true,
          sign_priority = 20,
          virtual_text = false,
        },
        code_action_keys = { quit = {'q', '<ESC>'}, exec = '<CR>' },
        border_style = 2,
      }
    end
  }

  use 'onsails/lspkind-nvim'

  use 'nvim-lua/lsp-status.nvim'

  use {
    "hrsh7th/nvim-compe",
    config = function()
      vim.opt.completeopt = "menuone,noselect"
      require("compe").setup({
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = "enable",
        throttle_time = 80,
        source_timeout = 200,
        resolve_timeout = 800,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,
        source = {
          path = true,
          buffer = true,
          calc = true,
          nvim_lsp = true,
          nvim_lua = true,
          tags = true,
          treesitter = true,
        },
      })
    end,
  }

  use {
    "hrsh7th/vim-vsnip", after = "nvim-compe",
  }

  use {
    'hrsh7th/vim-vsnip-integ', after = "nvim-compe",
  }

  use {
    "rafamadriz/friendly-snippets", after = "nvim-compe",
  }

  use {
    "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
  }

  use "tversteeg/registers.nvim"

  use {'ojroques/nvim-bufdel'}

  use 'justinmk/vim-dirvish'
  use 'mcchrish/nnn.vim'                                               -- Fast and featureful file manager in vim/neovim powered by nnn
  use 'vim-scripts/sketch.vim'
  use '~/gitrepos/vim-autoformat'
  use '~/gitrepos/artist.nvim'
  use 'gyim/vim-boxdraw'
  use 'tpope/vim-vinegar'
  use 'Xuyuanp/scrollbar.nvim'
  use 'tyru/open-browser.vim'                                          -- opens url in browser
  use 'tyru/open-browser-github.vim'                                   -- opens github repo or github issue in browser
  use 'tamago324/telescope-openbrowser.nvim'
  use 'rhysd/git-messenger.vim'                                        -- reveal a hidden message from git under the cursor quickly
  use 'tpope/vim-fugitive'                                             -- vim plugin for Git that is so awesome, it should be illegal
  use 'tpope/vim-rhubarb'                                              -- vim plugin for github
  use 'samoshkin/vim-mergetool'                                        -- Merge tool for git
  use '~/gitrepos/lazygit.nvim'                                        -- lazygit
  use '~/gitrepos/pandoc.nvim'                                         -- pandoc.nvim
  use '~/gitrepos/markdown-mode'                                       -- markdown mode
  -- use 'vim-airline/vim-airline'                                        -- airline status bar
  -- use 'vim-airline/vim-airline-themes'                                 -- official theme repository
  use 'nvim-telescope/telescope-github.nvim'
  use 'gbrlsnchs/telescope-lsp-handlers.nvim'
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use 'kdheepak/vim-one'                                               -- light and dark vim colorscheme
  use 'folke/lsp-colors.nvim'
  use 'bkad/CamelCaseMotion'                                           -- motions for inside camel case
  use { 'norcalli/nvim-colorizer.lua', config = function ()            -- a high-performance color highlighter for Neovim which has no external dependencies
    require('colorizer').setup()
  end }
  use 'itchyny/vim-cursorword'                                         -- underlines the word under the cursor
  use 'junegunn/vim-easy-align'                                        -- helps alignment
  use 'godlygeek/tabular'                                              -- line up text
  use 'tpope/vim-commentary'                                           -- comment and uncomment stuff
  use 'tpope/vim-unimpaired'                                           -- complementary pairs of mappings
  use 'tpope/vim-abolish'                                              -- convert camel to snake
  use 'tpope/vim-surround'                                             -- all about surroundings: parentheses, brackets, quotes, XML tags, and more.
  use 'tpope/vim-repeat'                                               -- repeat.vim remaps . in a way that plugins can tap into it.
  use 'vim-utils/vim-vertical-move'
  use 'tpope/vim-tbone'                                                -- basic tmux support for vim
  use 'tpope/vim-jdaddy'                                               -- mappings for working with json in vim
  use 'tpope/vim-obsession'                                            -- no hassle vim sessions
  use 'tpope/vim-speeddating'                                          -- Tools for working with dates
  use 'tpope/vim-scriptease'                                           -- a Vim plugin for making Vim plugins.
  use 'tpope/vim-eunuch'                                              -- vim sugar for UNIX shell commands like :Rename
  use 'inkarkat/vim-visualrepeat'                                      -- repetition of vim built-in normal mode commands via . for visual mode
  use 'Konfekt/vim-CtrlXA'                                             -- Increment and decrement and toggle keywords
  use 'dhruvasagar/vim-zoom'                                           -- toggle zoom of current window within the current tab
  use 'kana/vim-niceblock'                                             -- makes blockwise Visual mode more useful and intuitive
  use 'mbbill/undotree'                                                -- visualizes undo history and makes it easier to browse and switch between different undo branches
  use 'reedes/vim-wordy'                                               -- uncover usage problems in your writing
  use 'farmergreg/vim-lastplace'                                       -- intelligently reopen files at your last edit position
  use 'ntpeters/vim-better-whitespace'                                 -- causes all trailing whitespace characters to be highlighted
  use 'nathanaelkane/vim-indent-guides'                                -- displaying thin vertical lines at each indentation level for code indented with spaces
  use 'dhruvasagar/vim-table-mode'                                     -- automatic table creator & formatter allowing one to create neat tables as you type
  use 'joom/latex-unicoder.vim'                                        -- a plugin to type Unicode chars in Vim, using their LaTeX names
  use 'editorconfig/editorconfig-vim'                                  -- editorconfig plugin for vim
  use 'osyo-manga/vim-anzu'                                            -- show total number of matches and current match number
  use 'haya14busa/vim-asterisk'                                        -- asterisk.vim provides improved search * motions
  use 'ryanoasis/vim-devicons'                                         -- adds icons to plugins
  use 'segeljakt/vim-isotope'                                          -- insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,
  use 'pbrisbin/vim-mkdir'                                             -- automatically create any non-existent directories before writing the buffer
  use 'kshenoy/vim-signature'                                          -- toggle display and navigate marks
  use 'sedm0784/vim-you-autocorrect'                                   -- Automatic autocorrect
  use 'inkarkat/vim-ingo-library'                                      -- Spellcheck dependency
  use 'inkarkat/vim-spellcheck'                                        -- Add vim spell check errors to quicklist
  use 'beloglazov/vim-online-thesaurus'
  use 'rhysd/clever-f.vim'
  use 'takac/vim-hardtime'                                             -- vim hardtime
  use 'mhinz/vim-startify'                                             -- This plugin provides a start screen for Vim and Neovim. Also provides SSave and SLoad
  use 'chrisbra/unicode.vim'                                           -- vim unicode helper
  use 'posva/vim-vue'
  use 'nvim-lua/lsp_extensions.nvim'
  use 'liuchengxu/vista.vim'
  use 'Vimjas/vim-python-pep8-indent'                                  -- a nicer Python indentation style for vim
  use 'rust-lang/rust.vim'                                             -- rust file detection, syntax highlighting, formatting, Syntastic integration, and more
  use 'JuliaEditorSupport/julia-vim'                                   -- julia support for vim
  use 'kdheepak/gridlabd.vim'                                          -- gridlabd syntax support
  use 'zah/nim.vim'                                                    -- syntax highlighting auto indent for nim in vim
  use 'gpanders/vim-medieval'                                          -- evaluate markdown code blocks within vim
  use 'tpope/vim-sleuth'
  use 'plasticboy/vim-markdown'                                        -- Syntax highlighting, matching rules and mappings for the original Markdown and extensions.
  use 'hkupty/iron.nvim'
  use 'kana/vim-textobj-user'
  use 'kana/vim-textobj-line'
  use 'GCBallesteros/vim-textobj-hydrogen'
  use 'GCBallesteros/jupytext.vim'
  use 'bfredl/nvim-ipy'
  use '~/gitrepos/ganymede'
  use '~/gitrepos/JuliaFormatter.vim'                                    -- formatter for Julia
  use 'sindrets/diffview.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'ray-x/lsp_signature.nvim'
  use 'romgrk/barbar.nvim'
  use 'mfussenegger/nvim-dap'
  use 'nvim-telescope/telescope-dap.nvim'
  use 'mfussenegger/nvim-dap-python'
  use {"npxbr/glow.nvim", branch = "main", run = ":GlowInstall"}
  use 'kosayoda/nvim-lightbulb'
  use 'rust-lang/vscode-rust'
  use {
    'hoob3rt/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}, config = function()
      require'lualine'.setup {
        options = {
          theme = 'onedark',
        },
      }
    end
  }
  use 'jbyuki/nabla.nvim'
  use 'jbyuki/venn.nvim'
  use 'folke/tokyonight.nvim'
  use 'Th3Whit3Wolf/one-nvim'
  use 'navarasu/onedark.nvim'
  -- use 'ful1e5/onedark.nvim'
end)
