
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
	    win:moveToScreen(monitor_1, false, true)
	 end
	 hsm.windows.moveTopRight(win)
      end
   },
   {
      name = "Adium",
      func = function(index, win)
	 if (#hs.screen.allScreens() > 1) then
	    -- second space on 1st monitor
	    spaces.moveWindowToSpace(win:id(), hs.screen.allScreens()[2]:spaces()[1])
	 end
	 hsm.windows.moveBottomLeft(win)
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
      name = "Zoiper",
      func = function(index, win)
	 hsm.windows.moveTopLeft(win,150,0)
      end
   },
}

return layouts
