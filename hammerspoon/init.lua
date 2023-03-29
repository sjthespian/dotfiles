--------------------------------------------------------------------------------
-- Unsupported Spaces extension. Uses private APIs but works okay.
-- (http://github.com/asmagill/hammerspoon_asm.undocumented)
-- spaces = require("hs._asm.undocumented.spaces")
spaces = require("hs.spaces")

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
-- Load spoons
--
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

-- 
-- Hotkey to mute microphone from any app
--
-- spoon.SpoonInstall:andUse("MicMute")
-- spoon.MicMute:bindHotkeys(
--     {
--         toggle = {{"cmd", "alt", "ctrl"}, "/"}
--     }
-- )

-- 
-- Push to talk for Zoome
-- 
-- spoon.SpoonInstall.repos.skrypka = {
--   url = "https://github.com/skrypka/Spoons",
--   desc = "Skrypka's spoon repository",
-- }
-- spoon.SpoonInstall:andUse("PushToTalk", {
--   repo = 'skrypka',
--   start = true,
--   config = {
--     app_switcher = { ['zoom.us'] = 'push-to-talk' }
--   }
-- })

--
-- Load my functions
--
--require('window_functions')
require('misc_functions')
require('zoom_local')

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
