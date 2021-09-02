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

packer.reset()
packer.init({ max_jobs = 16 })

packer.startup({
  function()
    -- Packer can manage itself

    use("wbthomason/packer.nvim")

    use({
      "ibhagwan/fzf-lua",
      requires = {
        "vijaymarupudi/nvim-fzf",
        "kyazdani42/nvim-web-devicons",
      },
    })

  end,
  config = { display = { open_fn = require("packer.util").float } },
})

return M
