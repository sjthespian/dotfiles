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
      -- Music bindings
      {mod = mod.shyper, key = '0',  fn = hsm.songs.rateSong0},
      {mod = mod.shyper, key = '1',  fn = hsm.songs.rateSong1},
      {mod = mod.shyper, key = '2',  fn = hsm.songs.rateSong2},
      {mod = mod.shyper, key = '3',  fn = hsm.songs.rateSong3},
      {mod = mod.shyper, key = '4',  fn = hsm.songs.rateSong4},
      {mod = mod.shyper, key = '5',  fn = hsm.songs.rateSong5},
      {mod = mod.shyper, key = 'left',  fn = hsm.songs.prevTrack},
      {mod = mod.shyper, key = 'right', fn = hsm.songs.nextTrack},
      {mod = mod.shyper, key = 'p',  fn = hsm.songs.playPause},
      {mod = mod.shyper, key = 'i',  fn = hsm.songs.getInfo},
      
      {mod = mod.hyper, key = 'h', fn = hs.hints.windowHints},
      {mod = mod.hyper, key = 'l', fn = hs.caffeinate.lockScreen},
      {mod = mod.hyper, key = 'm', fn = mouseHighlight},
      {mod = mod.hyper, key = 'c', fn = hsm.cheatsheet.toggle},
      {mod = mod.hyper, key = 'x', fn = hsm.cheatsheet.chooserToggle},
      {mod = mod.hyper, key = 'y', fn = hs.toggleConsole},
      {mod = mod.hyper, key = '1', fn = function()
	 local win = hs.window.focusedWindow()
	 if (win) then
	   win:moveToScreen(monitor_1)
	 end
      end},
      {mod = mod.hyper, key = '2', fn = function()
	 local win = hs.window.focusedWindow()
	 if (win) then
	   win:moveToScreen(monitor_2)
	 end
      end},
      {mod = mod.hyper, key = "3", fn = function()
	 hsm.layouts.apply()
      end},
      {mod = mod.hyper, key = '4', fn = function()
	 local focusedWindow = hs.window.focusedWindow()
	 local app = focusedWindow:application()
	 if (app) then
	   hsm.layouts.apply(app)
	 end
      end},
      {mod = mod.hyper, key = 'R', fn = function()
	 hs.reload()
	 hs.alert.show('Config loaded')
      end},

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


end

return bindings
