--
-- Key bindings
--

local bindings = {}

-- define some modifier key combinations
local mod = {
  cc     = {'cmd', 'ctrl'},
  ca     = {'cmd', 'alt'},
  as     = {'alt', 'shift'},
  cas    = {'cmd', 'alt', 'shift'},
  hyper  = {'cmd', 'alt', 'ctrl'},  -- mapped to L_CTRL with Karabiner and Seil
  shyper = {'cmd', 'alt', 'ctrl', 'shift'},
}

-- cmd alt bindings
--  arrow keys - move window

-- cmd alt ctrl bindings
--  1 - move current window to monitor 1
--  2 - move current window to monitor 2
--  3 - apply window layouts
--  4 - apply window layout to current app
--  h - show window hints
--  l - lock screen
--  m - highlight mouse location
--  R - reload hammerspoon config

function bindings.bind()
   hs.hotkey.bind(mod.ca, 'right', function()
		     local win = hs.window.focusedWindow()
		     win:moveRight()	     
   end)

   hs.hotkey.bind(mod.ca, 'left', function()
		     local win = hs.window.focusedWindow()
		     win:moveLeft()	     
   end)

   hs.hotkey.bind(mod.ca, 'up', function()
		     local win = hs.window.focusedWindow()
		     win:moveUp()	     
   end)

   hs.hotkey.bind(mod.ca, 'down', function()
		     local win = hs.window.focusedWindow()
		     win:moveDown()	     
   end)

  hs.hotkey.bind(mod.hyper, '1', function()
		    local win = hs.window.focusedWindow()
		    if (win) then
		       win:moveToScreen(monitor_1)
		    end
  end)

  hs.hotkey.bind(mod.hyper, '2', function()
		    local win = hs.window.focusedWindow()
		    if (win) then
		       win:moveToScreen(monitor_2)
		    end
  end)

  hs.hotkey.bind(mod.hyper, "3", function()
		    applyLayouts(layouts)
  end)

  hs.hotkey.bind(mod.hyper, '4', function()
		    local focusedWindow = hs.window.focusedWindow()
		    local app = focusedWindow:application()
		    if (app) then
		       applyLayout(layouts, app)
		    end
  end)

  hs.hotkey.bind(mod.hyper, 'h', hs.hints.windowHints)
  hs.hotkey.bind(mod.hyper, 'l', hs.caffeinate.lockScreen)
  hs.hotkey.bind(mod.hyper, 'm', mouseHighlight)

  hs.hotkey.bind(mod.hyper, 'R', function()
		    hs.reload()
		    hs.alert.show('Config loaded')
  end)

end

return bindings
