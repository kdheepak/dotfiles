M = {}
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  execute 'packadd packer.nvim'
end

function M.reload_config()
  vim.cmd 'source ~/.config/nvim/init.lua'
  vim.cmd 'source ~/.config/nvim/lua/kdheepak/plugins.lua'
  vim.cmd ':PackerCompile'
  vim.cmd ':PackerClean'
  vim.cmd ':PackerInstall'
end

-- Need to replace this once lua api has vim modes
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua lua require'kdheepak/plugins'.reload_config()
  augroup end
]], false)

local inspected_buffers = {}
-- this function is called b4 a buffer is opened, so we need to manually open the file and count the lines.
function limit_by_line_count(max_lines)
  local fname = vim.fn.expand('%:p')
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

local packer = require('packer')
local use = packer.use
packer.reset()

packer.startup({
  function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview', ft = 'markdown' }

    -- use {
    --   'windwp/nvim-autopairs',
    --   after = { 'telescope.nvim', 'nvim-compe' },
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
    use { 'windwp/nvim-ts-autotag' }
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require'nvim-treesitter.configs'.setup {
          autotag = { enable = true },
          highlight = { enable = true },
          incremental_selection = { enable = true },
          textobjects = { enable = true },
          indent = { enable = true },
        }
      end,
      requires = { { 'nvim-treesitter/playground' } },
    }
    use {
      'terrortylor/nvim-comment',
      config = function()
        require('nvim_comment').setup()
      end,
    }

    use {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('gitsigns').setup {
          signs = {
            add = { hl = 'GitSignsAdd', text = '▎', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
            change = { hl = 'GitSignsChange', text = '▎', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
            delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
            topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
            changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          },
          numhl = false,
          linehl = false,
          watch_index = { interval = 1000 },
          current_line_blame = false,
          sign_priority = 6,
          update_debounce = 1000,
          status_formatter = nil, -- Use default
          use_decoration_api = true,
          use_internal_diff = true, -- If luajit is present
        }
      end,
    }

    use {
      'neovim/nvim-lspconfig',
      config = function()
        require 'kdheepak/lspconfig'
      end,
    }
    use { 'kabouzeid/nvim-lspinstall' }

    use {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim', 'nvim-telescope/telescope-fzy-native.nvim' },
      config = function()
        require 'kdheepak/telescope'
      end,
    }
    use 'tamago324/telescope-openbrowser.nvim'
    use 'nvim-telescope/telescope-github.nvim'
    use 'gbrlsnchs/telescope-lsp-handlers.nvim'
    use 'nvim-telescope/telescope-dap.nvim'
    use 'Pocco81/DAPInstall.nvim'
    use {
      'mfussenegger/nvim-dap',
      config = function()
        require 'kdheepak/debug'
      end,
    }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'mfussenegger/nvim-dap-python'

    use {
      'folke/which-key.nvim',
      config = function()
        require 'kdheepak/which-key'
      end,
    }
    use {
      'ibhagwan/fzf-lua',
      requires = {
        'kyazdani42/nvim-web-devicons', -- optional for icons
        'vijaymarupudi/nvim-fzf',
      },
    }

    use 'folke/trouble.nvim'
    use {
      'glepnir/lspsaga.nvim',
      config = function()
        require('lspsaga').init_lsp_saga {
          code_action_icon = '',
          code_action_prompt = { enable = true, sign = true, sign_priority = 20, virtual_text = false },
          code_action_keys = { quit = { 'q', '<ESC>' }, exec = '<CR>' },
          border_style = 'round',
        }
        vim.cmd([[
        autocmd CursorHold * lua require'lspsaga.diagnostic'.show_cursor_diagnostics()
        ]])
      end,
    }

    use { 'onsails/lspkind-nvim' }
    use { 'ray-x/lsp_signature.nvim' }

    use {
      'nvim-lua/lsp-status.nvim',
      config = function()
        require('lsp-status').register_progress()
      end,
    }
    use {
      'hrsh7th/nvim-compe',
      config = function()
        require 'kdheepak/compe'
      end,
    }
    use { 'mattn/emmet-vim', ft = { 'html', 'vue', 'css' } }
    use { 'FateXii/emmet-compe', ft = { 'html', 'vue', 'css' } }
    use { 'tamago324/compe-zsh', ft = 'zsh' }
    use { 'sblumentritt/cmake.vim', ft = 'cmake' }
    -- use { 'Gavinok/compe-nextword', event = 'BufRead' }
    use { 'GoldsteinE/compe-latex-symbols', event = 'BufRead' }
    use { 'hrsh7th/vim-vsnip', event = 'BufRead' }
    use { 'hrsh7th/vim-vsnip-integ', event = 'BufRead' }
    use { 'rafamadriz/friendly-snippets', event = 'BufRead' }

    -- use { 'tversteeg/registers.nvim', event = 'BufRead' } -- Show register content when you try to access it in NeoVim.

    use { 'ggandor/lightspeed.nvim', event = 'BufRead' } -- use s and S to search

    use 'kyazdani42/nvim-tree.lua'
    use 'kevinhwang91/nvim-bqf' -- The goal of nvim-bqf is to make Neovim's quickfix window better.
    use { 'tyru/open-browser.vim' } -- opens url in browser
    use { 'tyru/open-browser-github.vim', event = 'BufRead' } -- opens github repo or github issue in browser
    use { 'rhysd/git-messenger.vim', event = 'BufRead' } -- reveal a hidden message from git under the cursor quickly
    use { 'tpope/vim-fugitive', event = 'BufRead' } -- vim plugin for Git that is so awesome, it should be illegal
    use { 'tpope/vim-rhubarb', event = 'BufRead' } -- vim plugin for github
    use { 'samoshkin/vim-mergetool', event = 'BufRead' } -- Merge tool for git
    use { '~/gitrepos/lazygit.nvim', event = 'BufRead' } -- lazygit
    use 'folke/lsp-colors.nvim'
    --  use 'bkad/CamelCaseMotion' -- motions for inside camel case
    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require'colorizer'.setup()
      end,
    }
    -- use {
    --   'RRethy/vim-hexokinase',
    --   run = 'make hexokinase',
    --   config = function()
    --     vim.g.Hexokinase_highlighters = { 'backgroundfull' }
    --     vim.g.Hexokinase_optInPatterns = { 'full_hex', 'triple_hex', 'rgb', 'rgba', 'hsl', 'hsla' }
    --   end,
    -- }
    use { 'euclidianAce/BetterLua.vim' }
    use { 'bfredl/nvim-luadev' }
    use {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup()
      end,
    }
    -- use 'itchyny/vim-cursorword'                                         -- underlines the word under the cursor
    -- use 'yamatsum/nvim-cursorline'
    use { 'RRethy/vim-illuminate' }
    --  use 'junegunn/vim-easy-align' -- helps alignment
    use { 'godlygeek/tabular', event = 'BufRead' } -- line up text
    use { 'tpope/vim-unimpaired', event = 'BufRead' } -- complementary pairs of mappings
    use { 'tpope/vim-abolish', event = 'BufRead' } -- convert camel to snake
    use { 'tpope/vim-surround', event = 'BufRead' } -- all about surroundings: parentheses, brackets, quotes, XML tags, and more.
    use { 'tpope/vim-repeat', event = 'BufRead' } -- repeat.vim remaps . in a way that plugins can tap into it.
    use { 'vim-utils/vim-vertical-move', event = 'BufRead' }
    -- use 'tpope/vim-tbone'                                                                                                                            -- basic tmux support for vim
    use { 'tpope/vim-jdaddy', event = 'BufRead' } -- mappings for working with json in vim
    -- use 'tpope/vim-obsession'                                                                                                                        -- no hassle vim sessions
    use { 'tpope/vim-speeddating', event = 'BufRead' } -- Tools for working with dates
    use { 'tpope/vim-eunuch', event = 'BufRead' } -- vim sugar for UNIX shell commands like :Rename
    use { 'tpope/vim-sleuth', event = 'BufRead' } -- This plugin automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file
    use { 'inkarkat/vim-visualrepeat', event = 'BufRead' } -- repetition of vim built-in normal mode commands via . for visual mode
    use { 'Konfekt/vim-CtrlXA', event = 'BufRead' } -- Increment and decrement and toggle keywords
    use { 'dhruvasagar/vim-zoom' } -- toggle zoom of current window within the current tab
    use { 'kana/vim-niceblock' } -- makes blockwise Visual mode more useful and intuitive
    use { 'mbbill/undotree', event = 'BufRead' } -- visualizes undo history and makes it easier to browse and switch between different undo branches
    use { 'reedes/vim-wordy' } -- uncover usage problems in your writing
    use 'farmergreg/vim-lastplace' -- intelligently reopen files at your last edit position
    use { 'ntpeters/vim-better-whitespace', event = 'BufRead' } -- causes all trailing whitespace characters to be highlighted
    use { 'nathanaelkane/vim-indent-guides', event = 'BufRead' } -- displaying thin vertical lines at each indentation level for code indented with spaces
    use { 'dhruvasagar/vim-table-mode', event = 'BufRead' } -- automatic table creator & formatter allowing one to create neat tables as you type
    use { 'joom/latex-unicoder.vim', event = 'BufRead' } -- a plugin to type Unicode chars in Vim, using their LaTeX names
    use 'editorconfig/editorconfig-vim' -- editorconfig plugin for vim
    use { 'osyo-manga/vim-anzu', event = 'BufRead' } -- show total number of matches and current match number
    use { 'jeffkreeftmeijer/vim-numbertoggle', event = 'BufRead' }
    use { 'haya14busa/vim-asterisk', event = 'BufRead' } -- asterisk.vim provides improved search * motions
    use { 'segeljakt/vim-isotope', event = 'BufRead' } -- insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,
    -- use 'kshenoy/vim-signature'                                                                                                                      -- toggle display and navigate marks
    use { 'sedm0784/vim-you-autocorrect', event = 'BufRead' } -- Automatic autocorrect
    use { 'inkarkat/vim-ingo-library', event = 'BufRead' } -- Spellcheck dependency
    use { 'inkarkat/vim-spellcheck', event = 'BufRead' } -- Add vim spell check errors to quicklist
    -- use 'beloglazov/vim-online-thesaurus'
    use { 'takac/vim-hardtime', event = 'BufRead' } -- vim hardtime
    use { 'glepnir/dashboard-nvim' }
    use { 'chrisbra/unicode.vim', event = 'BufRead' } -- vim unicode helper
    use { 'posva/vim-vue', ft = { 'vue' } }
    use 'nvim-lua/lsp_extensions.nvim'
    use 'liuchengxu/vista.vim' -- viewer and finder for lsp symbols
    use { 'kosayoda/nvim-lightbulb', event = 'BufRead' }
    use { 'Vimjas/vim-python-pep8-indent', ft = { 'python' } } -- a nicer Python indentation style for vim
    use { 'rust-lang/rust.vim', ft = { 'rust' } } -- rust file detection, syntax highlighting, formatting, Syntastic integration, and more
    use { 'JuliaEditorSupport/julia-vim' } -- julia support for vim
    use { 'kdheepak/gridlabd.vim', ft = 'gridlabd' } -- gridlabd syntax support
    use { 'zah/nim.vim', ft = 'nim' } -- syntax highlighting auto indent for nim in vim
    use { 'gpanders/vim-medieval', ft = 'markdown' } -- evaluate markdown code blocks within vim
    use { 'plasticboy/vim-markdown', ft = 'markdown' } -- Syntax highlighting, matching rules and mappings for the original Markdown and extensions.
    use { 'hkupty/iron.nvim', event = 'BufRead' }
    use { 'kana/vim-textobj-user', event = 'BufRead' }
    use { 'kana/vim-textobj-line', event = 'BufRead' }
    use { 'GCBallesteros/vim-textobj-hydrogen', ft = { 'ipynb', 'python', 'markdown' } }
    use { 'GCBallesteros/jupytext.vim', ft = { 'ipynb', 'python', 'markdown' } }
    use { 'bfredl/nvim-ipy', ft = 'python' }
    use { '~/gitrepos/JuliaFormatter.vim' } -- formatter for Julia
    use { 'sindrets/diffview.nvim' }
    use {
      'romgrk/barbar.nvim',
      config = function()
        vim.g.bufferline.icons = 'both'
        vim.api.nvim_set_keymap('n', '<TAB>', ':BufferNext<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<S-TAB>', ':BufferPrevious<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<C-c><C-c>', ':BufferClose<CR>', { noremap = true, silent = true })
      end,
      event = 'BufRead',
    }
    use { 'jbyuki/one-small-step-for-vimkind', ft = 'lua' }
    use { 'npxbr/glow.nvim', branch = 'main', run = ':GlowInstall' }
    use { 'rust-lang/vscode-rust', ft = 'rust' }
    use { 'jbyuki/nabla.nvim', ft = 'markdown' } -- Take your scentific notes in Neovim.
    -- use { 'glepnir/galaxyline.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use {
      'hoob3rt/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        -- vim.api.nvim_set_keymap('n', '<TAB>', ':bnext<CR>', { noremap = true, silent = true })
        -- vim.api.nvim_set_keymap('n', '<S-TAB>', ':bprev<CR>', { noremap = true, silent = true })
        -- vim.api.nvim_set_keymap('n', '<C-c><C-c>', ':bdelete<CR>', { noremap = true, silent = true })
      end,
    }
    use { 'jbyuki/venn.nvim', event = 'BufRead' } -- Draw ASCII diagrams in Neovim.
    use {
      'pwntester/octo.nvim',
      config = function()
        require'octo'.setup()
      end,
      event = 'BufRead',
    }
    -- use { 'glepnir/galaxyline.nvim' }
    use {
      'akinsho/nvim-toggleterm.lua',
      config = function()
        require('toggleterm').setup {}
      end,
    }
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
    use {
      'folke/tokyonight.nvim',
      config = function()
        -- vim.g.termguicolors = true
        -- vim.g.tokyonight_style = 'night'
        -- vim.cmd('colorscheme tokyonight')
      end,
    }
    -- use 'bluz71/vim-moonfly-colors'
    use {
      'srcery-colors/srcery-vim',
      config = function()
        -- vim.g.termguicolors = true
        -- vim.o.background = 'dark'
        -- vim.cmd('colorscheme srcery')
      end,
    }
    use {
      'axvr/photon.vim',
      -- config = function()
      --   vim.g.termguicolors = true
      --   -- vim.o.background = 'dark'
      --   -- vim.cmd('colorscheme photon')
      -- end,
    }
    use {
      '~/gitrepos/monochrome.nvim',
      -- config = function()
      --   vim.g.termguicolors = true
      --   vim.o.background = 'dark'
      --   vim.g.monochrome_style = 'coolgray'
      --   vim.cmd('colorscheme monochrome')
      -- end,
    }
    use {
      'bluz71/vim-nightfly-guicolors',
      config = function()
        vim.g.termguicolors = true
        -- vim.cmd('colorscheme nightfly')
      end,
    }
    -- use 'mhartington/oceanic-next'
    -- use 'https://git.sr.ht/~novakane/kosmikoa.nvim'
    use {
      'projekt0n/github-nvim-theme',
      config = function()
        vim.g.termguicolors = true
        -- require('github-theme').setup()
        require('github-theme').setup({ themeStyle = 'light', keywordStyle = 'NONE' })
      end,
    }
    -- use {
    --   'tomasr/molokai',
    --   config = function()
    --     vim.o.termguicolors = true
    --     vim.cmd('colorscheme github')
    --     require('github-theme').setup({ themeStyle = 'dark' })
    --   end,
    -- }
    use {
      'jghauser/mkdir.nvim',
      config = function()
        require('mkdir')
      end,
    }
    use {
      'numToStr/Navigator.nvim',
      config = function()
        require('Navigator').setup()
      end,
    }
    use {
      'norcalli/nvim-terminal.lua',
      config = function()
        require('terminal').setup()
      end,
    }
    use {
      'lithammer/nvim-diagnosticls',
      config = function()
        require('diagnosticls')
      end,
    }
    use 'famiu/nvim-reload'
    use {
      'folke/twilight.nvim',
      config = function()
        require('twilight').setup {}
      end,
    }
  end,
  config = { display = { open_fn = require('packer.util').float } },
})

require 'kdheepak/statusline'
require 'kdheepak/settings'
require 'kdheepak/config'
require 'kdheepak/autocommands'
require 'kdheepak/keymappings'

return M
