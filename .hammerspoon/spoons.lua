hspoon_list = {"AClock", "FnMate", "VimMode", "WinWin"}

-- Load those Spoons
for _, v in pairs(hspoon_list) do hs.loadSpoon(v) end

function activateAppM()
    spoon.ModalMgr:deactivateAll()
    -- Show the keybindings cheatsheet once appM is activated
    spoon.ModalMgr:activate({"appM"}, "#5c6370", true)
end

function activateWindowHints()
    spoon.ModalMgr:deactivateAll()
    hs.hints.windowHints()
end

function activateLockScreen() hs.caffeinate.lockScreen() end

spoon.ModalMgr:new("appM")
appModal = spoon.ModalMgr.modal_list["appM"]
appModal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
appModal:bind('', 'Q', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
appModal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
hsapp_list = {
    {key = 'f', name = 'Finder'},
    {key = 'g', name = 'Google Chrome'},
    {key = 't', name = 'Terminal'},
    {key = 'v', id = 'com.apple.ActivityMonitor'},
    {key = 'y', id = 'com.apple.systempreferences'}
}
for _, v in ipairs(hsapp_list) do
    if v.id then
        local located_name = hs.application.nameForBundleID(v.id)
        if located_name then
            appModal:bind(
                '', v.key, located_name, function()
                    hs.application.launchOrFocusByBundleID(v.id)
                    spoon.ModalMgr:deactivate({"appM"})
                end)
        end
    elseif v.name then
        appModal:bind(
            '', v.key, v.name, function()
                hs.application.launchOrFocus(v.name)
                spoon.ModalMgr:deactivate({"appM"})
            end)
    end
end

spoon.ModalMgr.supervisor:bind(localHyperKey, "Tab", 'Show Window Hints', activateWindowHints)
spoon.ModalMgr.supervisor:bind(hyperKey, "L", "Lock Screen", activateLockScreen)
spoon.ModalMgr.supervisor:bind(hyperKey, "A", "Enter AppM Environment", activateAppM)

--- Register VimMode
if spoon.VimMode then
    local vim = spoon.VimMode:new()

    -- Configure apps you do *not* want Vim mode enabled in
    -- For example, you don't want this plugin overriding your control of Terminal
    -- vim
    vim:disableForApp('Code'):disableForApp('zoom.us'):disableForApp('iTerm'):disableForApp('iTerm2'):disableForApp(
        'Terminal'):disableForApp('Alacritty')

    -- If you want the screen to dim (a la Flux) when you enter normal mode
    -- flip this to true.
    vim:shouldDimScreenInNormalMode(false)

    -- If you want to show an on-screen alert when you enter normal mode, set
    -- this to true
    vim:shouldShowAlertInNormalMode(true)

    -- You can configure your on-screen alert font
    vim:setAlertFont("Courier New")

    -- Enter normal mode by typing a key sequence
    -- vim:enterWithSequence('jk')

    -- if you want to bind a single key to entering vim, remove the
    -- :enterWithSequence('jk') line above and uncomment the bindHotKeys line
    -- below:
    --
    -- To customize the hot key you want, see the mods and key parameters at:
    --   https://www.hammerspoon.org/docs/hs.hotkey.html#bind
    --
    vim:bindHotKeys({enter = {hyperKey, ';'}})
end

--- Register AClock
if spoon.AClock then
    spoon.ModalMgr.supervisor:bind(hyperKey, "T", "Toggle Floating Clock", function() spoon.AClock:toggleShow() end)
end

--- Register WinWin
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]

    local function activateResizeM()
        -- Deactivate some modal environments or not before activating a new one
        spoon.ModalMgr:deactivateAll()
        -- Show an status indicator so we know we're in some modal environment now
        spoon.ModalMgr:activate({"resizeM"}, "#B22222")
    end

    local toggleMaximizedMap = {}

    function maximizeWin()
        local win = hs.window.frontmostWindow()
        if not (win:isMaximizable()) then return end
        win:application():activate(true)
        win:application():unhide()
        win:focus()
        win:maximize(0)
    end

    cmodal:bind('', 'escape', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'Q', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
    cmodal:bind(
        '', 'A', 'Move Leftward', function() spoon.WinWin:stepMove("left") end, nil,
        function() spoon.WinWin:stepMove("left") end)
    cmodal:bind(
        '', 'D', 'Move Rightward', function() spoon.WinWin:stepMove("right") end, nil,
        function() spoon.WinWin:stepMove("right") end)
    cmodal:bind(
        '', 'W', 'Move Upward', function() spoon.WinWin:stepMove("up") end, nil,
        function() spoon.WinWin:stepMove("up") end)
    cmodal:bind(
        '', 'S', 'Move Downward', function() spoon.WinWin:stepMove("down") end, nil,
        function() spoon.WinWin:stepMove("down") end)
    cmodal:bind('', 'H', 'Lefthalf of Screen', function() spoon.WinWin:moveAndResize("halfleft") end)
    cmodal:bind('', 'L', 'Righthalf of Screen', function() spoon.WinWin:moveAndResize("halfright") end)
    cmodal:bind('', 'K', 'Uphalf of Screen', function() spoon.WinWin:moveAndResize("halfup") end)
    cmodal:bind('', 'J', 'Downhalf of Screen', function() spoon.WinWin:moveAndResize("halfdown") end)
    cmodal:bind('', 'Y', 'NorthWest Corner', function() spoon.WinWin:moveAndResize("cornerNW") end)
    cmodal:bind('', 'O', 'NorthEast Corner', function() spoon.WinWin:moveAndResize("cornerNE") end)
    cmodal:bind('', 'U', 'SouthWest Corner', function() spoon.WinWin:moveAndResize("cornerSW") end)
    cmodal:bind('', 'I', 'SouthEast Corner', function() spoon.WinWin:moveAndResize("cornerSE") end)
    cmodal:bind('', 'F', 'Fullscreen', function() spoon.WinWin:moveAndResize("fullscreen") end)
    cmodal:bind('', 'C', 'Center Window', function() spoon.WinWin:moveAndResize("center") end)
    cmodal:bind('', 'M', 'Maximize Window', maximizeWin, maximizeWin, maximizeWin)
    cmodal:bind(
        '', '=', 'Stretch Outward', function() spoon.WinWin:moveAndResize("expand") end, nil,
        function() spoon.WinWin:moveAndResize("expand") end)
    cmodal:bind(
        '', '-', 'Shrink Inward', function() spoon.WinWin:moveAndResize("shrink") end, nil,
        function() spoon.WinWin:moveAndResize("shrink") end)
    cmodal:bind(
        'shift', 'H', 'Move Leftward', function() spoon.WinWin:stepResize("left") end, nil,
        function() spoon.WinWin:stepResize("left") end)
    cmodal:bind(
        'shift', 'L', 'Move Rightward', function() spoon.WinWin:stepResize("right") end, nil,
        function() spoon.WinWin:stepResize("right") end)
    cmodal:bind(
        'shift', 'K', 'Move Upward', function() spoon.WinWin:stepResize("up") end, nil,
        function() spoon.WinWin:stepResize("up") end)
    cmodal:bind(
        'shift', 'J', 'Move Downward', function() spoon.WinWin:stepResize("down") end, nil,
        function() spoon.WinWin:stepResize("down") end)
    cmodal:bind('', 'left', 'Move to Left Monitor', function() spoon.WinWin:moveToScreen("left") end)
    cmodal:bind('', 'right', 'Move to Right Monitor', function() spoon.WinWin:moveToScreen("right") end)
    cmodal:bind('', 'up', 'Move to Above Monitor', function() spoon.WinWin:moveToScreen("up") end)
    cmodal:bind('', 'down', 'Move to Below Monitor', function() spoon.WinWin:moveToScreen("down") end)
    cmodal:bind('', 'space', 'Move to Next Monitor', function() spoon.WinWin:moveToScreen("next") end)
    cmodal:bind('', '[', 'Undo Window Manipulation', function() spoon.WinWin:undo() end)
    cmodal:bind('', ']', 'Redo Window Manipulation', function() spoon.WinWin:redo() end)
    cmodal:bind('', '`', 'Center Cursor', function() spoon.WinWin:centerCursor() end)

    -- Register resizeM with modal supervisor
    spoon.ModalMgr.supervisor:bind(hyperKey, "Z", "Enter resizeM Environment", activateResizeM)
    appModal:bind('', 'R', 'Resize', activateResizeM)
end
