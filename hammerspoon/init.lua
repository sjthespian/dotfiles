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
  'browser', 
  'caffeine',
  'cheatsheet',
  'songs',
  'wifi',
  'windows'
}

-- global modules namespace (short for easy console use)
hsm = {}

--
-- Load my functions
--
--require('window_functions')
require('misc_functions')

-- load module configuration
cfg = require('config')
hsm.cfg = cfg.global

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

-- Watch for monitor changes
monWatcher = hs.screen.watcher.new(monitorWatcher)
monWatcher:start()


-- Find host domain name to determine what layout to load
-- layouts are in ~/.hammerspoon/layouts/domain.lua
-- (domain has dots replaced with _)
domainname = nil
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
require('layout_functions')
if domainname then
--  hs.alert.show('Loaded layouts for ' .. domainname)
  layouts = require('layouts/' .. domainname)
else
  layouts = {}
end

