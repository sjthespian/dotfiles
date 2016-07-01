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
  -- bind keys, if no modifier specified use shyper
  hs.fnutils.each({
      {mod = mod.hyper, key = 'h',  fn = hs.hints.windowHints},
      {mod = mod.hyper, key = 'l',  fn = hs.caffeinate.lockScreen},
      {mod = mod.hyper, key = 'm',  fn = mouseHighlight},
      {mod = mod.hyper, key = 'c',  fn = hsm.cheatsheet.toggle},
      {mod = mod.hyper, key = 'x',  fn = hsm.cheatsheet.chooserToggle},
      {mod = mod.hyper, key = 'y',  fn = hs.toggleConsole},

      {mod = mod.ca,    key = 'right', fn = hsm.windows.moveRight},
      {mod = mod.ca,    key = 'left',  fn = hsm.windows.moveLeft},
      {mod = mod.ca,    key = 'up',    fn = hsm.windows.moveUp},
      {mod = mod.ca,    key = 'down',  fn = hsm.windows.moveDown}
		  }, function(obj)
      if obj.mod then
	hs.hotkey.bind(obj.mod, obj.key, obj.fn)
      else
	hs.hotkey.bind(mod.shyper, obj.key, obj.fn)
      end
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

  hs.hotkey.bind(mod.hyper, 'R', function()
		    hs.reload()
		    hs.alert.show('Config loaded')
  end)

end

return bindings
