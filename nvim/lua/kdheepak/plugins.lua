local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  execute 'packadd packer.nvim'
end

-- Need to replace this once lua api has vim modes
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile profile=true
    autocmd BufWritePost init.lua PackerCompile profile=true
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

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-autopairs').setup()
        require'nvim-treesitter.configs'.setup {
          autotag = { enable = true },
          highlight = { enable = true },
          incremental_selection = { enable = true },
          textobjects = { enable = true },
          indent = { enable = true },
        }
      end,
      requires = {
        { 'nvim-treesitter/playground', opt = true }, { 'windwp/nvim-autopairs' }, { 'windwp/nvim-ts-autotag' },
      },
    }

    use {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        require('gitsigns').setup()
      end,
    }

    use 'neovim/nvim-lspconfig'

    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim' } }
    use 'tamago324/telescope-openbrowser.nvim'
    use 'nvim-telescope/telescope-github.nvim'
    use 'gbrlsnchs/telescope-lsp-handlers.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'nvim-telescope/telescope-dap.nvim'
    use 'Pocco81/DAPInstall.nvim'
    use 'mfussenegger/nvim-dap'
    use 'theHamsta/nvim-dap-virtual-text'
    use 'mfussenegger/nvim-dap-python'

    use { 'folke/which-key.nvim' }

    use {
      'glepnir/lspsaga.nvim',
      config = function()
        require('lspsaga').init_lsp_saga {
          code_action_icon = '',
          code_action_prompt = { enable = true, sign = true, sign_priority = 20, virtual_text = false },
          code_action_keys = { quit = { 'q', '<ESC>' }, exec = '<CR>' },
          border_style = 'round',
        }
      end,
    }

    use 'onsails/lspkind-nvim'
    use 'ray-x/lsp_signature.nvim'

    use {
      'nvim-lua/lsp-status.nvim',
      config = function()
        require('lsp-status').register_progress()
      end,
    }
    use { 'hrsh7th/nvim-compe' }
    use { 'mattn/emmet-vim', ft = { 'html', 'vue' } }
    use { 'FateXii/emmet-compe', ft = { 'html', 'vue' } }
    use { 'Gavinok/compe-nextword', ft = 'markdown' }
    use 'GoldsteinE/compe-latex-symbols'
    use { 'sblumentritt/cmake.vim', ft = 'cmake' }
    use { 'tamago324/compe-zsh', ft = 'zsh' }
    use { 'hrsh7th/vim-vsnip' }
    use { 'hrsh7th/vim-vsnip-integ' }

    use 'tversteeg/registers.nvim' -- Show register content when you try to access it in NeoVim.
    use 'kyazdani42/nvim-tree.lua'

    use 'ggandor/lightspeed.nvim' -- use s and S to search
    use 'kevinhwang91/nvim-bqf' -- The goal of nvim-bqf is to make Neovim's quickfix window better.
    use 'tyru/open-browser.vim' -- opens url in browser
    use 'tyru/open-browser-github.vim' -- opens github repo or github issue in browser
    use 'rhysd/git-messenger.vim' -- reveal a hidden message from git under the cursor quickly
    use 'tpope/vim-fugitive' -- vim plugin for Git that is so awesome, it should be illegal
    use 'tpope/vim-rhubarb' -- vim plugin for github
    use 'samoshkin/vim-mergetool' -- Merge tool for git
    use '~/gitrepos/lazygit.nvim' -- lazygit
    use 'folke/lsp-colors.nvim'
    --  use 'bkad/CamelCaseMotion' -- motions for inside camel case
    use {
      'norcalli/nvim-colorizer.lua',
      config = function() -- a high-performance color highlighter for Neovim which has no external dependencies
        require('colorizer').setup()
      end,
    }
    use {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup()
      end,
    }
    --  -- use 'itchyny/vim-cursorword'                                         -- underlines the word under the cursor
    use 'yamatsum/nvim-cursorline'
    --  use 'junegunn/vim-easy-align' -- helps alignment
    use 'godlygeek/tabular' -- line up text
    use 'tpope/vim-commentary' -- comment and uncomment stuff
    use 'tpope/vim-unimpaired' -- complementary pairs of mappings
    use 'tpope/vim-abolish' -- convert camel to snake
    use 'tpope/vim-surround' -- all about surroundings: parentheses, brackets, quotes, XML tags, and more.
    use 'tpope/vim-repeat' -- repeat.vim remaps . in a way that plugins can tap into it.
    use 'vim-utils/vim-vertical-move'
    use 'tpope/vim-tbone' -- basic tmux support for vim
    use 'tpope/vim-jdaddy' -- mappings for working with json in vim
    use 'tpope/vim-obsession' -- no hassle vim sessions
    use 'tpope/vim-speeddating' -- Tools for working with dates
    use 'tpope/vim-scriptease' -- a Vim plugin for making Vim plugins.
    use 'tpope/vim-eunuch' -- vim sugar for UNIX shell commands like :Rename
    use 'tpope/vim-sleuth'
    use 'inkarkat/vim-visualrepeat' -- repetition of vim built-in normal mode commands via . for visual mode
    use 'Konfekt/vim-CtrlXA' -- Increment and decrement and toggle keywords
    use 'dhruvasagar/vim-zoom' -- toggle zoom of current window within the current tab
    use 'kana/vim-niceblock' -- makes blockwise Visual mode more useful and intuitive
    use 'mbbill/undotree' -- visualizes undo history and makes it easier to browse and switch between different undo branches
    use 'reedes/vim-wordy' -- uncover usage problems in your writing
    use 'farmergreg/vim-lastplace' -- intelligently reopen files at your last edit position
    use 'ntpeters/vim-better-whitespace' -- causes all trailing whitespace characters to be highlighted
    use 'nathanaelkane/vim-indent-guides' -- displaying thin vertical lines at each indentation level for code indented with spaces
    use 'dhruvasagar/vim-table-mode' -- automatic table creator & formatter allowing one to create neat tables as you type
    use 'joom/latex-unicoder.vim' -- a plugin to type Unicode chars in Vim, using their LaTeX names
    use 'editorconfig/editorconfig-vim' -- editorconfig plugin for vim
    use 'osyo-manga/vim-anzu' -- show total number of matches and current match number
    use 'jeffkreeftmeijer/vim-numbertoggle'
    use 'haya14busa/vim-asterisk' -- asterisk.vim provides improved search * motions
    use 'segeljakt/vim-isotope' -- insert characters such as ˢᵘᵖᵉʳˢᶜʳⁱᵖᵗˢ, u͟n͟d͟e͟r͟l͟i͟n͟e͟, s̶t̶r̶i̶k̶e̶t̶h̶r̶o̶u̶g̶h̶, 𝐒𝐄𝐑𝐈𝐅-𝐁𝐎𝐋𝐃, 𝐒𝐄𝐑𝐈𝐅-𝐈𝐓𝐀𝐋𝐈𝐂, 𝔉ℜ𝔄𝔎𝔗𝔘ℜ, 𝔻𝕆𝕌𝔹𝕃𝔼-𝕊𝕋ℝ𝕌ℂ𝕂, ᴙƎVƎᴙꙄƎD, INΛƎᴚ⊥Ǝᗡ, ⒸⒾⓇⒸⓁⒺⒹ,
    use 'kshenoy/vim-signature' -- toggle display and navigate marks
    use 'sedm0784/vim-you-autocorrect' -- Automatic autocorrect
    use 'inkarkat/vim-ingo-library' -- Spellcheck dependency
    use 'inkarkat/vim-spellcheck' -- Add vim spell check errors to quicklist
    -- use 'beloglazov/vim-online-thesaurus'
    use 'rhysd/clever-f.vim'
    use 'takac/vim-hardtime' -- vim hardtime
    use 'glepnir/dashboard-nvim'
    use 'chrisbra/unicode.vim' -- vim unicode helper
    use { 'posva/vim-vue', ft = 'vue' }
    use 'nvim-lua/lsp_extensions.nvim'
    use 'liuchengxu/vista.vim'
    use { 'Vimjas/vim-python-pep8-indent', ft = 'python' } -- a nicer Python indentation style for vim
    use { 'rust-lang/rust.vim', ft = 'rust' } -- rust file detection, syntax highlighting, formatting, Syntastic integration, and more
    -- use { 'JuliaEditorSupport/julia-vim', ft = 'julia' } -- julia support for vim
    use { 'kdheepak/gridlabd.vim', ft = 'gridlabd' } -- gridlabd syntax support
    use { 'zah/nim.vim', ft = 'nim' } -- syntax highlighting auto indent for nim in vim
    use { 'gpanders/vim-medieval', ft = 'markdown' } -- evaluate markdown code blocks within vim
    use { 'plasticboy/vim-markdown', ft = 'markdown' } -- Syntax highlighting, matching rules and mappings for the original Markdown and extensions.
    use 'hkupty/iron.nvim'
    use 'kana/vim-textobj-user'
    use 'kana/vim-textobj-line'
    use { 'GCBallesteros/vim-textobj-hydrogen', ft = { 'ipynb', 'python', 'markdown' } }
    use { 'GCBallesteros/jupytext.vim', ft = { 'ipynb', 'python', 'markdown' } }
    use { 'bfredl/nvim-ipy', ft = 'python' }
    use { '~/gitrepos/JuliaFormatter.vim', ft = 'julia' } -- formatter for Julia
    use 'sindrets/diffview.nvim'
    use 'romgrk/barbar.nvim'
    use { 'jbyuki/one-small-step-for-vimkind', ft = 'lua' }
    use { 'npxbr/glow.nvim', branch = 'main', run = ':GlowInstall' }
    use 'kosayoda/nvim-lightbulb'
    use 'rust-lang/vscode-rust'
    use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use { 'jbyuki/nabla.nvim', ft = 'markdown' } -- Take your scentific notes in Neovim.
    use 'jbyuki/venn.nvim' -- Draw ASCII diagrams in Neovim.
    use {
      'pwntester/octo.nvim',
      config = function()
        require'octo'.setup()
      end,
    }
    -- colorschemes
    -- use 'RRethy/nvim-base16'
    -- use 'kdheepak/vim-one' -- light and dark vim colorscheme
    -- use 'Th3Whit3Wolf/one-nvim'
    -- use 'navarasu/onedark.nvim'
    -- use 'marko-cerovac/material.nvim'
    -- use 'lourenci/github-colors'
    -- use 'sainnhe/gruvbox-material'
    -- use 'ishan9299/nvim-solarized-lua'
    -- use 'dracula/vim'
    use {
      'bluz71/vim-nightfly-guicolors',
      config = function()
        vim.o.termguicolors = true
        vim.cmd('colorscheme nightfly')
      end,
    }
    -- use 'bluz71/vim-moonfly-colors'
    -- use 'folke/tokyonight.nvim'
    -- use 'mhartington/oceanic-next'
    -- use 'kyazdani42/blue-moon'
    -- use 'yonlu/omni.vim'
    -- use 'fenetikm/falcon'
    -- use 'https://git.sr.ht/~novakane/kosmikoa.nvim'

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
  end,
  config = { display = { open_fn = require('packer.util').float } },
})
