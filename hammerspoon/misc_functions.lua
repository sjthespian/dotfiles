--
-- Misc. functions
--

-- Auto-reload configuration on change
function reloadConfig(files)
   hs.fnutils.each(hsm, stopModule)
   
   doReload = false
   for _,file in pairs(files) do
      if file:sub(-4) == ".lua" then
	 doReload = true
      end
   end
   if doReload then
      hs.reload()
   end

end



-- I always end up losing my mouse pointer, particularly if it's on a monitor full of terminals.
-- This draws a bright red circle around the pointer for a few seconds
function mouseHighlight()
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    mousepoint = hs.mouse.getAbsolutePosition()
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-30, mousepoint.y-30, 60, 60))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end


-- File existence test
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

--
-- If reduced to a single monitor, move monitor2 applications to
-- additional spaces instead of onto the main monitor
-- Restore apps to proper monitor when it comes back
function monitorWatcher()
   print("monitor change")
   applyLayouts(layouts)
end


-- Module functions from
-- https://github.com/scottcs/dot_hammerspoon/
-- load a module from modules/ dir, and set up a logger for it
function loadModuleByName(modName)
  hsm[modName] = require('modules.' .. modName)
  hsm[modName].name = modName
  hsm[modName].log = hs.logger.new(modName, LOGLEVEL)
  log.i(hsm[modName].name .. ': module loaded')
end

-- save the configuration of a module in the module object
function configModule(mod)
  mod.cfg = mod.cfg or {}
  if (cfg[mod.name]) then
    for k,v in pairs(cfg[mod.name]) do mod.cfg[k] = v end
    log.i(mod.name .. ': module configured')
  end
end

-- start a module
function startModule(mod)
  if mod.start == nil then return end
  mod.start()
  log.i(mod.name .. ': module started')
end

-- stop a module
function stopModule(mod)
  if mod.stop == nil then return end
  mod.stop()
  log.i(mod.name .. ': module stopped')
end
