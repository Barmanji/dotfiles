------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "1920x1080",
	position = "auto",
	scale = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "nautilus"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("mpd")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("swaync & awww & waybar & hyprpaper & hyprsunset & hypridle & walker --gapplication-service & elephant")
	hl.exec_cmd("clipse -listen & wl-clipboard-history -t & wl-paste --watch cliphist store")
	hl.exec_cmd("$HOME/.config/hypr/scripts/utility/ExportEnvioromentVar.sh & $HOME/.config/awww/awww.sh")
	hl.exec_cmd("$HOME/.config/hypr/scripts/utility/Music_sleep_autoYtMusicStopperForStartup.sh")
end)

hl.on("hyprland.start", function()
	hl.exec_cmd("zen-browser", { workspace = "2 silent" })
	hl.exec_cmd(terminal, { workspace = "3" })
	hl.exec_cmd(terminal, { workspace = "special:magic silent" })
	-- hl.exec_cmd("$HOME/.config/hypr/scripts/utility/Music_sleep_autoYtMusicStopperForStartup.sh", { workspace = "6 silent" })
	hl.exec_cmd(terminal, { workspace = "10 silent" })
end)
-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "20") -- 24 -> 20
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


