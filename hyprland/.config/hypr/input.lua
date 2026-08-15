hl.config({
  input = {
    -- Multiple layouts, switch with Left Alt + Right Alt
    kb_layout = "ch",
    kb_variant = "de",
    kb_options = "compose:caps", -- ",grp:alts_toggle"

    repeat_rate = 40,
    repeat_delay = 600,

    numlock_by_default = true,

    -- sensitivity = 0.35,

    touchpad = {
      -- natural_scroll = true,
      -- clickfinger_behavior = true,
      scroll_factor = 0.4,
      -- disable_while_typing = false,
      -- drag_3fg = 1,
    },
  },
})
