-- Make sure the intro cinematic of freeplay doesn't play every time we restart
script.on_init(function()
    local freeplay = remote.interfaces["freeplay"] --detect if freeplay
    if freeplay then  -- Disable freeplay popup-message
        if freeplay["set_skip_intro"] then remote.call("freeplay", "set_skip_intro", true) end
        if freeplay["set_disable_crashsite"] then remote.call("freeplay", "set_disable_crashsite", true) end
    end
    global.players = {} --initialize a table in global for each player
    current_tick = 0 --initialize current_tick for use in advance_frame
    active_toggle = true --initialize a toggle for active/inactive
end)

--create tas interface panel on character creation
script.on_event(defines.events.on_player_created, function(event)
    local player = game.get_player(event.player_index)

    screen_element = player.gui.screen
    local tas_frame = screen_element.add{type="frame", name="tas_main_frame", caption={"tas.tas_gui"}} --initialize frame
    tas_frame.style.size = {385, 165} --set frame size (edit later)
    tas_frame.auto_center = false --make sure frame does not cover character
    
    local content_frame = tas_frame.add{type="frame", name="content_frame", direction="vertical", style="tas_content_frame"} --set frame style
    local controls_flow_pause = content_frame.add{type="flow", name="controls_flow_pause", direction="horizontal", style="tas_controls_flow"} --set flow style
    local controls_flow_speed = content_frame.add{type="flow", name="controls_flow_speed", direction="horizontal", style="tas_controls_flow"} --set flow style

    controls_flow_pause.add{type="button", name="tas_pause_toggle", caption={"tas.pause"}} --add button to pause/unpause
    controls_flow_pause.add{type="button", name="tas_tickadv", caption={"tas.tickadv"}} --add button to advance one tick while paused
    controls_flow_pause.tas_tickadv.enabled = false --make advance tick start disabled
        
    controls_flow_speed.add{type="slider", name="tas_gamespeed_slider", value=1, minimum_value=0.01, maximum_value=10, style="notched_slider"} --add gamespeed slider
    controls_flow_speed.add{type="textfield", name="tas_gamespeed_textfield", text="1", numeric=true, allow_decimal=true, allow_negative=false, style="tas_controls_textfield"} --add gamespeed textfield
end)

--pause game if unpaused, unpause game if paused
local function pause_toggle()
    --when game.tick_paused is set to false, the next tick has incredibly limited character action
    if not game.tick_paused then
        game.tick_paused = true
        player = game.players[1]
        for _, a in pairs(player.walking_state) do game.print(a); end
    else
        game.tick_paused = false
    end
    local controls_flow_pause = player.gui.screen.tas_main_frame.content_frame.controls_flow_pause
    controls_flow_pause.tas_pause_toggle.caption = (game.tick_paused) and {"tas.unpause"} or {"tas.pause"} --flip button label between pause and unpause
    controls_flow_pause.tas_tickadv.enabled = game.tick_paused --disable tick advance if unpaused
    --[[if(active_toggle) then
        for _,p in pairs(game.players) do p.active = false; end
        active_toggle = false
    else
        for _,p in pairs(game.players) do p.active = true; end
        active_toggle = true
        end]]--
end

local function advance_frame()
    --[[
    player = game.players[1]
    local is_walking = player.walking_state[1]
    game.print(is_walking)
    local walking_direction = player.walking_state[2]
    game.print(walking_direction)
    if is_walking then
        game.player.walking_state = {walking = true, direction = walking_direction}
        game.ticks_to_run = 1 --setting this to 2 kina works, first tick still has no movement
    else
        end
    ]]--
    
    --[[
    current_tick = game.tick --define current_tick as the current game.tick
    game.print("Initial current_tick is " .. current_tick)
    game.print("Initial game.tick is " .. game.tick)
    
    --zero game ticks elapse during execution of a loop; the loop will never resolve
    
    --loop that unpauses game for one tick
    repeat
        if (game.tick == current_tick) then --check for if no ticks have passed
            game.tick_paused = false
            game.print("current_tick is " .. current_tick)
            game.print("game.tick is " .. game.tick)
            break --remove this break later, only here to show no time passes during execution of a loop
        else -- break if ticks have passed
            break
            end
    until (game.tick > current_tick)
    game.tick_paused = true
    game.print("Final current_tick is " .. current_tick)
    game.print("Final game.tick is " .. game.tick)
    end
    ]]--
    
    --game.ticks_to_run = 1
    
    
    
    end

--listen for all gui clicks
script.on_event(defines.events.on_gui_click, function(event)
    if event.element.name == "tas_pause_toggle" then --check if the gui click was for the pause button
        pause_toggle()
    end
        if event.element.name == "tas_tickadv" then --check if the gui click was for the tick advance button
        advance_frame()
    end
end)

--listen for all gui value changes
script.on_event(defines.events.on_gui_value_changed, function(event)
    if event.element.name == "tas_controls_slider" then --check if the value change was for the gamespeed slider

        local new_speed_value = event.element.slider_value --get updated slider value

        local controls_flow = player.gui.screen.tas_main_frame.content_frame.controls_flow_speed
        controls_flow.tas_gamespeed_textfield.text = tostring(new_speed_value) --paste slider value into gamespeed textfield
    end
end)

--listen for all gui text edits
script.on_event(defines.events.on_gui_text_changed, function(event)
    if event.element.name == "tas_controls_textfield" then --check if the text edit was for the gamespeed textfield

        local new_speed_count = tonumber(event.element.text) or 1 --get updated text and convert to number, set to 1 if blank
        local capped_speed_count --initialize slider count
        local tas_gamespeed_slider = player.gui.screen.tas_main_frame.content_frame.controls_flow_speed.tas_gamespeed_slider
        local slider_min = get_slider_minimum(tas_gamespeed_slider)
        local slider_max = get_slider_maximum(tas_gamespeed_slider)
            
        -- ensure slider is only set to values within it's range
        if new_speed_count > slider_max then --if more than slider maximum, set to maximum
            capped_speed_count = slider_max
        elseif new_speed_count < slider_min then --if less than slider minimum, set to slider minimum
            capped_speed_count = slider_min
        else
            capped_speed_count = new_speed_count --else, use actual value
        end

        
        tas_gamespeed_slider.slider_value = capped_speed_count --set slider to new, capped value
    end
end)

--pause/unpause on hotkey press
script.on_event('tas-tools:pause-unpause', function(e)
    pause_toggle()
    end)

--call frame_advance on hotkey press
script.on_event('tas-tools:frame-advance', function(e)
    if game.tick_paused then
        advance_frame()
    else
        end
    end)
--call frame_advance on hotkey press
script.on_event('tas-tools:two_frame-advance', function(e)
    if game.tick_paused then
        game.ticks_to_run = 2
    else
        end
    end)

--toggle gui on hotkey press
script.on_event('tas-tools:toggle-input-display', function(e)
    if tas_frame.visible then
        tas_frame.visible = false
    else
        tas_frame.visible = true
        end
    end)
