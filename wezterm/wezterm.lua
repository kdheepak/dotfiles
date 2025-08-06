-- Pull in the wezterm API
local wezterm = require("wezterm")

local is_os_unix = string.sub(package.config, 1, 1) == "/"
local zsh = { "zsh", "--interactive" }
local bash = { "bash", "-i" }
local git_bash = { "~/AppData/Local/Programs/Git/bin/bash.exe", "--login" }

local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

if not is_os_unix then
  config.default_prog = git_bash
end

local function iosevka(weight, style)
  return wezterm.font_with_fallback(
    { "IosevkaFireTerm Nerd Font Mono", "FlogSymbols" },
    { weight = weight, style = style }
  )
end

wezterm.on("gui-startup", function()
  local tab, pane, window = wezterm.mux.spawn_window({})
  window:gui_window():maximize()
  window:gui_window():focus()
end)

config.inactive_pane_hsb = {
  saturation = 1,
  brightness = 1,
}

config.color_scheme = "rose-pine"
config.colors = {
  selection_bg = "#44475a", -- or any color that contrasts well
  selection_fg = "none", -- "none" means it will use the existing foreground
}

local basename = function(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local tab_title = function(tab_info)
  local active_pane = tab_info.active_pane
  local current_dir = basename(tostring(active_pane.current_working_dir))

  local active_process = active_pane.foreground_process_name
  local tab_title = string.lower(active_pane.title)
  local tab_index = tostring(tab_info.tab_index + 1)
  local icon = wezterm.nerdfonts.cod_terminal
  local text_color = "#f5f5f5"

  if string.find(tab_title, "nvim") then
    icon = wezterm.nerdfonts.custom_neovim
    text_color = "#f5f5f5"
  elseif string.find(tab_title, "lazygit") then
    icon = wezterm.nerdfonts.fa_git
    text_color = "#f5f5f5"
  elseif string.find(active_process, "node") then
    icon = wezterm.nerdfonts.dev_nodejs_small
    text_color = "#f5f5f5"
  elseif string.find(active_process, "net") then
    icon = wezterm.nerdfonts.md_dot_net
    text_color = "#f5f5f5"
  end

  if tab_index and #tab_index > 0 then
    return " " .. tab_index .. ": " .. current_dir .. " " .. icon .. " ", text_color
  end

  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local background = "#5c6d74"
  local edge_background = "none"
  if tab.is_active then
    background = "#0969da"
  end
  local edge_foreground = background
  local title, text_color = tab_title(tab)
  if tab.is_active then
    return {
      { Background = { Color = "#0969da" } },
      { Foreground = { Color = text_color } },
      { Text = title },
    }
  else
    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = title },
    }
  end
end)

config.default_cursor_style = "BlinkingBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.tab_bar_at_bottom = true
config.enable_tab_bar = true
config.audible_bell = "Disabled"
config.font_size = 12
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true

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

wezterm.on("trigger-vim-with-scrollback", function(window, pane)
  -- Retrieve the text from the pane
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

  -- Create a temporary file to pass to vim
  local name = os.tmpname()
  local f = io.open(name, "w+")
  if f == nil then
    return
  end
  f:write(text)
  f:flush()
  f:close()

  -- Open a new window running vim and tell it to open the file
  window:perform_action(
    act.SpawnCommandInNewWindow({
      args = { "vim", name },
    }),
    pane
  )

  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  --
  -- Note: We don't strictly need to remove this file, but it is nice
  -- to avoid cluttering up the temporary directory.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
  enabled_modules = {
    username = false,
    hostname = false,
  },
})

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
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
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
  {
    key = "e",
    mods = "LEADER",
    action = act.EmitEvent("trigger-vim-with-scrollback"),
  },
  { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-0.8) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(0.8) },
  { key = "Enter", mods = "SHIFT", action = act.SendString("\n") },
}

config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

return config
