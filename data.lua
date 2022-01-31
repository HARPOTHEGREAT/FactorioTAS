data:extend({
    
    {
      type = 'custom-input',
      name = 'tas-tools:pause-unpause',
      consuming = nil,
      },
    
    {
      type = 'custom-input',
      name = 'tas-tools:frame-advance',
      consuming = nil,
      },
    
    {
      type = 'custom-input',
      name = 'tas-tools:toggle-input-display',
      consuming = nil,
      },
    
    })

local styles = data.raw["gui-style"].default

styles["ugg_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["ugg_controls_flow"] = {
    type = "horizontal_flow_style",
    vertical_align = "center",
    horizontal_spacing = 16
}

styles["ugg_controls_textfield"] = {
    type = "textbox_style",
    width = 36
}

styles["ugg_deep_frame"] = {
    type = "frame_style",
    parent = "slot_button_deep_frame",
    vertically_stretchable = "on",
    horizontally_stretchable = "on",
    top_margin = 16,
    left_margin = 8,
    right_margin = 8,
    bottom_margin = 4
}
