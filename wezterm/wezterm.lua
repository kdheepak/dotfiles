-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function iosevka(weight, style)
  return wezterm.font("IosevkaFireTerm Nerd Font Mono", { weight = weight, style = style })
end

wezterm.on("gui-startup", function()
  local tab, pane, window = wezterm.mux.spawn_window({})
  window:gui_window():maximize()
  window:gui_window():focus()
end)

config.color_scheme = "rose-pine"
config.default_cursor_style = "BlinkingBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
-- config.default_prog = { "/bin/zsh", "-l", "-c", "~/.local/share/mise/shims/zellij" }
config.tab_bar_at_bottom = true
config.enable_tab_bar = true
config.audible_bell = "Disabled"
config.font_size = 12

config.font_rules = {
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
}

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
-- from: https://akos.ma/blog/adopting-wezterm/
config.hyperlink_rules = {
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
}

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
  enabled_modules = {
    username = false,
    hostname = false,
  },
})

local act = wezterm.action

config.leader = { key = "`", timeout_milliseconds = 1000 }

config.keys = {
  { key = "`", mods = "LEADER", action = act.SendString("`") },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9", mods = "LEADER", action = act.ActivateTab(8) },
  { key = "0", mods = "LEADER", action = act.ActivateTab(9) },
  { key = "Space", mods = "LEADER", action = act.ActivateLastTab },
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  {
    key = "/",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "\\",
    mods = "LEADER",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  { key = "Z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "]", mods = "LEADER", action = act.PasteFrom("Clipboard") },
  {
    key = "u",
    mods = "LEADER",
    action = act.CharSelect({
      copy_on_select = true,
      copy_to = "ClipboardAndPrimarySelection",
    }),
  },
  {
    key = "o",
    mods = "LEADER",
    action = act({
      QuickSelectArgs = {
        label = "OPEN URL",
        patterns = {
          "https?://\\S+",
          "git://\\S+",
          "ssh://\\S+",
          "ftp://\\S+",
          "file://\\S+",
          "mailto://\\S+",
          [[h?t?t?p?s?:?/?/?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-zA-Z0-9]{2,6}\b[-a-zA-Z0-9@:%_\+.~#?&/=]*]],
          [[h?t?t?p?:?/?/?localhost:?[0-9]*/?\b[-a-zA-Z0-9@:%_\+.~#?&/=]*]],
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.log_info("opening: " .. url)
          wezterm.open_with(url)
        end),
      },
    }),
  },
  { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-0.8) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(0.8) },
}

return config
