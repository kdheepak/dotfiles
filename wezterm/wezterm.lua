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

local home_dir = os.getenv("HOME")
local fmt = wezterm.format

-- Define process icons with colors and proper nerdfonts references
local process_icon = {
  rust = { { Foreground = { Color = "#f5a97f" } }, { Text = wezterm.nerdfonts.dev_rust } },
  vim = { { Foreground = { Color = "#89e051" } }, { Text = wezterm.nerdfonts.custom_vim } },
  git = { { Foreground = { Color = "#f85552" } }, { Text = wezterm.nerdfonts.dev_git } },
  python = { { Foreground = { Color = "#F7CE57" } }, { Text = wezterm.nerdfonts.dev_python } },
  shell = { { Foreground = { Color = "#cdd6f4" } }, { Text = wezterm.nerdfonts.cod_terminal } },
  bash_shell = { { Foreground = { Color = "#4EAA25" } }, { Text = wezterm.nerdfonts.cod_terminal_bash } },
  fish_shell = { { Foreground = { Color = "#52CE63" } }, { Text = wezterm.nerdfonts.md_fish } },
  zsh_shell = { { Foreground = { Color = "#f15a22" } }, { Text = wezterm.nerdfonts.dev_terminal } },
  runner = { { Foreground = { Color = "#b4befe" } }, { Text = wezterm.nerdfonts.fa_tasks } },
  docs = { { Text = wezterm.nerdfonts.md_book_open_variant } },
  node = { { Foreground = { Color = "#89e051" } }, { Text = wezterm.nerdfonts.md_hexagon } },
  update = { { Text = wezterm.nerdfonts.md_update } },
  brew = { { Text = wezterm.nerdfonts.md_beer } },

  -- Extended with nerdfonts
  go = { { Foreground = { Color = "#00ADD8" } }, { Text = wezterm.nerdfonts.seti_go } },
  java = { { Foreground = { Color = "#f89820" } }, { Text = wezterm.nerdfonts.dev_java } },
  cpp = { { Foreground = { Color = "#00599C" } }, { Text = wezterm.nerdfonts.seti_cpp } },
  c = { { Foreground = { Color = "#A8B9CC" } }, { Text = wezterm.nerdfonts.seti_c } },
  csharp = { { Foreground = { Color = "#239120" } }, { Text = wezterm.nerdfonts.md_language_csharp } },
  ruby = { { Foreground = { Color = "#CC342D" } }, { Text = wezterm.nerdfonts.cod_ruby } },
  php = { { Foreground = { Color = "#777BB4" } }, { Text = wezterm.nerdfonts.dev_php } },
  lua = { { Foreground = { Color = "#000080" } }, { Text = wezterm.nerdfonts.seti_lua } },
  typescript = { { Foreground = { Color = "#3178C6" } }, { Text = wezterm.nerdfonts.seti_typescript } },
  javascript = { { Foreground = { Color = "#F7DF1E" } }, { Text = wezterm.nerdfonts.dev_javascript_badge } },
  docker = { { Foreground = { Color = "#2496ED" } }, { Text = wezterm.nerdfonts.linux_docker } },
  kubernetes = { { Foreground = { Color = "#326CE5" } }, { Text = wezterm.nerdfonts.md_kubernetes } },
  database = { { Foreground = { Color = "#336791" } }, { Text = wezterm.nerdfonts.dev_database } },
  mysql = { { Foreground = { Color = "#4479A1" } }, { Text = wezterm.nerdfonts.dev_mysql } },
  postgres = { { Foreground = { Color = "#336791" } }, { Text = wezterm.nerdfonts.dev_postgresql } },
  redis = { { Foreground = { Color = "#DC382D" } }, { Text = wezterm.nerdfonts.dev_redis } },
  mongo = { { Foreground = { Color = "#47A248" } }, { Text = wezterm.nerdfonts.dev_mongodb } },
  terraform = { { Foreground = { Color = "#7B42BC" } }, { Text = wezterm.nerdfonts.seti_terraform } },
  ansible = { { Foreground = { Color = "#EE0000" } }, { Text = wezterm.nerdfonts.seti_ansible } },
  aws = { { Foreground = { Color = "#FF9900" } }, { Text = wezterm.nerdfonts.dev_aws } },
  azure = { { Foreground = { Color = "#0078D4" } }, { Text = wezterm.nerdfonts.md_microsoft_azure } },
  gcp = { { Foreground = { Color = "#4285F4" } }, { Text = wezterm.nerdfonts.md_google_cloud } },
  emacs = { { Foreground = { Color = "#7F5AB6" } }, { Text = wezterm.nerdfonts.custom_emacs } },
  vscode = { { Foreground = { Color = "#007ACC" } }, { Text = wezterm.nerdfonts.md_microsoft_visual_studio_code } },
  ssh = { { Foreground = { Color = "#4D4D4D" } }, { Text = wezterm.nerdfonts.md_ssh } },
  tmux = { { Foreground = { Color = "#1BB91F" } }, { Text = wezterm.nerdfonts.cod_terminal_tmux } },
  screen = { { Foreground = { Color = "#69B764" } }, { Text = wezterm.nerdfonts.cod_terminal } },
  make = { { Foreground = { Color = "#e37933" } }, { Text = wezterm.nerdfonts.seti_makefile } },
  gradle = { { Foreground = { Color = "#02303A" } }, { Text = wezterm.nerdfonts.seti_gradle } },
  maven = { { Foreground = { Color = "#C71E3B" } }, { Text = wezterm.nerdfonts.dev_apache } },
  npm = { { Foreground = { Color = "#CB3837" } }, { Text = wezterm.nerdfonts.md_npm } },
  yarn = { { Foreground = { Color = "#2C8EBB" } }, { Text = wezterm.nerdfonts.seti_yarn } },
  pnpm = { { Foreground = { Color = "#F69220" } }, { Text = wezterm.nerdfonts.md_npm } },
  deno = { { Foreground = { Color = "#000000" } }, { Text = wezterm.nerdfonts.seti_javascript } },
  bun = { { Foreground = { Color = "#FBF0DF" } }, { Text = wezterm.nerdfonts.md_bread_slice } },
  webpack = { { Foreground = { Color = "#8DD6F9" } }, { Text = wezterm.nerdfonts.seti_webpack } },
  vite = { { Foreground = { Color = "#646CFF" } }, { Text = wezterm.nerdfonts.md_lightning_bolt } },
  jupyter = { { Foreground = { Color = "#F37626" } }, { Text = wezterm.nerdfonts.seti_notebook } },
  conda = { { Foreground = { Color = "#44A833" } }, { Text = wezterm.nerdfonts.seti_python } },
  pipenv = { { Foreground = { Color = "#2E7EEA" } }, { Text = wezterm.nerdfonts.seti_python } },
  poetry = { { Foreground = { Color = "#60A5FA" } }, { Text = wezterm.nerdfonts.seti_python } },
  test = { { Foreground = { Color = "#00C851" } }, { Text = wezterm.nerdfonts.md_test_tube } },
  jest = { { Foreground = { Color = "#C21325" } }, { Text = wezterm.nerdfonts.seti_jest } },
  pytest = { { Foreground = { Color = "#0A9EDC" } }, { Text = wezterm.nerdfonts.seti_python } },
  mocha = { { Foreground = { Color = "#8D6748" } }, { Text = wezterm.nerdfonts.seti_mocha } },
  monitoring = { { Foreground = { Color = "#E6522C" } }, { Text = wezterm.nerdfonts.md_monitor_dashboard } },
  htop = { { Foreground = { Color = "#00D4AA" } }, { Text = wezterm.nerdfonts.md_chart_areaspline } },
  btop = { { Foreground = { Color = "#FF6E6E" } }, { Text = wezterm.nerdfonts.md_chart_areaspline } },
  btm = { { Foreground = { Color = "#FFA500" } }, { Text = wezterm.nerdfonts.mdi_chart_donut_variant } },
  top = { { Foreground = { Color = "#A0A0A0" } }, { Text = wezterm.nerdfonts.md_monitor } },
  nano = { { Foreground = { Color = "#4E4E4E" } }, { Text = wezterm.nerdfonts.dev_gnu } },
  less = { { Foreground = { Color = "#FFA500" } }, { Text = wezterm.nerdfonts.md_file_eye } },
  cat = { { Foreground = { Color = "#6B6B6B" } }, { Text = wezterm.nerdfonts.md_cat } },
  bat = { { Foreground = { Color = "#B58900" } }, { Text = wezterm.nerdfonts.md_bat } },
  curl = { { Foreground = { Color = "#073551" } }, { Text = wezterm.nerdfonts.mdi_flattr } },
  wget = { { Foreground = { Color = "#BE1919" } }, { Text = wezterm.nerdfonts.mdi_arrow_down_box } },
  systemctl = { { Foreground = { Color = "#4A9D4A" } }, { Text = wezterm.nerdfonts.md_cog } },
  journalctl = { { Foreground = { Color = "#4A9D4A" } }, { Text = wezterm.nerdfonts.md_text_box } },
  sudo = { { Foreground = { Color = "#FF0000" } }, { Text = wezterm.nerdfonts.fa_hashtag } },
  gh = { { Foreground = { Color = "#8250DF" } }, { Text = wezterm.nerdfonts.dev_github_badge } },
  topgrade = { { Foreground = { Color = "#06969A" } }, { Text = wezterm.nerdfonts.md_rocket_launch } },
  pacman = { { Foreground = { Color = "#1793D1" } }, { Text = "󰮯 " } },
  paru = { { Foreground = { Color = "#77B3F0" } }, { Text = "󰮯 " } },
  cmd = { { Foreground = { Color = "#C0C0C0" } }, { Text = wezterm.nerdfonts.md_console_line } },
  powershell = { { Foreground = { Color = "#012456" } }, { Text = wezterm.nerdfonts.md_console } },
  pwsh = { { Foreground = { Color = "#5391FE" } }, { Text = wezterm.nerdfonts.md_powershell } },
  lazygit = { { Foreground = { Color = "#F05032" } }, { Text = wezterm.nerdfonts.cod_github } },
  lazydocker = { { Foreground = { Color = "#2496ED" } }, { Text = wezterm.nerdfonts.linux_docker } },
}

local icons = {
  -- Text editors
  ["nvim"] = process_icon.vim,
  ["vim"] = process_icon.vim,
  ["vi"] = process_icon.vim,
  ["neovim"] = process_icon.vim,
  ["emacs"] = process_icon.emacs,
  ["code"] = process_icon.vscode,
  ["code-insiders"] = process_icon.vscode,
  ["nano"] = process_icon.nano,

  -- Version control
  ["git"] = process_icon.git,
  ["lazygit"] = process_icon.git,
  ["tig"] = process_icon.git,
  ["gh"] = process_icon.git,
  ["hub"] = process_icon.git,

  -- Programming languages
  ["python"] = process_icon.python,
  ["python3"] = process_icon.python,
  ["python3.9"] = process_icon.python,
  ["python3.10"] = process_icon.python,
  ["python3.11"] = process_icon.python,
  ["python3.12"] = process_icon.python,
  ["ipython"] = process_icon.python,
  ["pip"] = process_icon.python,
  ["pip3"] = process_icon.python,
  ["pipenv"] = process_icon.pipenv,
  ["poetry"] = process_icon.poetry,
  ["conda"] = process_icon.conda,
  ["jupyter"] = process_icon.jupyter,

  -- Shells
  ["fish"] = process_icon.shell,
  ["zsh"] = process_icon.shell,
  ["bash"] = process_icon.shell,
  ["sh"] = process_icon.shell,
  ["dash"] = process_icon.shell,
  ["ksh"] = process_icon.shell,
  ["tcsh"] = process_icon.shell,

  -- Rust ecosystem
  ["cargo"] = process_icon.rust,
  ["cargo-make"] = process_icon.rust,
  ["rustup"] = process_icon.rust,
  ["rust-analyzer"] = process_icon.rust,
  ["rustc"] = process_icon.rust,
  ["cr"] = process_icon.rust,
  ["ct"] = process_icon.rust,
  ["cargo-watch"] = process_icon.runner,

  -- Node.js ecosystem
  ["node"] = process_icon.node,
  ["nodejs"] = process_icon.node,
  ["npm"] = process_icon.npm,
  ["npx"] = process_icon.npm,
  ["yarn"] = process_icon.yarn,
  ["pnpm"] = process_icon.pnpm,
  ["deno"] = process_icon.deno,
  ["bun"] = process_icon.bun,
  ["tsx"] = process_icon.typescript,
  ["ts-node"] = process_icon.typescript,
  ["webpack"] = process_icon.webpack,
  ["vite"] = process_icon.vite,

  -- Go
  ["go"] = process_icon.go,
  ["gopls"] = process_icon.go,
  ["dlv"] = process_icon.go,

  -- Java ecosystem
  ["java"] = process_icon.java,
  ["javac"] = process_icon.java,
  ["gradle"] = process_icon.gradle,
  ["gradlew"] = process_icon.gradle,
  ["mvn"] = process_icon.maven,
  ["mvnw"] = process_icon.maven,

  -- C/C++
  ["gcc"] = process_icon.c,
  ["g++"] = process_icon.cpp,
  ["clang"] = process_icon.c,
  ["clang++"] = process_icon.cpp,
  ["make"] = process_icon.make,
  ["cmake"] = process_icon.make,
  ["cc"] = process_icon.c,

  -- C#/.NET
  ["dotnet"] = process_icon.csharp,
  ["csc"] = process_icon.csharp,

  -- Ruby
  ["ruby"] = process_icon.ruby,
  ["irb"] = process_icon.ruby,
  ["gem"] = process_icon.ruby,
  ["bundle"] = process_icon.ruby,
  ["bundler"] = process_icon.ruby,
  ["rake"] = process_icon.ruby,
  ["rails"] = process_icon.ruby,
  ["rspec"] = process_icon.ruby,

  -- PHP
  ["php"] = process_icon.php,
  ["composer"] = process_icon.php,
  ["artisan"] = process_icon.php,

  -- Lua
  ["lua"] = process_icon.lua,
  ["luac"] = process_icon.lua,

  -- Package managers
  ["brew"] = process_icon.brew,
  ["apt"] = process_icon.update,
  ["apt-get"] = process_icon.update,
  ["yum"] = process_icon.update,
  ["dnf"] = process_icon.update,
  ["pacman"] = process_icon.update,
  ["snap"] = process_icon.update,
  ["flatpak"] = process_icon.update,

  -- Documentation
  ["mdbook"] = process_icon.docs,
  ["man"] = process_icon.docs,
  ["info"] = process_icon.docs,
  ["help"] = process_icon.docs,

  -- Containers & orchestration
  ["docker"] = process_icon.docker,
  ["docker-compose"] = process_icon.docker,
  ["podman"] = process_icon.docker,
  ["kubectl"] = process_icon.kubernetes,
  ["k9s"] = process_icon.kubernetes,
  ["helm"] = process_icon.kubernetes,
  ["minikube"] = process_icon.kubernetes,

  -- Databases
  ["mysql"] = process_icon.mysql,
  ["mysqldump"] = process_icon.mysql,
  ["psql"] = process_icon.postgres,
  ["pg_dump"] = process_icon.postgres,
  ["redis-cli"] = process_icon.redis,
  ["mongo"] = process_icon.mongo,
  ["mongosh"] = process_icon.mongo,
  ["sqlite3"] = process_icon.database,
  ["sqlplus"] = process_icon.database,

  -- Infrastructure as Code
  ["terraform"] = process_icon.terraform,
  ["terragrunt"] = process_icon.terraform,
  ["ansible"] = process_icon.ansible,
  ["ansible-playbook"] = process_icon.ansible,

  -- Cloud CLIs
  ["aws"] = process_icon.aws,
  ["az"] = process_icon.azure,
  ["gcloud"] = process_icon.gcp,
  ["gsutil"] = process_icon.gcp,

  -- Terminal multiplexers
  ["tmux"] = process_icon.tmux,
  ["screen"] = process_icon.screen,

  -- SSH & remote
  ["ssh"] = process_icon.ssh,
  ["scp"] = process_icon.ssh,
  ["rsync"] = process_icon.ssh,
  ["sftp"] = process_icon.ssh,

  -- Testing
  ["jest"] = process_icon.jest,
  ["vitest"] = process_icon.test,
  ["pytest"] = process_icon.pytest,
  ["mocha"] = process_icon.mocha,
  ["rspec"] = process_icon.test,
  ["go test"] = process_icon.test,

  -- Monitoring & system
  ["htop"] = process_icon.htop,
  ["btop"] = process_icon.btop,
  ["top"] = process_icon.top,
  ["ps"] = process_icon.monitoring,
  ["netstat"] = process_icon.monitoring,
  ["lsof"] = process_icon.monitoring,
  ["systemctl"] = process_icon.systemctl,
  ["journalctl"] = process_icon.journalctl,
  ["service"] = process_icon.systemctl,

  -- File operations
  ["less"] = process_icon.less,
  ["more"] = process_icon.less,
  ["cat"] = process_icon.cat,
  ["bat"] = process_icon.bat,
  ["tail"] = process_icon.cat,
  ["head"] = process_icon.cat,

  -- Network tools
  ["curl"] = process_icon.curl,
  ["wget"] = process_icon.wget,
  ["ping"] = process_icon.curl,
  ["nmap"] = process_icon.curl,
  ["nc"] = process_icon.curl,
  ["netcat"] = process_icon.curl,

  -- Runners and watchers
  ["watch"] = process_icon.runner,
  ["entr"] = process_icon.runner,
  ["nodemon"] = process_icon.runner,
  ["pm2"] = process_icon.runner,
  ["supervisor"] = process_icon.runner,
  ["forever"] = process_icon.runner,
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
  process_name_cache[name] = fmt(icons[name:match("[^/]*$")] or "  ")
  return process_name_cache[name]
end

local function ps(tab)
  local t = process_name_cache[tab.active_pane.foreground_process_name]
    or ps_cacher(tab.active_pane.foreground_process_name)
  return " " .. t .. " "
end

local function cwd(tab)
  local dir = tab.active_pane.current_working_dir
  return current_dir_cache[dir and dir.file_path or "DEBUG"] or cwd_cacher(dir.file_path)
end

local active_bg = config.colors.tab_bar.active_tab.bg_color
local inactive_bg = config.colors.tab_bar.inactive_tab.bg_color

local BOLD = { Attribute = { Intensity = "Bold" } }
local NORMAL = { Attribute = { Intensity = "Normal" } }
local THICK_ARROW = { Text = "" }
local THIN_ARROW = { Text = "" }

---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
  local t = #tabs
  for i = 1, t do
    if tabs[i].tab_id == tab.tab_id then
      if tab.is_active then
        return {
          { Foreground = { Color = active_bg } },
          { Background = { Color = inactive_bg } },
          THIN_ARROW,
          { Foreground = { Color = active_bg } },
          { Background = { Color = inactive_bg } },
          { Text = ps(tab) },
          { Foreground = { Color = inactive_bg } },
          { Background = { Color = active_bg } },
          THICK_ARROW,
          BOLD,
          { Text = " " .. i .. cwd(tab) },
          { Foreground = { Color = active_bg } },
          { Background = { Color = inactive_bg } },
          THICK_ARROW,
        }
      elseif i == 1 and tabs[i + 1] and tabs[i + 1].is_active then
        return {
          THIN_ARROW,
          NORMAL,
          { Text = ps(tab) .. i .. cwd(tab) },
        }
      elseif tabs[i + 1] and tabs[i + 1].is_active then
        return {
          NORMAL,
          { Text = ps(tab) .. i .. cwd(tab) },
        }
      elseif i == 1 then
        return {
          THIN_ARROW,
          NORMAL,
          { Text = ps(tab) .. i .. cwd(tab) },
          { Foreground = { Color = active_bg } },
          { Background = { Color = inactive_bg } },
          THIN_ARROW,
          { Foreground = { Color = inactive_bg } },
          { Background = { Color = active_bg } },
        }
      else
        return {
          NORMAL,
          { Text = ps(tab) .. i .. cwd(tab) },
          { Foreground = { Color = active_bg } },
          { Background = { Color = inactive_bg } },
          THIN_ARROW,
          { Foreground = { Color = inactive_bg } },
          { Background = { Color = active_bg } },
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
