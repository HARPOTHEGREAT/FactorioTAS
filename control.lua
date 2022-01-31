-- Make sure the intro cinematic of freeplay doesn't play every time we restart
-- This is just for convenience, don't worry if you don't understand how this works
script.on_init(function()
    local freeplay = remote.interfaces["freeplay"]
    if freeplay then  -- Disable freeplay popup-message
        if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
        if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
    end
end)

script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)

    local screen_element = player.gui.screen
    local main_frame = screen_element.add{type="frame", name="tas_main_frame"}
    main_frame.style.size = {385, 165}
    main_frame.auto_center = true
        
    local content_frame = main_frame.add{type="frame", name="content_frame", direction="vertical", style="tas_content_frame"}
    local controls_flow = content_frame.add{type="flow", name="controls_flow", direction="horizontal", style="tas_controls_flow"}

    controls_flow.add{type="button", name="tas_pause_toggle", caption={"tas_pause"}}
    controls_flow.add{type="button", name="tas_tickadv", caption={"tas_tickadv"}}
end)




script.on_event('tas-tools:pause-unpause',
    if not tick-paused then
        tick-paused = true
    else
        tick-paused = false
        end
    end)
