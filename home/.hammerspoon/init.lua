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

-- TODO: not working on Sequoia
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
-- TODO: not working on Sequoia
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
-- TODO: not working on Sequoia
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
    use AppleScript version "2.4" -- Yosemite (10.10) or later
    use scripting additions
    use framework "Foundation"
    property NSArray : a reference to current application's NSArray
    property closeActionSet : {"Close", "Clear All", "Schließen", "Alle entfernen", "Cerrar", "Borrar todo", "关闭", "清除全部", "Fermer", "Tout effacer", "Закрыть", "Очистить все", "إغلاق", "مسح الكل", "Fechar", "Limpar tudo", "閉じる", "すべてクリア", "बंद करें", "सभी हटाएं", "Zamknij", "Wyczyść wszystko"}

    on run
    	try

    		tell application "System Events"
    			set _headings to UI elements of scroll area 1 of group 1 of group 1 of window 1 of application process "NotificationCenter" whose role is "AXHeading"
    			set _headingscount to count of _headings
    		end tell

    		repeat _headingscount times
    			tell application "System Events" to set _roles to role of UI elements of scroll area 1 of group 1 of group 1 of window 1 of application process "NotificationCenter"
    			set _headingIndex to its getIndexOfItem:"AXHeading" inList:_roles
    			set _closeButtonIndex to _headingIndex + 1
    			tell application "System Events" to click item _closeButtonIndex of UI elements of scroll area 1 of group 1 of group 1 of window 1 of application process "NotificationCenter"
    			delay 0.4
    		end repeat

    		tell application "System Events"
    			set _buttons to buttons of scroll area 1 of group 1 of group 1 of window 1 of application process "NotificationCenter" -- whose subrole is not missing value

    			repeat with _button in _buttons
    				set _actions to actions of first item of _buttons # always picking the first to avoid index error
    				repeat with _action in _actions
    					if description of _action is in closeActionSet then
    						perform _action
    					end if
    				end repeat
    			end repeat
    		end tell
    	on error eStr number eNum
    		display notification eStr with title "Error " & eNum sound name "Frog"
    	end try
    end run

    on getIndexOfItem:anItem inList:aList
    	set anArray to NSArray's arrayWithArray:aList
    	set ind to ((anArray's indexOfObject:anItem) as number) + 1
    	if ind is greater than (count of aList) then
    		display dialog "Item '" & anItem & "' not found in list." buttons "OK" default button "OK" with icon 2 with title "Error"
    		return 0
    	else
    		return ind
    	end if
    end getIndexOfItem:inList:
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
