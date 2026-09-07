-- Move windows off the damaged (not visible) monitor onto the primary display.
-- Windows on the laptop's built-in screen are left where they are.
local HIDDEN_SCREEN_PATTERN = "BenQ"

local function gatherWindows()
  local target = hs.screen.primaryScreen()
  local hidden = hs.screen.find(HIDDEN_SCREEN_PATTERN)
  local moved = 0

  if hidden and hidden:id() ~= target:id() then
    for _, win in ipairs(hs.window.allWindows()) do
      local screen = win:screen()
      if win:isStandard() and screen and screen:id() == hidden:id() then
        win:moveToScreen(target, false, true)
        moved = moved + 1
      end
    end
  end

  hs.alert.show(moved .. " window(s) gathered")
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "G", gatherWindows)

-- Run it automatically a couple of seconds after any display change
screenWatcher = hs.screen.watcher.new(function()
  hs.timer.doAfter(2, gatherWindows)
end)
screenWatcher:start()

-- Reload the config without touching the menu bar
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", hs.reload)

hs.alert.show("Hammerspoon config loaded")
