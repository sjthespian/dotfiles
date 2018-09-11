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
  'appwindows',
  'battery',
  'browser', 
  'caffeine',
  'cheatsheet',
  'layouts',
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
