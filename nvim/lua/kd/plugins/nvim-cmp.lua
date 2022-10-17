local cmp = require("cmp")

local luasnip = require("luasnip")
require("luasnip/loaders/from_vscode").lazy_load()

local has_words_before = require("kd/utils").has_words_before
local function tab(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expandable() then
    luasnip.expand()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

local function shift_tab(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local lsp_icons = {
  Class = " ",
  Color = " ",
  Constant = " ",
  Constructor = " ",
  Enum = "了 ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = " ",
  Interface = " ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Operator = " ",
  Property = "ﰠ ",
  Reference = " ",
  Snippet = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = "",
  Unit = " ",
  Value = " ",
  Variable = " ",
}

cmp.setup({
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  preselect = cmp.PreselectMode.None,
  -- You should change this example to your chosen snippet engine.
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  -- You must set mapping.
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
    ["<S-tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
  },

  formatting = {
    format = require("lspkind").cmp_format({
      with_text = false,
      maxwidth = 50,
      before = function(entry, vim_item)
        vim_item.kind = string.format("%s %s", lsp_icons[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
          calc = "±",
          emoji = "☺",
          latex_symbols = "λ",
          nvim_lsp = "ﲳ",
          nvim_lua = "",
          treesitter = "",
          path = "ﱮ",
          buffer = "﬘",
          zsh = "",
          luasnip = "",
          spell = "暈",
        })[entry.source.name]
        return vim_item
      end,
    }),
  },

  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      require("cmp-under-comparator").under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  -- You should specify your *installed* sources.
  sources = cmp.config.sources({
    { name = "buffer" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_document_symbol" },
    { name = "nvim_lsp_signature_help" },
    { name = "latex_symbols" },
    { name = "nvim_lua" },
    { name = "calc" },
    { name = "emoji" },
    { name = "path" },
    { name = "treesitter" },
    { name = "git" },
    { name = "pandoc_references" },
    { name = "rg" },
    { name = "cmp_pandoc" },
    { name = "orgmode" },
    { name = "crates" },
    { name = "julia_packages" },
    { name = "dap" },
    -- { name = "spell" },
    -- {
    --   name = "dictionary",
    --   keyword_length = 5,
    -- },
  }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

-- -- Use buffer source for `/`
-- cmp.setup.cmdline("/", {
--   sources = {
--     { name = "buffer" },
--   },
-- })

-- -- Use cmdline & path source for ':'
-- cmp.setup.cmdline(":", {
--   sources = cmp.config.sources({
--     { name = "path" },
--   }, {
--     { name = "cmdline" },
--   }),
-- })

vim.schedule(function()
  vim.o.completeopt = "menu,menuone,noselect"
end)
