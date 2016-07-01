-- module: windows - functions for window movement and management
--

local m = {}

-- Returns the width of the smaller screen size
-- isFullscreen = false removes the toolbar
-- and dock sizes
local function minWidth(isFullscreen)
  local min_width = math.maxinteger
  for i, screen in ipairs(hs.screen.allScreens()) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_width = math.min(min_width, screen_frame.w)
  end
  return min_width
end

-- isFullscreen = false removes the toolbar
-- and dock sizes
-- Returns the height of the smaller screen size
local function minHeight(isFullscreen)
  local min_height = math.maxinteger
  for i, screen in ipairs(hs.screen.allScreens()) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_height = math.min(min_height, screen_frame.h)
  end
  return min_height
end

-- If you are using more than one monitor, returns X
-- considering the reference screen minus smaller screen
-- = (MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2
-- If using only one monitor, returns the X of ref screen
local function minX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + ((refScreen:frame().w - minWidth()) / 2)
  end
  return min_x
end

-- If you are using more than one monitor, returns Y
-- considering the focused screen minus smaller screen
-- = (MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2
-- If using only one monitor, returns the Y of focused screen
local function minY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + ((refScreen:frame().h - minHeight()) / 2)
  end
  return min_y
end

-- If you are using more than one monitor, returns the
-- half of minX and 0
-- = ((MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2) / 2
-- If using only one monitor, returns the X of ref screen
local function almostMinX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + (((refScreen:frame().w - minWidth()) / 2) - ((refScreen:frame().w - minWidth()) / 4))
  end
  return min_x
end

-- If you are using more than one monitor, returns the
-- half of minY and 0
-- = ((MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2) / 2
-- If using only one monitor, returns the Y of ref screen
local function almostMinY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + (((refScreen:frame().h - minHeight()) / 2) - ((refScreen:frame().h - minHeight()) / 4))
  end
  return min_y
end

-- Returns the frame of the smaller available screen
-- considering the context of refScreen
-- isFullscreen = false removes the toolbar
-- and dock sizes
local function minFrame(refScreen, isFullscreen)
  return {
    x = minX(refScreen),
    y = minY(refScreen),
    w = minWidth(isFullscreen),
    h = minHeight(isFullscreen)
  }
end

--
-- Window movement to various screen positions
--
function m.moveTopLeft(win,offx,offy)
  win = win or hs.window.focusedWindow()
  offx = offx or 0
  offy = offy or 0

  win:setFrame({
      x = win:screen():frame().x + offx,
      y = win:screen():frame().y + offy,
      w = win:frame().w,
      h = win:frame().h,
  })
end

function m.moveBottomLeft(win,offx,offy)
  win = win or hs.window.focusedWindow()
  offx = offx or 0
  offy = offy or 0

  win:setFrame({
      x = win:screen():frame().x + offx,
      y = win:screen():frame().y + win:screen():frame().h - win:frame().h + offy,
      w = win:frame().w,
      h = win:frame().h,
  })
end

function m.moveTopRight(win, offx, offy)
  win = win or hs.window.focusedWindow()
  offx = offx or 0
  offy = offy or 0

  win:setFrame({
      x = win:screen():frame().x + win:screen():frame().w - win:frame().w + offx,
      y = win:screen():frame().y + offy,
      w = win:frame().w,
      h = win:frame().h,
  })
end

function m.moveBottomRight(win, offx, offy)
  win = win or hs.window.focusedWindow()
  offx = offx or 0
  offy = offy or 0

  win:setFrame({
      x = win:screen():frame().x + win:screen():frame().w - win:frame().w + offx ,
      y = win:screen():frame().y + win:screen():frame().h - win:frame().h + offy,
      w = win:frame().w,
      h = win:frame().h,
  })
end

--
-- Window moving to edges
--
-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function m.right(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  minFrame.x = minFrame.x + (minFrame.w/2)
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function m.left(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function m.up(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function m.down(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  minFrame.y = minFrame.y + minFrame.h/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function m.upLeft(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  minFrame.w = minFrame.w/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function m.downLeft(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x,
    y = minFrame.y + minFrame.h/2,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +-----------------+
-- |                 |
-- |        +--------|
-- |        |  HERE  |
-- +-----------------+
function m.downRight(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x + minFrame.w/2,
    y = minFrame.y + minFrame.h/2,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +-----------------+
-- |        |  HERE  |
-- |        +--------|
-- |                 |
-- +-----------------+
function m.upRight(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x + minFrame.w/2,
    y = minFrame.y,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +------------------+
-- |                  |
-- |    +--------+    +--> minY
-- |    |  HERE  |    |
-- |    +--------+    |
-- |                  |
-- +------------------+
-- Where the window's size is equal to
-- the smaller available screen size
function m.fullscreenCenter(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  win:setFrame(minFrame)
end

-- +------------------+
-- |                  |
-- |  +------------+  +--> minY
-- |  |    HERE    |  |
-- |  +------------+  |
-- |                  |
-- +------------------+
function m.fullscreenAlmostCenter(win)
  win = win or hs.window.focusedWindow()
  local offsetW = minX(win:screen()) - almostMinX(win:screen())
  win:setFrame({
    x = almostMinX(win:screen()),
    y = minY(win:screen()),
    w = minWidth(isFullscreen) + (2 * offsetW),
    h = minHeight(isFullscreen)
  })
end

-- It like fullscreen but with minY and minHeight values
-- +------------------+
-- |                  |
-- +------------------+--> minY
-- |       HERE       |
-- +------------------+--> minHeight
-- |                  |
-- +------------------+
function m.fullscreenWidth(win)
  win = win or hs.window.focusedWindow()
  local minFrame = minFrame(win:screen(), false)
  win:setFrame({
    x = win:screen():frame().x,
    y = minFrame.y,
    w = win:screen():frame().w,
    h = minFrame.h
  })
end


--
-- Window moving by percentage of screen size
--
function m.moveLeft(win)
  win = win or hs.window.focusedWindow()

  win:setFrame({
      x = win:frame().x - win:screen():frame().w * (m.cfg.movePct / 100.0),
      y = win:frame().y,
      w = win:frame().w,
      h = win:frame().h,
  })    
end

function m.moveRight(win)
  win = win or hs.window.focusedWindow()

  win:setFrame({
      x = win:frame().x + win:screen():frame().w * (m.cfg.movePct / 100.0),
      y = win:frame().y,
      w = win:frame().w,
      h = win:frame().h,
  })    
end

function m.moveUp(win)
  win = win or hs.window.focusedWindow()

  win:setFrame({
      x = win:frame().x,
      y = win:frame().y - win:screen():frame().h * (m.cfg.movePct / 100.0),
      w = win:frame().w,
      h = win:frame().h,
  })
end

function m.moveDown(win)
  win = win or hs.window.focusedWindow()

  win:setFrame({
      x = win:frame().x,
      y = win:frame().y + win:screen():frame().h * (m.cfg.movePct / 100.0),
      w = win:frame().w,
      h = win:frame().h,
  })
end

-- helpers for keybindings


return m
