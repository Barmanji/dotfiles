

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Kitty
hl.window_rule({
  name = "windowrule-1",
  match = { class = "kitty" },
  opacity = "1 0.85"
})

-- Nautilus
hl.window_rule({
  name = "windowrule-2",
  match = { class = "org.gnome.Nautilus" },
  no_blur = true,
  opacity = "0.9"
})

-- YouTube Music
-- YouTube Music
hl.window_rule({
  name = "windowrule-4",
  match = { class = "com.github.th_ch.youtube_music" },
  no_blur = true,
  opacity = "0.9",
  workspace = "6 silent", -- This forces it to workspace 6 without pulling your screen focus
})

-- Ignore maximize requests from all apps
hl.window_rule({
  name = "windowrule-6",
  match = { class = ".*" },
  suppress_event = "maximize"
})

-- Alacritty float centered
hl.window_rule({
  name = "Alacritty_float_centered",
  match = {
    class = "^(Alacritty)$",
    title = "^(Alacritty)$"
  },
  float = true,
  no_blur = true,
  center = true,
  size = {900, 650}
})

-- Clipse clipboard
hl.window_rule({
  name = "clipse_clipboard_chickbum",
  match = { class = "(clipse)" },
  float = true,
  center = true,
  size = {622, 652}
})

-- Blur/Opacity utility
hl.window_rule({
  name = "windowrule-8",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false
  },
  no_focus = true
})

-- Postman
hl.window_rule({
  name = "windowrule-9",
  match = { class = "Postman" },
  opacity = "0.92"
})

-- Calculator
hl.window_rule({
  name = "windowrule-10",
  match = { class = "org.gnome.Calculator" },
  opacity = "0.9"
})

hl.window_rule({
    match = {
        class = "com.rafaelmardojai.Blanket", -- adjust if your system uses a different class name
    },
    opacity = "0.9",
    workspace = "6 silent",
    float = false,
    -- Adjusts the tiling split ratio so Blanket stays narrow (0.23 = 23% of screen width)
    -- Change this value slightly to get the exact width from your screenshot
})
-- LAYER RULES
-- Waybar
hl.layer_rule({
  name = "layerrule-1",
  match = { namespace = "waybar" },
  blur = true,
  ignore_alpha = 0.5
})

-- SwayNC Control Center
hl.layer_rule({
  name = "layerrule-4",
  match = { namespace = "swaync-control-center" },
  blur = true,
  ignore_alpha = 0.5
})

-- SwayNC Notification Window
hl.layer_rule({
  name = "layerrule-5",
  match = { namespace = "swaync-notification-window" },
  blur = true,
  ignore_alpha = 0.5
})
