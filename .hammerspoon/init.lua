hyper = {"ctrl", "alt", "cmd", "shift"}
hypershift = {"ctrl", "alt", "cmd"}
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

mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end
hs.hotkey.bind({"cmd","alt","shift"}, "D", mouseHighlight)

function move_window(direction)
    return function()
        local win      = hs.window.focusedWindow()
        local app      = win:application()
        local app_name = app:name()
        local f        = win:frame()
        local screen   = win:screen()
        local max      = screen:frame()
        if direction == "left" then
            f.x = max.x + 6
            f.w = (max.w / 2) - 9
        elseif direction == "right" then
            f.x = (max.x + (max.w / 2)) + 3
            f.w = (max.w / 2) - 9
        elseif direction == "up" then
            f.x = max.x + 6
            f.w = max.w - 12
        elseif direction == "down" then
            f.x = (max.x + (max.w / 8)) + 6
            f.w = (max.w * 3 / 4) - 12
        end
        f.y = max.y + 6
        f.h = max.h - 12
        win:setFrame(f, 0.0)
    end
end
hs.hotkey.bind(hyper, "h", move_window("left"))
hs.hotkey.bind(hyper, "l", move_window("right"))
hs.hotkey.bind(hyper, "k", move_window("up"))
hs.hotkey.bind(hyper, "j", move_window("down"))

hs.alert.show("Config loaded!")
