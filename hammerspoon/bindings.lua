--
-- Key bindings
--
local bindings = {}

local uapp = require('utils.app')

-- define some modifier key combinations
local mod = {
  s      = {'shift'},
  a      = {'alt'},
  cc     = {'cmd', 'ctrl'},
  ca     = {'cmd', 'alt'},
  as     = {'alt', 'shift'},
  cas    = {'cmd', 'alt', 'shift'},
  hyper  = {'cmd', 'alt', 'ctrl'},  -- mapped to L_CTRL with Karabiner and Seil
  shyper = {'cmd', 'alt', 'ctrl', 'shift'},
}

---- This requires karabiner-elements, so not using it for now
----
-- Hyper key in Sierra
--local hyper = hs.hotkey.modal.new({}, 'F17')

---- Enter/Exit Hyper Mode when F18 is pressed/released
--local pressedF18 = function()  hyper:enter() end
--local releasedF18 = function() hyper:exit() end
--
---- Bind the Hyper key
---- Also requires Karabiner-Elements to bind left_control to F18
--hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
--hs.hotkey.bind(mod.s, 'F18', pressedF18, releasedF18)
----
---- End of karabiner-elements requirement

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
  -- shyper binds
  hs.fnutils.each({
      -- Music bindings
      {key = '0',  fn = hsm.songs.rateSong0},
      {key = '1',  fn = hsm.songs.rateSong1},
      {key = '2',  fn = hsm.songs.rateSong2},
      {key = '3',  fn = hsm.songs.rateSong3},
      {key = '4',  fn = hsm.songs.rateSong4},
      {key = '5',  fn = hsm.songs.rateSong5},
      {key = 'left',  fn = hsm.songs.prevTrack},
      {key = 'right', fn = hsm.songs.nextTrack},
      {key = 'p',  fn = hsm.songs.playPause},
      {key = 'i',  fn = hsm.songs.getInfo},
      }, function(obj)
      if obj.mod then
	hs.hotkey.bind(obj.mod, obj.key, obj.fn)
      else
	hs.hotkey.bind(mod.shyper, obj.key, obj.fn)
      end
--    hyper:bind(mod.s, obj.key, obj.fn)
  end)
  
  -- bind keys, if no modifier specified use hyper
  hs.fnutils.each({
      {key = 'h', fn = hs.hints.windowHints},
      {key = 'l', fn = hs.caffeinate.lockScreen},
      {key = 'm', fn = mouseHighlight},
      {key = 'c', fn = hsm.cheatsheet.toggle},
      {key = 'x', fn = hsm.cheatsheet.chooserToggle},
      {key = 'y', fn = hs.toggleConsole},
      {key = '1', fn = function()
	 local win = hs.window.focusedWindow()
	 if (win) then
	   win:moveToScreen(monitor_1, false, true)
	 end
      end},
      {key = '2', fn = function()
	 local win = hs.window.focusedWindow()
	 if (win) then
	   win:moveToScreen(monitor_2, false, true)
	 end
      end},
      {key = "3", fn = function()
	 hsm.layouts.apply()
      end},
      {key = '4', fn = function()
	 local focusedWindow = hs.window.focusedWindow()
	 local app = focusedWindow:application()
	 if (app) then
	   hsm.layouts.apply(app)
	 end
      end},
      {key = 'R', fn = function()
	 hs.reload()
	 hs.alert.show('Config loaded')
      end}
      }, function(obj)
      if obj.mod then
	hs.hotkey.bind(obj.mod, obj.key, obj.fn)
      else
	hs.hotkey.bind(mod.hyper, obj.key, obj.fn)
      end
--    hyper:bind({}, obj.key, obj.fn)
  end)
  
  hs.fnutils.each({
      {mod = mod.ca, key = 'home',     fn = hsm.windows.moveTopLeft},
      {mod = mod.ca, key = 'end',      fn = hsm.windows.moveBottomLeft},
      {mod = mod.ca, key = 'pageup',   fn = hsm.windows.moveTopRight},
      {mod = mod.ca, key = 'pagedown', fn = hsm.windows.moveBottomRight},
      {mod = mod.ca, key = 'right',    fn = hsm.windows.moveRight},
      {mod = mod.ca, key = 'left',     fn = hsm.windows.moveLeft},
      {mod = mod.ca, key = 'up',       fn = hsm.windows.moveUp},
      {mod = mod.ca, key = 'down',     fn = hsm.windows.moveDown}
		  }, function(obj)
      if obj.mod then
	hs.hotkey.bind(obj.mod, obj.key, obj.fn)
      else
	hs.hotkey.bind({}, obj.key, obj.fn)
      end
  end)

end

return bindings
