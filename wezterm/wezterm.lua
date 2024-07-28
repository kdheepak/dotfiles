-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function iosevka(weight, style)
  return wezterm.font("IosevkaFireTerm Nerd Font Mono", { weight = weight, style = style })
end

config = {
  color_scheme = "rose-pine",
  default_cursor_style = "BlinkingBar",
  automatically_reload_config = true,
  window_close_confirmation = "NeverPrompt",
  adjust_window_size_when_changing_font_size = false,
  window_decorations = "RESIZE",
  check_for_updates = false,
  use_fancy_tab_bar = false,
  default_prog = { "zellij" },
  tab_bar_at_bottom = false,
  font_size = 12,
  font_rules = {
    {
      intensity = "Normal",
      italic = false,
      font = iosevka("Medium", "Normal"),
    },
    {
      intensity = "Normal",
      italic = true,
      font = iosevka("Medium", "Italic"),
    },
    {
      intensity = "Bold",
      italic = false,
      font = iosevka("ExtraBold", "Normal"),
    },
    {
      intensity = "Bold",
      italic = true,
      font = iosevka("ExtraBold", "Italic"),
    },
    {
      intensity = "Half",
      italic = false,
      font = iosevka("Regular", "Normal"),
    },
    {
      intensity = "Half",
      italic = true,
      font = iosevka("Regular", "Italic"),
    },
  },
  enable_tab_bar = false,
  window_padding = {
    left = 3,
    right = 3,
    top = 0,
    bottom = 0,
  },
  -- from: https://akos.ma/blog/adopting-wezterm/
  hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    {
      regex = "\\((\\w+://\\S+)\\)",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
      regex = "\\[(\\w+://\\S+)\\]",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
      regex = "\\{(\\w+://\\S+)\\}",
      format = "$1",
      highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
      regex = "<(\\w+://\\S+)>",
      format = "$1",
      highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
      -- Before
      --regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
      --format = '$0',
      -- After
      regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
      format = "$1",
      highlight = 1,
    },
    -- implicit mailto link
    {
      regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
      format = "mailto:$0",
    },
  },
}
return config
