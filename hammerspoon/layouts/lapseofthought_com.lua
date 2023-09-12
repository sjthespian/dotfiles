
--------------------------------------------------------------------------------
-- LAYOUTS
-- SINTAX:
--  {
--    name = "App name" ou { "App name", "App name" }
--    title = "Window title" (optional)
--    func = function(index, win)
--      COMMANDS
--    end
--  },
--
-- It searches for application "name" and call "func" for each window object
--------------------------------------------------------------------------------
local layouts = {
   {
      -- Always put Zoom on the primary monitor since it has the camera
      name = "zoom.us",
      func = function(index, win)
	 win:moveToScreen(monitor_1, false, true)
      end
   },
   {
      name = "Reminders",
      func = function(index, win)
	 if (#hs.screen.allScreens() > 1) then
	    win:moveToScreen(monitor_2, false, true)
	    hsm.windows.moveTopRight(win)
         else
	    hsm.windows.moveTopRight(win)
         end
      end
   },
   {
      name = "Emacs",
      func = function(index, win)
	 win:moveToScreen(monitor_2, false, true)
      end
   },
   {
      name = "Slack",
      func = function(index, win)
	 -- first space on 2nd monitor
	 -- spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[1]:spaces()[1])
	 if (#hs.screen.allScreens() > 1) then
	    win:moveToScreen(monitor_2, false, true)
	    hsm.windows.moveTopLeft(win)
	 else
	    hsm.windows.moveTopRight(win)
	 end
      end
   },
   {
      name = "Screen Sharing",
      func = function(index, win)
	 if (#hs.screen.allScreens() > 1) then
	 -- second space on 2nd monitor
            print("Moving Screen Sharing to 2nd monitor 2nd space")
	    spaces.moveWindowToSpace(win:id(), spaces.spacesForScreen(hs.screen.allScreens()[2])[2])
	 --   win:moveToScreen(monitor_2, false, true)
	 else
	 -- second space on only (1) monitor
            print("Moving Screen Sharing to 1st monitor 2nd space")
	    spaces.moveWindowToSpace(win:id(), spaces.spacesForScreen(hs.screen.allScreens()[1])[2])
	 end
      end
   },
   {
      name = "Royal TSX",
      func = function(index, win)
	 -- second space on 1st monitor
	 spaces.moveWindowToSpace(win:id(), spaces.spacesForScreen(hs.screen.allScreens()[1])[2])
      end
   },
   {
      name = "Spark",
      func = function(index, win)
	 -- first space on 2nd monitor
	 -- spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[1]:spaces()[1])
	 if (#hs.screen.allScreens() > 1) then
	    win:moveToScreen(monitor_2, false, true)
	 --    hsm.windows.moveTopLeft(win)
	 -- else
	 --    hsm.windows.moveTopRight(win)
	 end
      end
   },
   {
      name = "Adium",
      title = "Contacts",
      func = function(index, win)
	 if (#hs.screen.allScreens() > 1) then
	    -- second space on 1st monitor
	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[1]:spaces()[2])
	 end
	 hsm.windows.moveTopLeft(win)
      end
   },
}

return layouts
