-- module: Application window actions
local m = {}

-- App/window actions are defined in appactions.lua
local A = require('appactions')

-- table for converting events to strings when debugging
local DEBUG = {
  [0] = 'launching',
  [1] = 'launched',
  [2] = 'terminated',
  [3] = 'hidden',
  [4] = 'unhidden',
  [5] = 'activated',
  [6] = 'deactivated',
}

local watcher = nil

-- Get audio libraries
local audio = require 'hs.audiodevice'

-- appwatcher callback
local function watch(appName, eventType, appObject)
  -- print('watch(', appName, ', ', eventType, ', ', appObject, ')')
  -- see config.appwindows for rule configuration
  if m.cfg.rules[appName] then

    local function hasNoMainWindow() return appObject:mainWindow() == nil end

    for _,rule in ipairs(m.cfg.rules[appName]) do
      -- if the current event matches one of our rules for this app,
      -- take the action defined by the rule.
      if rule.evt == eventType then
        if rule.act == A.fullscreen then
          -- set the main window to fullscreen
          hs.timer.waitWhile(hasNoMainWindow, function()
            appObject:mainWindow():setFullScreen(true)
          end)
        elseif rule.act == A.maximize then
          -- maximize the main window
          hs.timer.waitWhile(hasNoMainWindow, function()
            appObject:mainWindow():maximize()
          end)
        elseif rule.act == A.toFront then
          -- bring the application windows to the front
          appObject:selectMenuItem({'Window', 'Bring All to Front'})
        elseif rule.act == A.fullVolume then
          -- set volulme to 80%, saving the old level
	  local audioDev = audio.defaultOutputDevice()
	  m.saveVolume = audioDev:volume()
	  audioDev:setVolume(80)
        elseif rule.act == A.restoreVolume then
          -- restore volume to the prior level
	  local audioDev = audio.defaultOutputDevice()
	  if m.saveVolume then
	    audioDev:setVolume(m.saveVolume)
	  end
        elseif rule.act == A.iTermZoomIn then
	  hs.eventtap.keyStroke({"cmd", "shift"}, "=")
        elseif rule.act == A.iTermZoomOut then
	  hs.eventtap.keyStroke({"cmd"}, "-")
        elseif rule.act == A.debug then
          -- print some debugging information about the app and events
          print(
            'appName:', appName,
            ', bundleID:', appObject:bundleID(),
            ', eventType:', DEBUG[eventType])
          m.log.d(
            'appName:', appName,
            ', bundleID:', appObject:bundleID(),
            ', eventType:', DEBUG[eventType]
          )
        end
      end
    end
  end
end


function m.start()
  watcher = hs.application.watcher.new(watch)
  watcher:start()
end

function m.stop()
  watcher:stop()
  watcher = nil
end

return m
