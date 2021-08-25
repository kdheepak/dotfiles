local T = require("kd/utils").T

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local check_backspace = require("kd/utils").check_backspace

cmp.setup({

  -- You should change this example to your chosen snippet engine.
  snippet = {
    expand = function(args)
      return require("luasnip").lsp_expand(args.body)
    end,
  },

  completion = {
    completeopt = "menu,menuone,noselect",
    autocomplete = {},
  },

  -- You must set mapping.
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<ESC>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(T("<C-n>"), "n")
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
      elseif check_backspace() then
        vim.fn.feedkeys(T("<Tab>"), "n")
      else
        vim.fn.feedkeys(T("<C-Space>"))
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(T("<C-p>"), "n")
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(T("<Plug>luasnip-jump-prev"), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = ({
        nvim_lsp = "[L]",
        emoji = "[E]",
        path = "[F]",
        calc = "[C]",
        vsnip = "[S]",
        buffer = "[B]",
      })[entry.source.name]
      vim_item.dup = ({
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
      })[entry.source.name] or 0
      return vim_item
    end,
  },

  -- You should specify your *installed* sources.
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    { name = "emoji" },
    { name = "calc" },
    { name = "path" },
    { name = "latex_symbols" },
    {
      name = "buffer",
      opts = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  },
})
