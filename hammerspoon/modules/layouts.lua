-- module: Window layout functions
local m = {}

local watcher = nil

local function getWindows(appName, appTitle)
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

local function applyAppLayout(layout, appName, counter)
  local wins = getWindows(appName, layout.title)
  if wins then
    for j, win in ipairs(wins) do
      if layout.func then
	layout.func(counter, win)
      end
    end
  end
end

function m.apply(app)
  local counter = 0
  for i, layout in ipairs(layouts) do
    appTable = layout.name
    if (type(layout.name) == "string") then
      appTable = {layout.name}
    end
    for i, appName in ipairs(appTable) do
      if app then
	if appName == app:title() then
	  applyAppLayout(layout, appName, counter)
	  counter = counter + 1
	end
      elseif (hs.application.find(appName)) then
	applyAppLayout(layout, appName)
	counter = counter + 1
      end
    end
  end
  if app and counter == 0 then
    -- Message if no layout defined for this application
    hs.alert.show('No layout defined for ' .. app:title())
  end
end

-- Find host domain name to determine what layout to load
-- layouts are in ~/.hammerspoon/layouts/domain.lua
-- (domain has dots replaced with _)
local function loadLayouts()
  local domainname = nil
  for i,hname in ipairs(hs.host.names()) do
    hname_clean = string.gsub(hname,'%.','_')
    if file_exists(os.getenv('HOME') .. '/.hammerspoon/layouts/' .. hname_clean .. '.lua') then
      domainname = hname_clean
      break
    end
    domainname = string.match(hname,'%.([^.]+%..*)$')
    if domainname then
      domainname = string.gsub(domainname,'%.','_')
    end
    if domainname and file_exists(os.getenv('HOME') .. '/.hammerspoon/layouts/' .. domainname .. '.lua') then
      break
    else
      domainname = nil
    end
  end

  if domainname then
    --  hs.alert.show('Loaded layouts for ' .. domainname)
    layouts = require('layouts/' .. domainname)
  else
    layouts = {}
  end
  return layouts
end

-- Reapply layouts on monitor changes (i.e. plugging an external monitor into a laptop)
local function monitorWatcher()
   print("monitor change")
   m.apply()
end

function m.start()
  m.layouts = loadLayouts()
  watcher = hs.screen.watcher.new(monitorWatcher)
  watcher:start()
end

function m.stop()
  watcher:stop()
  watcher = nil
end

return m
