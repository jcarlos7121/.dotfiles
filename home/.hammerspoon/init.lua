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

hs.hotkey.bind({"ctrl", "alt"}, "right", function() moveWindow(50, 0) end)
hs.hotkey.bind({"ctrl", "alt"}, "left", function() moveWindow(-50, 0) end)
hs.hotkey.bind({"ctrl", "alt"}, "up", function() moveWindow(0, -50) end)
hs.hotkey.bind({"ctrl", "alt"}, "down", function() moveWindow(0, 50) end)

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

hs.hotkey.bind({"ctrl", "alt", "shift"}, "right", function() resizeWindow("right", 50) end)
hs.hotkey.bind({"ctrl", "alt", "shift"}, "left", function() resizeWindow("left", 50) end)
hs.hotkey.bind({"ctrl", "alt", "shift"}, "up", function() resizeWindow("up", 50) end)
hs.hotkey.bind({"ctrl", "alt", "shift"}, "down", function() resizeWindow("down", 50) end)
