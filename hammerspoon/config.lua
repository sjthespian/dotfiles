-- copy this file to config.lua and edit as needed
--
local cfg = {}
cfg.global = {}  -- this will be accessible via hsm.cfg in modules
----------------------------------------------------------------------------

local ufile = require('utils.file')
--local E = require('hs.application.watcher')   -- appwindows events
--local A = require('appactions')               -- appwindows actions

-- Monospace font used in multiple modules
local MONOFONT = 'Fira Mono'

--------------------
--  global paths  --
--------------------
cfg.global.paths = {}
cfg.global.paths.base  = os.getenv('HOME')
cfg.global.paths.tmp   = os.getenv('TMPDIR')
cfg.global.paths.bin   = ufile.toPath(cfg.global.paths.base, 'bin')
cfg.global.paths.cloud = ufile.toPath(cfg.global.paths.base, 'Box')
cfg.global.paths.hs    = ufile.toPath(cfg.global.paths.base, '.hammerspoon')
cfg.global.paths.data  = ufile.toPath(cfg.global.paths.hs,   'data')
cfg.global.paths.media = ufile.toPath(cfg.global.paths.hs,   'media')
cfg.global.paths.ul    = '/usr/local'
cfg.global.paths.ulbin = ufile.toPath(cfg.global.paths.ul,   'bin')

---------------
--  battery  --
---------------
cfg.battery = {
  icon = ufile.toPath(cfg.global.paths.media, 'battery.png'),
}

----------------
--  caffeine  --
----------------
cfg.caffeine = {
  menupriority = 1390,            -- menubar priority (lower is lefter)
  notifyMinsActive = 30,          -- notify when active for this many minutes
  icons = {
    on  = ufile.toPath(cfg.global.paths.media, 'caffeine-on.pdf'),
    off = ufile.toPath(cfg.global.paths.media, 'caffeine-off.pdf'),
  },
}

---------------
--  browser  --
---------------
cfg.browser = {
  apps = {
    ['com.apple.Safari'] = true,
    ['com.google.Chrome'] = true,
    ['org.mozilla.firefox'] = true,
  },
}

cfg.browser.defaultApp = 'com.apple.Safari'

------------------
--  cheatsheet  --
------------------
cfg.cheatsheet = {
  defaultName = 'default',
  chooserWidth = 50,
  path = {
    dir    = ufile.toPath(cfg.global.paths.hs, 'cheatsheets'),
    css    = ufile.toPath(cfg.global.paths.media, 'cheatsheet.min.css'),
    pandoc = ufile.toPath(cfg.global.paths.ulbin, 'pandoc'),
  },
}

-------------
--  songs  --
-------------
cfg.songs = {
  -- set this to the path of the track binary if you're using it
  -- trackBinary = ufile.toPath(cfg.global.paths.bin, 'track'),
  trackBinary = nil
}

---------------
--  weather  --
---------------
cfg.weather = {
  menupriority = 1400,            -- menubar priority (lower is lefter)
  fetchTimeout = 120,             -- timeout for downloading weather data
  locationTimeout = 300,          -- timeout for lat/long lookup
  minPrecipProbability = 0.249,   -- minimum to show precipitation details

  api = {  -- forecast.io API config
    key = '4f8cd9a1eee2e6bf1a781275094f0317',
    maxCalls = 450,  -- forecast.io only allows 1000 per day
  },

  file     = ufile.toPath(cfg.global.paths.data,  'weather.json'),
  iconPath = ufile.toPath(cfg.global.paths.media, 'weather'),

  tempThresholds = {  -- Used for float comparisons, so +0.5 is easier
    warm        = 79.5,
    hot         = 87.5,
    tooHot      = 94.5,
    tooDamnHot  = 99.5,
    alert       = 104.5,
  },

  -- hs.styledtext styles
  styles = {
    default = {
      font  = MONOFONT,
      size  = 13,
    },
    warm = {
      font  = MONOFONT,
      size  = 13,
      color = {red=1,     green=0.96,  blue=0.737, alpha=1},
    },
    hot = {
      font  = MONOFONT,
      size  = 13,
      color = {red=1,     green=0.809, blue=0.493, alpha=1},
    },
    tooHot = {
      font  = MONOFONT,
      size  = 13,
      color = {red=0.984, green=0.612, blue=0.311, alpha=1},
    },
    tooDamnHot = {
      font  = MONOFONT,
      size  = 13,
      color = {red=0.976, green=0.249, blue=0.243, alpha=1},
    },
    alert = {
      font  = MONOFONT,
      size  = 13,
      color = {red=0.94,  green=0.087, blue=0.319, alpha=1},
    },
  }
}

------------
--  wifi  --
------------
cfg.wifi = {
  icon = ufile.toPath(cfg.global.paths.media, 'airport.png'),
}

---------------
--  windows  --
---------------
cfg.windows = {
  movePct = 5,
}


hs.window.animationDuration = 0.3

-- eliminate errors from apps that don't play well with hammerspoon filtering
hs.window.filter.ignoreAlways['nplastpass'] = true
hs.window.filter.ignoreAlways['ARDAgent'] = true
hs.window.filter.ignoreAlways['BlueJeans Media'] = true
hs.window.filter.ignoreAlways['Little Snitch Agent'] = true
hs.window.filter.ignoreAlways['Little Snitch Network Monitor'] = true
hs.window.filter.ignoreAlways['Parallels Desktop'] = true
hs.window.filter.ignoreAlways['Remember The Milk Networking'] = true
hs.window.filter.ignoreAlways['Remember The Milk Database Storage'] = true


return cfg
