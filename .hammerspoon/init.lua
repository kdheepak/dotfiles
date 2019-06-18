ctrlaltcmdshift = {"ctrl", "alt", "cmd", "shift"}
ctrlaltcmd = {"ctrl", "alt", "cmd"}
cmdctrlshift = {"cmd", "ctrl", "shift"}

-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, "F17")
hyperCounter = 0

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    hs.eventtap.keyStroke({}, "ESCAPE")
    -- double tap hyper to find mouse cursor
    hyperCounter = hyperCounter + 1
    hs.timer.doAfter(0.050, function()
        if hyperCounter >= 2 then
            mouseHighlight()
            hyperCounter = 0
        else
            hyperCounter = 0
        end
    end)
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, "F18", enterHyperMode, exitHyperMode)

-------------------------------------------------------------------------------------

hs.grid.setGrid("12x12")
hs.grid.MARGINX = 10
hs.grid.MARGINY = 0
hs.window.animationDuration = 0 -- disable animations

hyper:bind({}, "3", function () -- hyper #
    local windows = hs.window.allWindows()
    for i in pairs(windows) do
        local window = windows[i]
        hs.grid.snap(window)
    end
    hyper.triggered = true
end)

hyper:bind({}, "s", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "a", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = (max.w / 2)
    f.h = max.h

    hs.alert.show("max.x = " .. max.x)
    hs.alert.show("max.y = " .. max.y)
    hs.alert.show("max.w = " .. max.w)
    hs.alert.show("max.h = " .. max.h)

    hs.alert.show("f.x = " .. f.x)
    hs.alert.show("f.y = " .. f.y)
    hs.alert.show("f.w = " .. f.w)
    hs.alert.show("f.h = " .. f.h)

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "d", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = (max.w / 2)
    f.h = max.h

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "w", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h / 2

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "x", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h / 2

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "q", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "z", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "e", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h / 2

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({}, "c", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2

    hs.alert.show("max.x = " .. max.x)
    hs.alert.show("max.y = " .. max.y)
    hs.alert.show("max.w = " .. max.w)
    hs.alert.show("max.h = " .. max.h)

    hs.alert.show("f.x = " .. f.x)
    hs.alert.show("f.y = " .. f.y)
    hs.alert.show("f.w = " .. f.w)
    hs.alert.show("f.h = " .. f.h)

    win:setFrame(f)
    hyper.triggered = true
end)

hyper:bind({"shift"}, "[", function ()
    hs.eventtap.keyStroke({"ctrl"}, "down")
    hyper.triggered = true
end)
hyper:bind({"shift"}, "]", function ()
    hs.eventtap.keyStroke({"ctrl"}, "up")
    hyper.triggered = true
end)
hyper:bind({}, "[", function ()
    hs.eventtap.keyStroke({"ctrl"}, "left")
    hyper.triggered = true
end)
hyper:bind({}, "]", function ()
    hs.eventtap.keyStroke({"ctrl"}, "right")
    hyper.triggered = true
end)

hyper:bind({"shift"}, "j", function ()
    hs.grid.pushWindowDown(hs.window.focusedWindow())
    hyper.triggered = true
end)
hyper:bind({"shift"}, "k", function ()
    hs.grid.pushWindowUp(hs.window.focusedWindow())
    hyper.triggered = true
end)
hyper:bind({"shift"}, "h", function ()
    hs.grid.pushWindowLeft(hs.window.focusedWindow())
    hyper.triggered = true
end)
hyper:bind({"shift"}, "l", function ()
    hs.grid.pushWindowRight(hs.window.focusedWindow())
    hyper.triggered = true
end)

hyper:bind({"ctrl", "shift"}, "h", function()
    hs.grid.resizeWindowThinner(hs.window.focusedWindow())
    hyper.triggered = true
end)
hyper:bind({"ctrl", "shift"}, "l", function()
    hs.grid.resizeWindowWider(hs.window.focusedWindow())
    hyper.triggered = true
end)
hyper:bind({"ctrl", "shift"}, "j", function()
    hs.grid.resizeWindowTaller(hs.window.focusedWindow())
    hyper.triggered = true
end)
hyper:bind({"ctrl", "shift"}, "k", function()
    hs.grid.resizeWindowShorter(hs.window.focusedWindow())
    hyper.triggered = true
end)

hyper:bind({}, "left", function()
    -- move the focused window one display to the left
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest()
    hyper.triggered = true
end)

hyper:bind({}, "right", function()
    -- move the focused window one display to the right
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast()
    hyper.triggered = true
end)

hyper:bind({}, "up", function()
    local win = hs.window.focusedWindow()
    if win == nil then
        return
    end
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
    hyper.triggered = true
end)

-------------------------------------------------------------------------------------

function xshake(window)

    local f = window:frame()

    f.x = f.x - 5
    window:setFrame(f)
    f.x = f.x - 5
    window:setFrame(f)

    f.x = f.x + 5
    window:setFrame(f)
    f.x = f.x + 5
    window:setFrame(f)

    f.x = f.x + 5
    window:setFrame(f)
    f.x = f.x + 5
    window:setFrame(f)

    f.x = f.x - 5
    window:setFrame(f)
    f.x = f.x - 5
    window:setFrame(f)

end

function yshake(window)

    local f = window:frame()

    f.y = f.y - 5
    window:setFrame(f)
    f.y = f.y - 5
    window:setFrame(f)

    f.y = f.y + 5
    window:setFrame(f)
    f.y = f.y + 5
    window:setFrame(f)

    f.y = f.y + 5
    window:setFrame(f)
    f.y = f.y + 5
    window:setFrame(f)

    f.y = f.y - 5
    window:setFrame(f)
    f.y = f.y - 5
    window:setFrame(f)

end


-- focus left
hyper:bind({}, "h", function()
    -- local screen = hs.screen.mainScreen()
    local wins = hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}-- :setScreens({screen:id()})
    local windows = wins:getWindows()
    local win = hs.window.frontmostWindow()
    if not win:focusWindowWest(windows, false, true) then
        xshake(win)
    end
    hyper.triggered = true
end)

-- focus right
hyper:bind({}, "l", function()
    -- local screen = hs.screen.mainScreen()
    local wins = hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}-- :setScreens({screen:id()})
    local windows = wins:getWindows()
    local win = hs.window.frontmostWindow()
    if not win:focusWindowEast(windows, false, true) then
        xshake(win)
    end
    hyper.triggered = true
end)

-- focus up
hyper:bind({}, "k", function()
    -- local screen = hs.screen.mainScreen()
    local wins = hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}-- :setScreens({screen:id()})
    local windows = wins:getWindows()
    local win = hs.window.frontmostWindow()
    if not win:focusWindowNorth(windows, false, true) then
        yshake(win)
    end
    hyper.triggered = true
end)

-- focus down
hyper:bind({}, "j", function()
    -- local screen = hs.screen.mainScreen()
    local wins = hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}-- :setScreens({screen:id()})
    local windows = wins:getWindows()
    local win = hs.window.frontmostWindow()
    if not win:focusWindowSouth(windows, false, true) then
        yshake(win)
    end
    hyper.triggered = true
end)

-------------------------------------------------------------------------------------

-- Reload configuration
-- Download and install http://www.hammerspoon.org/Spoons/SpoonInstall.html
hs.loadSpoon("SpoonInstall")

-- http://www.hammerspoon.org/Spoons/ReloadConfiguration.html
spoon.SpoonInstall:andUse("ReloadConfiguration",
               {
                    config = { watch_paths = { os.getenv("HOME") .. "/GitRepos/dotfiles/.hammerspoon" } },
                    start = true,
               }
)
hyper:bind({}, "r", function()
    hs.reload()
    hyper.triggered = true
end)

-------------------------------------------------------------------------------------

mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
    size = 150
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        mouseCircle2:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-(size/2), mousepoint.y-(size/2), size, size))
    mouseCircle2 = hs.drawing.circle(hs.geometry.rect(mousepoint.x-(size/4), mousepoint.y-(size/4), size/2, size/2))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle2:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle2:setFill(false)
    mouseCircle:setStrokeWidth(3)
    mouseCircle2:setStrokeWidth(5)
    mouseCircle:show()
    mouseCircle2:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(1.5, function() mouseCircle:delete() mouseCircle2:delete() end)
end

-------------------------------------------------------------------------------------

hs.window.switcher.ui.showThumbnails = false
hs.window.switcher.ui.showSelectedThumbnail = true
hs.window.switcher.ui.textSize = 10
hs.window.switcher.ui.showTitles = false

function switcher_next()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    filter = hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}:setScreens({screen:id()})
    switcher = hs.window.switcher.new(filter)
    switcher:next()
end
function switcher_previous()
    local win = hs.window.focusedWindow()
    local screen = win:screen()
    filter = hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}:setScreens({screen:id()})
    switcher = hs.window.switcher.new(filter)
    switcher:previous()
end
hs.hotkey.bind("alt", "`", switcher_next, nil, switcher_next) -- Move focus to next window in the same screen
hs.hotkey.bind("alt-shift", "`", switcher_previous, nil, switcher_previous) -- Move focus to previous window in the same screen

-------------------------------------------------------------------------------------

function tile_windows(screen)
    local wins = hs.window.filter.new():setCurrentSpace(true):setDefaultFilter{}:setScreens({screen:id()}):getWindows()
    local max = screen:frame()
    local rect = hs.geometry(max.x, max.y, max.w, max.h)
    hs.window.tiling.tileWindows(wins, rect)
end

-------------------------------------------------------------------------------------

hyper:bind({}, "t", function()
    local screen = hs.screen.mainScreen()
    tile_windows(screen)
    hyper.triggered = true
end)

-- allwindows = hs.window.filter.new(nil)
-- allwindows:subscribe(hs.window.filter.windowCreated, function () redrawBorder() end)
-- allwindows:subscribe(hs.window.filter.windowFocused, function () redrawBorder() end)
-- allwindows:subscribe(hs.window.filter.windowMoved, function () redrawBorder() end)
-- allwindows:subscribe(hs.window.filter.windowUnfocused, function () redrawBorder() end)

-------------------------------------------------------------------------------------

hs.alert.show("Config loaded!")

