hs.hotkey.bind({"alt", "shift"}, "M", function()
  hs.spaces.addSpaceToScreen()
end)

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

-- Bind the function to a key combination, e.g., ctrl + alt + N
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

function expandNotifications()
    -- Get the screen size
    local screen = hs.screen.mainScreen()
    local screenFrame = screen:frame()

    local clickArea = hs.geometry.rect(screenFrame.w - 100, (screenFrame.h / 2) - 400, 1, 1)
    -- Move the mouse to the click area and click
    hs.mouse.setAbsolutePosition(clickArea.center)
    -- hs.eventtap.leftClick(clickArea.center)
    -- Optionally, you can add more clicks or scrolls to ensure all notifications are expanded
    -- For example, you can scroll down to reveal more notifications
    hs.eventtap.scrollWheel({0, -10}, {}, "line") -- Scroll up
end

hs.hotkey.bind({"ctrl", "shift"}, "B", expandNotifications)

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

-- triggers a click
local function clickMouse()
    hs.eventtap.leftClick(hs.mouse.getAbsolutePosition())
end
hs.hotkey.bind({"ctrl", "cmd"}, "N", clickMouse, nil, clickMouse)
