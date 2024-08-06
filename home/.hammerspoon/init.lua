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
