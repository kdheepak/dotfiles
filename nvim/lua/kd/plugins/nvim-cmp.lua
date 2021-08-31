local T = require("kd/utils").T

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local check_backspace = require("kd/utils").check_backspace
local augroup = require("kd/utils").augroup
local autocmd = require("kd/utils").autocmd

cmp.setup({

  -- You should change this example to your chosen snippet engine.
  snippet = {
    expand = function(args)
      return require("luasnip").lsp_expand(args.body)
    end,
  },

  completion = {
    completeopt = "menu,menuone,noselect",
    get_trigger_characters = function(trigger_characters)
      return vim.tbl_filter(function(char)
        return char ~= " "
      end, trigger_characters)
    end,
  },
  -- You must set mapping.
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping(function(fallback)
      local expandable = luasnip.expand_or_jumpable()
      if vim.fn.getbufvar(vim.fn.bufnr(), "&filetype") == "TelescopePrompt" then
        return fallback()
      elseif vim.fn.pumvisible() == 1 then
        local not_selected = vim.fn.complete_info({ "selected" }).selected == -1
        if not_selected then
          if expandable then
            vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
          else
            fallback()
          end
        else -- normal completion
          cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })(fallback)
        end
      elseif expandable then -- there's no popup, but the entered text is an expandable snippet
        vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
      else
        fallback() -- fallback to a normal `<CR>`
      end
    end, {
      "i",
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.fn.getbufvar(vim.fn.bufnr(), "&filetype") == "TelescopePrompt" then
        fallback()
      elseif vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(T("<C-n>"), "n")
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(T("<Plug>luasnip-expand-or-jump"), "")
      elseif check_backspace() then
        vim.fn.feedkeys(T("<Tab>"), "n")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-tab>"] = cmp.mapping(function(fallback)
      if vim.fn.getbufvar(vim.fn.bufnr(), "&filetype") == "TelescopePrompt" then
        fallback()
      elseif vim.fn.pumvisible() == 1 then
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
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      vim_item.menu = ({
        nvim_lsp = "[L]",
        emoji = "[E]",
        path = "[F]",
        calc = "[C]",
        vsnip = "[S]",
        luasnip = "[S]",
        buffer = "[B]",
        latex_symbols = "[λ]",
      })[entry.source.name]
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

vim.schedule(function()
  vim.o.completeopt = "menu,menuone,noselect"
end)

augroup("KDLuaSnip", function()
  autocmd("FileType", "TelescopePrompt", function()
    require("cmp").setup.buffer({
      completion = { autocomplete = false },
    })
  end)
  autocmd("InsertLeave", "*", function()
    local expandable = luasnip.expand_or_jumpable()
    if expandable then
      vim.cmd("LuaSnipUnlinkCurrent")
    end
  end)
end)
