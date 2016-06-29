--
-- Various window movement functions
--

function hs.screen.get(screen_name)
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    if screen:name() == screen_name then
      return screen
    end
  end
end

-- Returns the width of the smaller screen size
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minWidth(isFullscreen)
  local min_width = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
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
function hs.screen.minHeight(isFullscreen)
  local min_height = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
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
function hs.screen.minX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + ((refScreen:frame().w - hs.screen.minWidth()) / 2)
  end
  return min_x
end

-- If you are using more than one monitor, returns Y
-- considering the focused screen minus smaller screen
-- = (MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2
-- If using only one monitor, returns the Y of focused screen
function hs.screen.minY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + ((refScreen:frame().h - hs.screen.minHeight()) / 2)
  end
  return min_y
end

-- If you are using more than one monitor, returns the
-- half of minX and 0
-- = ((MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2) / 2
-- If using only one monitor, returns the X of ref screen
function hs.screen.almostMinX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + (((refScreen:frame().w - hs.screen.minWidth()) / 2) - ((refScreen:frame().w - hs.screen.minWidth()) / 4))
  end
  return min_x
end

-- If you are using more than one monitor, returns the
-- half of minY and 0
-- = ((MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2) / 2
-- If using only one monitor, returns the Y of ref screen
function hs.screen.almostMinY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + (((refScreen:frame().h - hs.screen.minHeight()) / 2) - ((refScreen:frame().h - hs.screen.minHeight()) / 4))
  end
  return min_y
end

-- Returns the frame of the smaller available screen
-- considering the context of refScreen
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minFrame(refScreen, isFullscreen)
  return {
    x = hs.screen.minX(refScreen),
    y = hs.screen.minY(refScreen),
    w = hs.screen.minWidth(isFullscreen),
    h = hs.screen.minHeight(isFullscreen)
  }
end

function hs.window.moveTopLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
	x = minFrame.x,
	y = minFrame.y,
	w = win:frame().w,
	h = win:frame().h,
	})
end

function hs.window.moveBottomLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
	x = minFrame.x,
	y = minFrame.y + win:screen():frame().h - win:frame().h,
	w = win:frame().w,
	h = win:frame().h,
	})
end

function hs.window.moveTopRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
	x = minFrame.x + win:screen():frame().w - win:frame().w,
	y = minFrame.y,
	w = win:frame().w,
	h = win:frame().h,
	})
end

function hs.window.moveBottomRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
	x = minFrame.x + win:screen():frame().w - win:frame().w,
	y = minFrame.y + win:screen():frame().h - win:frame().h,
	w = win:frame().w,
	h = win:frame().h,
	})
end

function hs.window.moveRight(win)
  win:setFrame({
	x = win:frame().x + win:screen():frame().w * 0.10,
	y = win:frame().y,
	w = win:frame().w,
	h = win:frame().h,
	})
end

function hs.window.moveLeft(win)
  win:setFrame({
	x = win:frame().x - win:screen():frame().w * 0.10,
	y = win:frame().y,
	w = win:frame().w,
	h = win:frame().h,
	})
end

function hs.window.moveUp(win)
  win:setFrame({
	x = win:frame().x,
	y = win:frame().y - win:screen():frame().h * 0.10,
	w = win:frame().w,
	h = win:frame().h,
	})
end

function hs.window.moveDown(win)
  win:setFrame({
	x = win:frame().x,
	y = win:frame().y + win:screen():frame().h * 0.10,
	w = win:frame().w,
	h = win:frame().h,
	})
end

-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function hs.window.right(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.x = minFrame.x + (minFrame.w/2)
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function hs.window.left(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function hs.window.up(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function hs.window.down(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.y = minFrame.y + minFrame.h/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function hs.window.upLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.w = minFrame.w/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function hs.window.downLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
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
function hs.window.downRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
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
function hs.window.upRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
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
function hs.window.fullscreenCenter(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame(minFrame)
end

-- +------------------+
-- |                  |
-- |  +------------+  +--> minY
-- |  |    HERE    |  |
-- |  +------------+  |
-- |                  |
-- +------------------+
function hs.window.fullscreenAlmostCenter(win)
  local offsetW = hs.screen.minX(win:screen()) - hs.screen.almostMinX(win:screen())
  win:setFrame({
    x = hs.screen.almostMinX(win:screen()),
    y = hs.screen.minY(win:screen()),
    w = hs.screen.minWidth(isFullscreen) + (2 * offsetW),
    h = hs.screen.minHeight(isFullscreen)
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
function hs.window.fullscreenWidth(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = win:screen():frame().x,
    y = minFrame.y,
    w = win:screen():frame().w,
    h = minFrame.h
  })
end
