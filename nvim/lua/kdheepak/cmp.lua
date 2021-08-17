-- vim: foldmethod=marker

local fn = vim.fn
local cmp = require "cmp"
local core = require "cmp.core"
local cmp = require "cmp"
local types = require "cmp.types"

require("cmp_nvim_lsp").setup()

cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    documentation = {
        border = "solid",
    },
    sources = {
        {name = "nvim_lsp"},
        {name = "luasnip"},
        {name = "path"},
        {name = "buffer"},
    },
    mapping = {
        ["<c-j>"] = cmp.mapping.next_item(),
        ["<c-k>"] = cmp.mapping.prev_item(),
        -- ['<C-u>'] = cmp.mapping.scroll(-4),
        -- ['<C-d>'] = cmp.mapping.scroll(4),
        -- ["<C-l>"] = cmp.mapping.complete(),
        -- ["<C-e>"] = cmp.mapping.close(),
        ["<c-l>"] = function()
            if fn.pumvisible() ~= 0 and fn.complete_info()["selected"] ~= -1 then
                local e = core.menu:get_selected_entry() or (core.menu:get_first_entry())
                core.confirm(e, {
                    behavior = cmp.ConfirmBehavior.Replace,
                    }, function()
                    core.complete(
                    core.get_context {reason = types.cmp.ContextReason.TriggerOnly})
                end)
                return
            end

            local prev_col, next_col = fn.col "." - 1, fn.col "."
            local prev_char = fn.getline("."):sub(prev_col, prev_col)
            local next_char = fn.getline("."):sub(next_col, next_col)

            -- minimal autopairs-like behaviour
            if prev_char == "{" and next_char ~= "}" then
                return vim.api.nvim_replace_termcodes("<CR>}<C-o>O", true, true, true)
            end
            if prev_char == "[" and next_char ~= "]" then
                return vim.api.nvim_replace_termcodes("<CR>]<C-o>O", true, true, true)
            end
            if prev_char == "(" and next_char ~= ")" then
                return vim.api.nvim_replace_termcodes("<CR>)<C-o>O", true, true, true)
            end
            if prev_char == ">" and next_char == "<" then
                return vim.api.nvim_replace_termcodes("<CR><C-o>O", true, true, true)
            end -- html indents

            return vim.api.nvim_replace_termcodes("<CR>", true, true, true)
        end
    },
}
