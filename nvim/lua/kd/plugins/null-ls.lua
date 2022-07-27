local autocmd = require("kd/utils").autocmd
local null_ls = require("null-ls")
local builtins = null_ls.builtins

local styluaConfig = {
  extra_args = { "--config-path", vim.fn.expand("~/gitrepos/dotfiles/.stylua.toml") },
}

-- npm install -g prettier prettier-plugin-toml prettier-plugin-sh prettier-plugin-svelte @prettier/plugin-xml markdownlint
null_ls.setup({
  on_attach = function(_)
    autocmd("BufWritePre", require("kd/plugins/nvim-lspconfig").on_save)
  end,
  sources = {
    builtins.diagnostics.eslint,
    builtins.formatting.clang_format,
    builtins.formatting.stylua.with(styluaConfig),
    builtins.formatting.black.with({ extra_args = { "--line-length", "150" } }),
    null_ls.builtins.formatting.prettier.with({
      filetypes = {
        -- null_ls.builtins.formatting.prettierd.filetypes
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "markdown",
        "html",
        "json",
        "yaml",
        "graphql",
        "xml",
        "toml",
        "svelte",
        "sh",
        "dockerfile",
        "conf",
        "zsh",
        "gitignore",
      },
    }),
    builtins.diagnostics.markdownlint.with({
      args = { "--disable", "MD013", "MD041" },
    }),
    builtins.diagnostics.shellcheck,
  },
})
