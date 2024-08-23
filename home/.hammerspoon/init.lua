-- Add space to screen
hs.hotkey.bind({"alt", "shift"}, "M", function()
  hs.spaces.addSpaceToScreen()
end)

-- Remove space from screen
hs.hotkey.bind({"alt", "shift"}, "N", function()
  local allSpaces = hs.spaces.allSpaces()
  -- Get the current screen

  local screen = hs.screen.mainScreen()
  -- Get the spaces for the current screen
  local screenSpaces = allSpaces[screen:getUUID()]

  if screenSpaces and #screenSpaces > 1 then
      -- Get the last space ID
      local lastSpaceID = screenSpaces[#screenSpaces]
      -- Remove the last space
      hs.spaces.removeSpace(lastSpaceID)
  else
      hs.alert.show("No additional spaces to remove")
  end
end)

-- Function to move all windows from one space to another
function moveWindowsBetweenSpaces(space1, space2)
    -- Get all windows in the first space
    local windows1 = hs.spaces.windowsForSpace(space1)
    -- Get all windows in the second space
    local windows2 = hs.spaces.windowsForSpace(space2)
    -- Move each window from the first space to the second space
    for _, win in ipairs(windows1) do
        hs.spaces.moveWindowToSpace(win, space2)
    end
    -- Move each window from the second space to the first space
    for _, win in ipairs(windows2) do
        hs.spaces.moveWindowToSpace(win, space1)
    end
    -- Move to the second space
    hs.spaces.gotoSpace(space2)
end
-- Function to get the current space
function getCurrentSpace()
    local currentScreen = hs.screen.mainScreen()
    local currentSpace = hs.spaces.activeSpaceOnScreen(currentScreen)
    return currentSpace
end
-- Function to get all spaces
function getAllSpaces()
    local currentScreen = hs.screen.mainScreen()
    local allSpaces = hs.spaces.spacesForScreen(currentScreen)
    local nonFullScreenSpaces = {}
    for _, space in ipairs(allSpaces) do
        if hs.spaces.spaceType(space) == "user" then
            table.insert(nonFullScreenSpaces, space)
        end
    end
    return nonFullScreenSpaces
end
-- Move all windows to the previous space
hs.hotkey.bind({"ctrl", "shift"}, "U", function()
  local allSpaces = getAllSpaces()
  local currentSpace = getCurrentSpace()
  local currentIndex = hs.fnutils.indexOf(allSpaces, currentSpace)
  if currentIndex and currentIndex < #allSpaces then
    local nextSpace = allSpaces[currentIndex + 1]
    moveWindowsBetweenSpaces(currentSpace, nextSpace)
  else
    hs.alert.show("No next space available")
  end
end)
-- Move all windows to the previous space
hs.hotkey.bind({"ctrl", "shift"}, "Y", function()
  local allSpaces = getAllSpaces()
  local currentSpace = getCurrentSpace()
  local currentIndex = hs.fnutils.indexOf(allSpaces, currentSpace)
  if currentIndex and currentIndex > 1 then
    local previousSpace = allSpaces[currentIndex - 1]
    moveWindowsBetweenSpaces(currentSpace, previousSpace)
  else
    hs.alert.show("No previous space available")
  end
end)

-- Dismiss notifications
hs.hotkey.bind({"ctrl", "shift"}, "N", function()
  local script = [[
      tell application "System Events"
        tell process "NotificationCenter"
          if not (window "Notification Center" exists) then return
          set alertGroups to groups of first UI element of first scroll area of first group of window "Notification Center"
          repeat with aGroup in alertGroups
            try
              perform (first action of aGroup whose name contains "Close" or name contains "Clear")
            on error errMsg
              log errMsg
            end try
          end repeat
          -- Show no message on success
          return ""
        end tell
      end tell
  ]]
  hs.osascript.applescript(script)
end)

-- Expand notifications
function expandNotifications()
    -- Get the screen size
    local screen = hs.screen.mainScreen()
    local screenFrame = screen:frame()

    local clickArea = hs.geometry.rect(screenFrame.w - 100, 65, 1, 1)
    -- Move the mouse to the click area and click
    hs.mouse.setAbsolutePosition(clickArea.center)

    -- Simulate a click event
    hs.eventtap.leftClick(clickArea.center)
end

hs.hotkey.bind({"ctrl", "shift"}, "B", expandNotifications)

-- Copy screenshot
function copyScreenshot()
    -- Get the screen size
    local screen = hs.screen.mainScreen()
    local screenFrame = screen:frame()

    local clickArea = hs.geometry.rect(220, screenFrame.h - 60, 1, 1)
    -- Move the mouse to the click area and click
    hs.mouse.setAbsolutePosition(clickArea.center)

    -- Simulate a click event
    hs.eventtap.leftClick(clickArea.center)
end

hs.hotkey.bind({"ctrl", "shift"}, "S", copyScreenshot)

hs.hotkey.bind({"ctrl", "shift"}, "T", function()
  local screen = hs.screen.mainScreen()
  local screenFrame = screen:frame()

  local clickArea = hs.geometry.rect(100, 100, 1, 1)
  -- Move the mouse to the click area and click
  hs.mouse.setAbsolutePosition(clickArea.center)
end)

-- Move to left top corner
hs.hotkey.bind({"ctrl", "shift"}, "C", function()
  local screen = hs.screen.mainScreen()
  local screenFrame = screen:frame()

  local clickArea = hs.geometry.rect(screenFrame.w - 100, screenFrame.h - 65, 1, 1)
  -- Move the mouse to the click area and click
  hs.mouse.setAbsolutePosition(clickArea.center)
end)

-- Move Window
local function moveWindow(offsetX, offsetY)
    local win = hs.window.focusedWindow()
    if win then
        local frame = win:frame()
        frame.x = frame.x + offsetX
        frame.y = frame.y + offsetY
        win:setFrame(frame)
    else
        hs.alert.show("No focused window")
    end
end

hs.hotkey.bind({"ctrl", "shift"}, "L", function() moveWindow(50, 0) end)
hs.hotkey.bind({"ctrl", "shift"}, "H", function() moveWindow(-50, 0) end)
hs.hotkey.bind({"ctrl", "shift"}, "K", function() moveWindow(0, -50) end)
hs.hotkey.bind({"ctrl", "shift"}, "J", function() moveWindow(0, 50) end)

-- Resize Window
local function resizeWindow(direction, change)
    local win = hs.window.focusedWindow()
    if win then
        local frame = win:frame()
        if direction == "right" then
            frame.w = frame.w + change
        elseif direction == "left" then
            frame.w = frame.w - change
        elseif direction == "up" then
            frame.h = frame.h - change
        elseif direction == "down" then
            frame.h = frame.h + change
        end
        win:setFrame(frame)
    else
        hs.alert.show("No focused window")
    end
end

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "L", function() resizeWindow("right", 50) end)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "H", function() resizeWindow("left", 50) end)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "K", function() resizeWindow("up", 50) end)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "J", function() resizeWindow("down", 50) end)

-- Move the mouse
local function moveMouse(direction, value)
    local currentPos = hs.mouse.getAbsolutePosition()
    if direction == "right" then
        currentPos.x = currentPos.x + value
    elseif direction == "left" then
        currentPos.x = currentPos.x - value
    elseif direction == "up" then
        currentPos.y = currentPos.y - value
    elseif direction == "down" then
        currentPos.y = currentPos.y + value
    end
    hs.mouse.setAbsolutePosition(currentPos)
end

hs.hotkey.bind({"ctrl", "cmd"}, "L", function() moveMouse("right", 20) end, nil , function() moveMouse("right", 20) end)
hs.hotkey.bind({"ctrl", "cmd"}, "H", function() moveMouse("left", 20) end, nil , function() moveMouse("left", 20) end)
hs.hotkey.bind({"ctrl", "cmd"}, "K", function() moveMouse("up", 20) end, nil , function() moveMouse("up", 20) end)
hs.hotkey.bind({"ctrl", "cmd"}, "J", function() moveMouse("down", 20) end, nil , function() moveMouse("down", 20) end)

-- Triggers a click
local function clickMouse()
    hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
end
hs.hotkey.bind({"ctrl", "cmd"}, "N", clickMouse, nil, clickMouse)

-- Scroll up
function scrollUp()
    -- Simulate a scroll up event
    hs.eventtap.scrollWheel({0, -10}, {}, "line")
end
hs.hotkey.bind({"ctrl", "cmd"}, "Y", scrollUp, nil, scrollUp)

-- Scroll down
function scrollDown()
    -- Simulate a scroll down event
    hs.eventtap.scrollWheel({0, 10}, {}, "line")
end
hs.hotkey.bind({"ctrl", "cmd"}, "U", scrollDown, nil, scrollDown)
