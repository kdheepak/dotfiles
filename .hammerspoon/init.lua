hyper = {"ctrl", "alt", "cmd"}
hypershift = {"ctrl", "alt", "cmd", "shift"}
cmdctrlshift = {"cmd", "ctrl", "shift"}

hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.window.animationDuration = 0 -- disable animations

-- Reload configuration
-- Download and install http://www.hammerspoon.org/Spoons/SpoonInstall.html
hs.loadSpoon("SpoonInstall")

-- http://www.hammerspoon.org/Spoons/ReloadConfiguration.html
spoon.SpoonInstall:andUse("ReloadConfiguration",
               {
                    config = { watch_paths = { os.getenv("HOME") .. "/GitRepos/dotfiles/.hammerspoon" } },
                    hotkeys = { reloadConfiguration = { hyper, "r" } },
                    start = true,
               }
)

hs.alert.show("Config loaded!")
