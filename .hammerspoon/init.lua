-- Dheepak Krishnamurthy
--
-- Hammerspoon init file
-- Place in ($HOME)/.hammerspoon/init.lua
-- 

--- Defining variables

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "ctrl", "shift"}


hs.hotkey.bind(mashshift, "H", function()
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


hs.hotkey.bind(mashshift, "L", function()
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


hs.hotkey.bind(mashshift, "K", function()
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


hs.hotkey.bind(mashshift, "J", function()
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


hs.hotkey.bind(mash, "E", function()
  hs.application.focus("Emacsclient")
end)

-- change focus
hs.hotkey.bind(mash, 'H', function() hs.window.focusedWindow():focusWindowWest() end)
hs.hotkey.bind(mash, 'L', function() hs.window.focusedWindow():focusWindowEast() end)
hs.hotkey.bind(mash, 'K', function() hs.window.focusedWindow():focusWindowNorth() end)
hs.hotkey.bind(mash, 'J', function() hs.window.focusedWindow():focusWindowSouth() end)

-- maximize window
hs.hotkey.bind(mash, 'M', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  f.x = max.x 
  f.y = max.y 
  f.w = max.w 
  f.h = max.h 
  win:setFrame(f)
end)

hs.hotkey.bind(mash, 't', function () hs.application.launchOrFocus("terminal") end)

-- Config reload key binding has to be the last config in init.lua
-- See http://www.hammerspoon.org/go/#simplereload


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

