local noremap = require("kd/utils").noremap

require("hlslens").setup({
  calm_down = false,
  nearest_only = true,
  override_lens = function(render, plist, nearest, idx, r_idx)
    local sfw = vim.v.searchforward == 1
    local indicator, text, chunks
    local abs_r_idx = math.abs(r_idx)
    if abs_r_idx > 1 then
      indicator = string.format("%d%s", abs_r_idx, sfw ~= (r_idx > 1) and "" or "")
    elseif abs_r_idx == 1 then
      indicator = sfw ~= (r_idx == 1) and "" or ""
    else
      indicator = ""
    end

    local lnum, col = unpack(plist[idx])
    if nearest then
      local cnt = #plist
      if indicator ~= "" then
        text = string.format("[%s %d/%d]", indicator, idx, cnt)
      else
        text = string.format("[%d/%d]", idx, cnt)
      end
      chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
    else
      text = string.format("[%s %d]", indicator, idx)
      chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
    end
    render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
  end,
})

vim.api.nvim_set_keymap(
  "n",
  "n",
  "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "N",
  "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", { noremap = true })
-- noremap(
--   "n",
--   "<cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zzzv",
--   { silent = true }
-- )
-- noremap(
--   "N",
--   "<cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zzzv",
--   { silent = true }
-- )
-- noremap("*", "<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>zzzv")
-- noremap("#", "<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>zzzv")
-- noremap("g*", "<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>zzzv")
-- noremap("g#", "<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>zzzv")
