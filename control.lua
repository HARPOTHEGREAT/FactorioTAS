-- Make sure the intro cinematic of freeplay doesn't play every time we restart
script.on_init(function()
    local freeplay = remote.interfaces["freeplay"] --detect if freeplay
    if freeplay then  -- Disable freeplay popup-message
        if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
        if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
    end
    global.players = {} --initialize a table in global for each player
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)

    local screen_element = player.gui.screen --create tas interface panel
    tas_frame = screen_element.add{type="frame", name="tas_main_frame", caption={"tas.tas_gui"}} --initialize frame
    tas_frame.style.size = {385, 165} --set frame size (edit later)
    tas_frame.auto_center = false --make sure frame does not cover character
    
    content_frame = tas_frame.add{type="frame", name="content_frame", direction="vertical", style="tas_content_frame"} --set frame style
    controls_flow = content_frame.add{type="flow", name="controls_flow", direction="horizontal", style="tas_controls_flow"} --set subframe style

    controls_flow.add{type="button", name="tas_pause_toggle", caption={"tas.pause"}} --add button to pause/unpause
    controls_flow.add{type="button", name="tas_tickadv", caption={"tas.tickadv"}} --add button to advance one tick while paused
end)

local function pause_toggle() --pause game if unpaused, unpause game if paused
    if not game.tick_paused then
        game.tick_paused = true
        player = game.players[1]
        for _, a in pairs(player.walking_state) do game.print(a); end
    else
        game.tick_paused = false
        end
    local player = game.get_player(event.player_index)
        game.player.gui.controls_flow.tas_pause_toggle.caption = (game.tick_paused) and {"tas.unpause"} or {"tas.pause"} --flip button label between pause and unpause
    end

script.on_event(defines.events.on_gui_click, function(event) --listen for all gui clicks (this is just how it works)
    if event.element.name == "tas_pause_toggle" then --check if the gui click was for the pause button (again, this is just how it needs to work)
        
        local tas_pause_toggle = event.element
        pause_toggle()
        --tas_pause_toggle.caption = (game.tick_paused) and {"tas.unpause"} or {"tas.pause"} --flip button label between pause and unpause
        
    end
end)

local function advance_frame()
    --local is_walking = game.player.walking_state
    
    local walking_direction = game.player.walking_state[direction]
    if is_walking then
        game.ticks_to_run = 1
        game.player.walking_state = {walking = true, direction = walking_direction}
    else
        end
    end

script.on_event('tas-tools:pause-unpause', function(e) --pause/unpause on hotkey press
    pause_toggle()
    end)

script.on_event('tas-tools:frame-advance', function(e)
    if game.tick_paused then
        advance_frame()
    else
        end
    end)

script.on_event('tas-tools:toggle-input-display', function(e)
    if tas_frame.visible then
        tas_frame.visible = false
    else
        tas_frame.visible = true
        end
    end)
