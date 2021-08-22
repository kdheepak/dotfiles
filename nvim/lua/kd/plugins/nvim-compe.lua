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
