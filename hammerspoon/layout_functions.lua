--
-- Functions for managing screen layouts
--

function getWindows(appName, appTitle)
   if appTitle then
     winFilter = hs.window.filter.new{appName, override={visible = true, allowTitles={appTitle}}}
   else
     winFilter = hs.window.filter.new{appName, override={visible = true}}
   end
   if winFilter then
     return winFilter:getWindows()
   else
     return nil
   end
end
	  
function applyLayout(layouts, app)
  if (app) then
    appName = app:title()
    for i, layout in ipairs(layouts) do
      appTable = layout.name
      if (type(layout.name) == "string") then
	appTable = {layout.name}
      end
      for i, layAppName in ipairs(appTable) do
	if (layAppName == appName) then
	  local wins = getWindows(appName, layout.title)
	  local counter = 1
	  for j, win in ipairs(wins) do
	    if layout.func then
	      layout.func(counter, win)
	      counter = counter + 1
	    end
	  end
	end
      end
    end
  end
end

function applyLayouts(layouts)
  for i, layout in ipairs(layouts) do
    appTable = layout.name
    if (type(layout.name) == "string") then
      appTable = {layout.name}
    end
    for i, appName in ipairs(appTable) do
      if (hs.application.find(appName)) then
	local wins = getWindows(appName, layout.title)
	local counter = 1
	if wins then
	  for j, win in ipairs(wins) do
	    if layout.func then
	      layout.func(counter, win)
	      counter = counter + 1
	    end
	  end
	end
      end
    end
  end
end

--function applicationWatcher(appName, eventType, appObject)
--  if (eventType == hs.application.watcher.activated) then
--    if (appName == "iTerm") then
--        appObject:selectMenuItem({"Window", "Bring All to Front"})
--    elseif (appName == "Finder") then
--        appObject:selectMenuItem({"Window", "Bring All to Front"})
--    end
--  end

--  if (eventType == hs.application.watcher.launched) then
--    os.execute("sleep " .. tonumber(3))
--    applyLayout(layouts, appObject)
--  end
--end

--config()
--local appWatcher = hs.application.watcher.new(applicationWatcher)
--appWatcher:start()

