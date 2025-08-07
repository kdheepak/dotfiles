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

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.color_scheme = "rose-pine"

local hours_icons = {
  ["00"] = wezterm.nerdfonts.md_clock_time_twelve_outline,
  ["01"] = wezterm.nerdfonts.md_clock_time_one_outline,
  ["02"] = wezterm.nerdfonts.md_clock_time_two_outline,
  ["03"] = wezterm.nerdfonts.md_clock_time_three_outline,
  ["04"] = wezterm.nerdfonts.md_clock_time_four_outline,
  ["05"] = wezterm.nerdfonts.md_clock_time_five_outline,
  ["06"] = wezterm.nerdfonts.md_clock_time_six_outline,
  ["07"] = wezterm.nerdfonts.md_clock_time_seven_outline,
  ["08"] = wezterm.nerdfonts.md_clock_time_eight_outline,
  ["09"] = wezterm.nerdfonts.md_clock_time_nine_outline,
  ["10"] = wezterm.nerdfonts.md_clock_time_ten_outline,
  ["11"] = wezterm.nerdfonts.md_clock_time_eleven_outline,
  ["12"] = wezterm.nerdfonts.md_clock_time_twelve, -- 12:00 in solid icon
  ["13"] = wezterm.nerdfonts.md_clock_time_one, -- 1:00 in solid icon
  ["14"] = wezterm.nerdfonts.md_clock_time_two, -- 2:00 in solid icon
  ["15"] = wezterm.nerdfonts.md_clock_time_three, -- 3:00 in solid icon
  ["16"] = wezterm.nerdfonts.md_clock_time_four, -- 4:00 in solid icon
  ["17"] = wezterm.nerdfonts.md_clock_time_five, -- 5:00 in solid icon
  ["18"] = wezterm.nerdfonts.md_clock_time_six, -- 6:00 in solid icon
  ["19"] = wezterm.nerdfonts.md_clock_time_seven, -- 7:00 in solid icon
  ["20"] = wezterm.nerdfonts.md_clock_time_eight, -- 8:00 in solid icon
  ["21"] = wezterm.nerdfonts.md_clock_time_nine, -- 9:00 in solid icon
  ["22"] = wezterm.nerdfonts.md_clock_time_ten, -- 10:00 in solid icon
  ["23"] = wezterm.nerdfonts.md_clock_time_eleven, -- 11:00 in solid icon
}

local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)
modal.set_default_keys(config)

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

local leader = {
  icon = "❯",
  on = "❮",
  off = "❯",
  padding = {
    left = " ",
    right = "",
  },
}

local leader_component = function()
  local prefix = leader.padding.left or leader.prefix or " "
  local suffix = leader.padding.right or leader.suffix or ""
  local leaderstr = prefix .. leader.icon .. suffix
  return leaderstr
end

local ordinal = function(n)
  -- local suffixes = { "th", "st", "nd", "rd" }
  -- local mod100 = n % 100
  -- return n .. (suffixes[(mod100 - 20) % 10 + 1] or suffixes[1])
  return n
end

local rosepine_overrides = {
  normal_mode = {
    a = { fg = "#191724", bg = "#ebbcba" }, -- iris
    b = { fg = "#ebbcba", bg = "#26233a" }, -- surface
    c = { fg = "#e0def4", bg = "#191723" }, -- text on base
  },
  copy_mode = {
    a = { fg = "#191724", bg = "#f6c177" }, -- gold
  },
  search_mode = {
    a = { fg = "#191724", bg = "#31748f" }, -- pine
  },
  tab = {
    active = { fg = "#ffffff", bg = "#31748f" },
    inactive = { fg = "#e0def4", bg = "#191723" },
    inactive_hover = { fg = "#9ccfd8", bg = "#191723" },
  },
}
local cwd = {
  "cwd",
  padding = { left = 0, right = 1 },
  max_length = 30,
}

tabline.setup({
  options = {
    theme_overrides = rosepine_overrides,
    icons_enabled = true,
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thin,
      right = wezterm.nerdfonts.ple_left_half_circle_thin,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = "", -- wezterm.nerdfonts.ple_left_hard_divider_inverse doesn't work for some reason
    },
  },
  sections = {
    tabline_a = { leader_component, { "mode", padding = { left = 1, right = 1 } } },
    tabline_b = {},
    tabline_c = { " " },
    tab_active = {
      { "zoomed", icon = wezterm.nerdfonts.oct_zoom_in, padding = { left = 0, right = 0 } },
      {
        "index",
        fmt = function(n, _)
          return ordinal(n)
        end,
        padding = { left = 1, right = 0 },
      },
      ".",
      { "process", icons_only = true, padding = { left = 1, right = 0 } },
      cwd,
      {
        "tab",
        fmt = function(str)
          if str ~= "default" then
            return str .. wezterm.nerdfonts.pl_left_soft_divider
          else
            return ""
          end
        end,
        padding = { left = 0, right = 1 },
        icons_enabled = false,
      },
    },
    tab_inactive = {
      {
        "zoomed",
        icon = wezterm.nerdfonts.oct_zoom_in,
        padding = { left = 0, right = 0 },
      },
      {
        "index",
        fmt = function(n, _)
          return ordinal(n)
        end,
        padding = { left = 1, right = 0 },
      },
      ".",
      { "process", icons_only = true, padding = { left = 1, right = 0 } },
      cwd,
      {
        "tab",
        fmt = function(str)
          if str ~= "default" then
            return str .. " "
          else
            return ""
          end
        end,
        padding = { left = 0, right = 0 },
        icons_enabled = false,
      },
      wezterm.nerdfonts.pl_left_soft_divider,
    },
    tabline_x = {
      { "ram" },
      { "cpu" },
    },
    tabline_y = {
      {
        "datetime",
        style = "%H:%M",
        hour_to_icon = hours_icons,
      },
      { "battery" },
    },
    tabline_z = { "domain" },
  },
  extensions = {},
})

config.colors = {
  tab_bar = {
    background = rosepine_overrides.normal_mode.c.bg,
  },
  selection_bg = "#44475a", -- or any color that contrasts well
  selection_fg = "none", -- "none" means it will use the existing foreground
}

config.default_cursor_style = "BlinkingBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.tab_bar_at_bottom = true
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 64
config.show_new_tab_button_in_tab_bar = false
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

wezterm.plugin.require("https://gitlab.com/xarvex/presentation.wez").apply_to_config(config)

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
  direction_keys = {
    move = { "h", "j", "k", "l" },
    resize = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
  },
  modifiers = {
    move = "CTRL",
    resize = "CTRL",
  },
})

return config
