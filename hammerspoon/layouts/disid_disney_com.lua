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
      name = {"Emacs"},
      func = function(index, win)
	 win:moveToScreen(monitor_1)
      end
   },
   {
      name = {"Slack"},
      func = function(index, win)
	 if (#hs.screen.allScreens() > 1) then
	    -- first space on 2nd monitor
	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[2]:spaces()[1])
	    win:moveToScreen(monitor_2)
	 else
	    -- first empty space
	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[1]:spaces()[3])
	 end
	 hsm.windows.moveTopLeft(win)
      end
   },
   {
      name = {"Microsoft Outlook"},
      func = function(index, win)
	 if (#hs.screen.allScreens() > 1) then
	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[2]:spaces()[1])
	    win:moveToScreen(monitor_2)
	 else
	    -- first empty space
	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[1]:spaces()[3])
	 end
	 hsm.windows.moveBottomRight(win)
      end
   },
   {
      name = {"Remember The Milk"},
      func = function(index, win)
	 if (#hs.screen.allScreens() > 1) then
--	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[2]:spaces()[1])
	    win:moveToScreen(monitor_2)
	 else
	    -- first empty space
--	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[1]:spaces()[3])
	 end
	 hsm.windows.moveTopRight(win)
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
   {
      name = {"GIMP"},
      func = function(index, win)
	 -- third space on 1st monitor
	 spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[1]:spaces()[3])
      end
   },
}

return layouts
