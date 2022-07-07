local wilder = require("wilder")
wilder.setup({ modes = { ":", "/", "?" } })
-- Disable Python remote plugin
wilder.set_option("use_python_remote_plugin", 0)

wilder.set_option("pipeline", {
  wilder.branch(
    wilder.cmdline_pipeline({
      fuzzy = 1,
      fuzzy_filter = wilder.lua_fzy_filter(),
    }),
    wilder.vim_search_pipeline()
  ),
})

wilder.set_option(
  "renderer",
  wilder.renderer_mux({
    [":"] = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
      min_width = "50%",
      max_height = "20%",
      reverse = 0,
      border = "rounded",
      highlights = {
        border = "Normal", -- highlight to use for the border
      },
      highlighter = wilder.lua_fzy_highlighter(),
      left = {
        " ",
        wilder.popupmenu_devicons(),
      },
      right = {
        " ",
        wilder.popupmenu_scrollbar(),
      },
    })),
    ["/"] = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
      min_width = "50%",
      max_height = "20%",
      reverse = 0,
      border = "rounded",
      highlights = {
        border = "Normal", -- highlight to use for the border
      },
      highlighter = wilder.lua_fzy_highlighter(),
      left = {
        " ",
        wilder.popupmenu_devicons(),
      },
      right = {
        " ",
        wilder.popupmenu_scrollbar(),
      },
    })),
    ["?"] = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
      min_width = "50%",
      max_height = "20%",
      reverse = 0,
      border = "rounded",
      highlights = {
        border = "Normal", -- highlight to use for the border
      },
      highlighter = wilder.lua_fzy_highlighter(),
      left = {
        " ",
        wilder.popupmenu_devicons(),
      },
      right = {
        " ",
        wilder.popupmenu_scrollbar(),
      },
    })),
  })
)
