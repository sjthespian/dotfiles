--
-- Create a status icon in the menu bar to show mute status
-- 
-- This lets you click on the menu bar item to toggle the mute state
zoomStatusMenuBarItem = hs.menubar.new(nil)
zoomStatusMenuBarItem:setClickCallback(function()
    spoon.Zoom:toggleMute()
end)

updateZoomStatus = function(event)
  hs.printf("updateZoomStatus(%s)", event)
  if (event == "from-running-to-meeting") then
    zoomStatusMenuBarItem:returnToMenuBar()
  elseif (event == "muted") then
    zoomStatusMenuBarItem:setTitle("🔴")
  elseif (event == "unmuted") then
    zoomStatusMenuBarItem:setTitle("🟢")
  elseif (event == "from-meeting-to-running") then
    zoomStatusMenuBarItem:removeFromMenuBar()
  end
end

--
-- Zoom sppon (non-official)
--
spoon.SpoonInstall:andUse("Zoom")
-- hs.loadSpoon("Zoom")
spoon.Zoom:setStatusCallback(updateZoomStatus)
-- spoon.Zoom.start()

-- Function to toggle mic, binding in bindings.lua
function zoomToggleMute()
  spoon.Zoom:toggleMute()
end
