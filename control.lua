-- Make sure the intro cinematic of freeplay doesn't play every time we restart
script.on_init(function()
    local freeplay = remote.interfaces["freeplay"] --detect if freeplay
    if freeplay then  -- Disable freeplay popup-message
        if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
        if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)

    local screen_element = player.gui.screen --create tas interface panel
    tas_frame = screen_element.add{type="frame", name="tas_main_frame", caption={"tas.tas_gui"}} --initialize frame
    tas_frame.style.size = {385, 165} --set frame size (edit later)
    tas_frame.auto_center = false --make sure frame does not cover character
    
    local content_frame = tas_frame.add{type="frame", name="content_frame", direction="vertical", style="tas_content_frame"} --set frame style
    local controls_flow = content_frame.add{type="flow", name="controls_flow", direction="horizontal", style="tas_controls_flow"} --set subframe style

    controls_flow.add{type="button", name="tas_pause_toggle", caption={"tas.pause"}} --add button to pause/unpause
    controls_flow.add{type="button", name="tas_tickadv", caption={"tas.tickadv"}} --add button to advance one tick while paused
end)

script.on_event(defines.events.on_gui_click, function(event) --listen for all gui clicks (this is just how it works)
    if event.element.name == "tas_pause" then --check if the gui click was for the pause button (again, this is just how it needs to work)
        
        local control_toggle = event.element
        tas_pause_toggle.caption = (tick_paused) and {"tas.unpause"} or {"tas.pause"} --flip button label between pause and unpause
    end
end)


script.on_event('tas-tools:pause-unpause', function(e)
    if not game.tick_paused then
        game.tick_paused = true
    else
        game.tick_paused = false
        end
    end)

script.on_event('tas-tools:frame-advance', function(e)
    if game.tick_paused then
        game.ticks_to_run = 1
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
