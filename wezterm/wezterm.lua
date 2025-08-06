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

  brights = {
    "#f2cdcd", -- "grey",
    "#ff6188", -- "red",
    "#a8dc76", -- "lime",
    "#ffd966", -- "yellow",
    "#82A6ED", -- "blue",
    "#D499FF", -- "fuchsia",
    "#94e2d5", -- "aqua",
    "#FCFCFA", -- "white",
  },

  ansi = {
    "#f2cdcd",
    "#ff6188",
    "#a8dc76",
    "#ffd966",
    "#82A6ED",
    "#D499FF",
    "#94e2d5",
    "#FCFCFA",
  },

  tab_bar = {
    background = "#1F1D20",
    active_tab = {
      bg_color = "#ebbcba",
      fg_color = "#1f1d2e",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
    inactive_tab = {
      bg_color = "#1f1d2e",
      fg_color = "#ebbcba",
      intensity = "Half",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
    new_tab = {
      bg_color = "#1F1D20",
      fg_color = "#ebbcba",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
  },
}
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Powerline separator symbols
local separators = {
  right_filled = "", -- U+E0B0
  right_thin = "", -- U+E0B1
  left_filled = "", -- U+E0B2
  left_thin = "", -- U+E0B3
}

local icons = {
  ["C:\\WINDOWS\\system32\\cmd.exe"] = wezterm.nerdfonts.md_console_line,
  ["Topgrade"] = wezterm.nerdfonts.md_rocket_launch,
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["curl"] = wezterm.nerdfonts.mdi_flattr,
  ["docker"] = wezterm.nerdfonts.linux_docker,
  ["docker-compose"] = wezterm.nerdfonts.linux_docker,
  ["fish"] = wezterm.nerdfonts.md_fish,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["git"] = wezterm.nerdfonts.dev_git,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["htop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["btop"] = wezterm.nerdfonts.md_chart_areaspline,
  ["kubectl"] = wezterm.nerdfonts.linux_docker,
  ["kuberlr"] = wezterm.nerdfonts.linux_docker,
  ["lazydocker"] = wezterm.nerdfonts.linux_docker,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["node"] = wezterm.nerdfonts.mdi_hexagon,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["pacman"] = "󰮯 ",
  ["paru"] = "󰮯 ",
  ["psql"] = wezterm.nerdfonts.dev_postgresql,
  ["pwsh.exe"] = wezterm.nerdfonts.md_console,
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
  ["lazygit"] = wezterm.nerdfonts.cod_github,
}

local BOLD = { Attribute = { Intensity = "Bold" } }
local NORMAL = { Attribute = { Intensity = "Normal" } }
local THICK_ARROW = { Text = "" }
local THIN_ARROW = { Text = "" }

local home_dir = os.getenv("HOME")
local fmt = wezterm.format

local process_icon = {
  rust = { { Foreground = { Color = "#f5a97f" } }, { Text = "  " } },
  vim = { { Foreground = { Color = "#89e051" } }, { Text = "  " } },
  git = { Foreground = { Color = "#41535b" }, { Text = " 󰊢 " } },
  python = { { Foreground = { Color = "#F7CE57" } }, { Text = "  " } },
  shell = { { Foreground = { Color = "#cdd6f4" } }, { Text = "  " } },
  runner = { { Foreground = { Color = "#b4befe" } }, { Text = " 󰜎 " } },
  docs = { { Text = "  " } },
  node = { { Foreground = { Color = "#89e051" } }, { Text = " 󰎙 " } },
  update = { { Text = "  " } },
  brew = { { Text = " 󱄖 " } },
}

local icons = {
  ["nvim"] = process_icon.vim,
  ["git"] = process_icon.git,
  ["lazygit"] = process_icon.git,
  ["Python"] = process_icon.python,
  ["fish"] = process_icon.shell,
  ["zsh"] = process_icon.shell,
  ["bash"] = process_icon.shell,
  ["cargo-make"] = process_icon.rust,
  ["cargo"] = process_icon.rust,
  ["rustup"] = process_icon.rust,
  ["rust-analyzer"] = process_icon.rust,
  ["cr"] = process_icon.rust,
  ["ct"] = process_icon.rust,
  ["mdbook"] = process_icon.docs,
  ["cargo-watch"] = process_icon.runner,
  ["watch"] = process_icon.runner,
  ["node"] = process_icon.node,
  ["ruby"] = process_icon.brew,
}

local process_name_cache = {}
local current_dir_cache = {
  [home_dir] = "~ ",
  DEBUG = " ",
}

local function cwd_cacher(name)
  current_dir_cache[name] = " " .. name:match("[^/]*$") .. " "
  return current_dir_cache[name]
end

local function ps_cacher(name)
  process_name_cache[name] = fmt(icons[name:match("[^/]*$")] or {
    { Text = "  " },
    -- name:match("[^/]*$") .. " "
  })
  return process_name_cache[name]
end

local function ps(tab)
  return process_name_cache[tab.active_pane.foreground_process_name]
    or ps_cacher(tab.active_pane.foreground_process_name)
end

local function cwd(tab)
  local dir = tab.active_pane.current_working_dir
  return current_dir_cache[dir and dir.file_path or "DEBUG"] or cwd_cacher(dir.file_path)
end

local active_bg = config.colors.tab_bar.active_tab.bg_color
local inactive_bg = config.colors.tab_bar.inactive_tab.bg_color

---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
  local t = #tabs
  for i = 1, t do
    if tabs[i].tab_id == tab.tab_id then
      if tab.is_active then
        return {
          BOLD,
          { Text = ps(tab) .. i .. cwd(tab) },
          { Foreground = { Color = active_bg } },
          { Background = { Color = inactive_bg } },
          THICK_ARROW,
        }
      elseif tabs[i + 1] and tabs[i + 1].is_active then
        return {
          NORMAL,
          { Text = ps(tab) .. i .. cwd(tab) },
          { Foreground = { Color = inactive_bg } },
          { Background = { Color = active_bg } },
          THICK_ARROW,
        }
      else
        return {
          NORMAL,
          { Text = ps(tab) .. i .. cwd(tab) },
          { Foreground = { Color = active_bg } },
          { Background = { Color = inactive_bg } },
          THIN_ARROW,
        }
      end
    end
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
