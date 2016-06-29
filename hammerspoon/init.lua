--------------------------------------------------------------------------------
-- Unsupported Spaces extension. Uses private APIs but works okay.
-- (http://github.com/asmagill/hammerspoon_asm.undocumented)
spaces = require("hs._asm.undocumented.spaces")


-- config and methods originally taken from:
-- https://github.com/rtoshiro/hammerspoon-init
-- https://gist.github.com/TwoLeaves/a9d226ac98be5109a226
-- https://github.com/jwkvam/hammerspoon-config/blob/master/init.lua

--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------
monitor_1 = hs.screen.allScreens()[1]
monitor_2 = hs.screen.allScreens()[2]

local LOGLEVEL = 'debug'
-- configure logging
log = hs.logger.new(hs.host.localizedName(), LOGLEVEL)

-- List of modules to load (found in modules/ dir)
local modules = {
  'battery',
  'caffeine',
  'weather',
  'wifi'
}

-- global modules namespace (short for easy console use)
hsm = {}

-- load module configuration
cfg = require('config')
hsm.cfg = cfg.global

--
-- Load my functions
--
require('window_functions')
require('misc_functions')

-- load, configure, and start each module
hs.fnutils.each(modules, loadModuleByName)
hs.fnutils.each(hsm, configModule)
hs.fnutils.each(hsm, startModule)

-- load and bind keys
local bindings = require('bindings')
bindings.bind()


--
-- Watchers for various things
--

-- Battery Low warnings
--local batWatcher = nil
--batWatcher = hs.battery.watcher.new(batPercentageChangedCallback)
--batWatcher:start()

-- Reload config on change
configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configWatcher:start()
hs.alert.show("Config change, reloaded")

-- Watch for monitor changes
monWatcher = hs.screen.watcher.new(monitorWatcher)
monWatcher:start()


--
-- Keep display on or allow going to sleep
--
caffeine = require('modules/caffeine')

-- Find host domain name to determine what layout to load
-- layouts are in ~/.hammerspoon/layouts/domain.lua
-- (domain has dots replaced with _)
domainname = ''
for i,hname in ipairs(hs.host.names()) do
   domainname = string.match(hname,'%.([^.]+%..*)$')
   if domainname then
      domainname = string.gsub(domainname,'%.','_')
--       hs.alert.show(domainname)
   end
   if domainname and file_exists(os.getenv('HOME') .. '/.hammerspoon/layouts/' .. domainname .. '.lua') then
      break
   else
      domainname = ''
   end
end
require('layout_functions')
if domainname then
   require('layouts/' .. domainname)
end

