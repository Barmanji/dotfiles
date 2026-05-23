#!/bin/bash

ACTIVE_WINDOW=$(hyprctl activewindow -j)
CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class')

if [ "$CLASS" = "org.gnome.Nautilus" ]; then
    # Ensure Nautilus is focused
    hyprctl dispatch 'hl.dsp.window.focus({ match = { class = "org.gnome.Nautilus" } })'
    sleep 0.15

    # Wayland-safe key presses
    wtype -M ctrl l
    sleep 0.01
    wtype -M ctrl c
    # sleep 0.01
    wtype -k Escape

    PATH_DIR=$(wl-paste | tr -d '\r\n' | sed 's|^file://||')

    if [ -d "$PATH_DIR" ]; then
        alacritty --working-directory "$PATH_DIR"
        exit 0
    fi
fi

alacritty

# #!/bin/bash
#
# LOG="/tmp/nautilus-alacritty.log"
# echo "==========================" >> "$LOG"
# echo "Run at: $(date)" >> "$LOG"
#
# ACTIVE_WINDOW=$(hyprctl activewindow -j)
# CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class')
#
# echo "CLASS: $CLASS" >> "$LOG"
#
# if [ "$CLASS" = "org.gnome.Nautilus" ]; then
#     echo "Nautilus detected" >> "$LOG"
#
#     # Ensure Nautilus is focused
#     hyprctl dispatch focuswindow class:org.gnome.Nautilus
#     sleep 0.15
#
#     # Wayland-safe key presses
#     wtype -M ctrl l
#     sleep 0.15
#     wtype -M ctrl c
#     sleep 0.15
#     wtype Opening in Alacritty...
#     sleep 0.65
#     wtype -k Escape
#
#     PATH_DIR=$(wl-paste | tr -d '\r\n' | sed 's|^file://||')
#     echo "CLIPBOARD PATH: [$PATH_DIR]" >> "$LOG"
#
#     if [ -d "$PATH_DIR" ]; then
#         echo "Directory exists → launching alacritty" >> "$LOG"
#         alacritty --working-directory "$PATH_DIR" >> "$LOG" 2>&1
#         exit 0
#     else
#         echo "Directory DOES NOT exist" >> "$LOG"
#     fi
# else
#     echo "Active window is NOT Nautilus" >> "$LOG"
# fi
#
# echo "Fallback: launching alacritty without cwd" >> "$LOG"
# alacritty >> "$LOG" 2>&1
