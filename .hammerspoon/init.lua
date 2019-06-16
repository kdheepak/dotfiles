ctrlaltcmdshift = {"ctrl", "alt", "cmd", "shift"}
ctrlaltcmd = {"ctrl", "alt", "cmd"}
cmdctrlshift = {"cmd", "ctrl", "shift"}

-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, 'F17')
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
    hs.eventtap.keyStroke({}, 'ESCAPE')
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
f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)

-------------------------------------------------------------------------------------

hs.grid.setGrid('12x12')
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.window.animationDuration = 0 -- disable animations

hyper:bind({}, "3", function () -- hyper #
    local windows = hs.window.allWindows()
    for i in pairs(windows) do
        local window = windows[i]
        hs.grid.snap(window)
    end
end)

hyper:bind({}, "s", function () hs.grid.maximizeWindow(hs.window.focusedWindow()) end)

hyper:bind({}, "a", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h

    win:setFrame(f)
end)

hyper:bind({}, "d", function ()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h

    win:setFrame(f)
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

    win:setFrame(f)
end)

-- make mouse always in the center of focused window
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
    local f = window:frame()
    point = {x=(f.x + (f.w / 2)), y=(f.y + (f.h / 2))}
    hs.mouse.setAbsolutePosition(point)
    -- hs.eventtap.leftClick(point)
end)

hyper:bind({"shift"}, "[", function () hs.eventtap.keyStroke({"ctrl"}, "down") end)
hyper:bind({"shift"}, "]", function () hs.eventtap.keyStroke({"ctrl"}, "up") end)
hyper:bind({}, "[", function () hs.eventtap.keyStroke({"ctrl"}, "left") end)
hyper:bind({}, "]", function () hs.eventtap.keyStroke({"ctrl"}, "right") end)

hyper:bind({"shift"}, "j", function () hs.grid.pushWindowDown(hs.window.focusedWindow()) end)
hyper:bind({"shift"}, "k", function () hs.grid.pushWindowUp(hs.window.focusedWindow()) end)
hyper:bind({"shift"}, "h", function () hs.grid.pushWindowLeft(hs.window.focusedWindow()) end)
hyper:bind({"shift"}, "l", function () hs.grid.pushWindowRight(hs.window.focusedWindow()) end)

hyper:bind({"ctrl", "shift"}, "h", function() hs.grid.resizeWindowThinner(hs.window.focusedWindow()) end)
hyper:bind({"ctrl", "shift"}, "l", function() hs.grid.resizeWindowWider(hs.window.focusedWindow()) end)
hyper:bind({"ctrl", "shift"}, "j", function() hs.grid.resizeWindowTaller(hs.window.focusedWindow()) end)
hyper:bind({"ctrl", "shift"}, "k", function() hs.grid.resizeWindowShorter(hs.window.focusedWindow()) end)

hyper:bind({}, "left", function()
  -- move the focused window one display to the left
  local win = hs.window.focusedWindow()
  win:moveOneScreenWest()
end)

hyper:bind({}, "right", function()
  -- move the focused window one display to the right
  local win = hs.window.focusedWindow()
  win:moveOneScreenEast()
end)

hyper:bind({}, "left", function()
  -- move the focused window one display to the left
  local win = hs.window.focusedWindow()
  win:moveOneScreenWest()
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
hyper:bind({}, 'r', function()
    hs.reload()
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

hs.hotkey.bind('alt', '`', hs.window.switcher.nextWindow, nil, hs.window.switcher.nextWindow) -- Move focus to next window
hs.hotkey.bind('alt-shift', '`', hs.window.switcher.previousWindow, nil, hs.window.switcher.previousWindow) -- Move focus to previous window

-------------------------------------------------------------------------------------

hs.alert.show("Config loaded!")
