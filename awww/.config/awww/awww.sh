#!/usr/bin/bash

# Wallpaper directory
WALLPAPERS_DIR="/home/barmanji/Downloads/ColorWall/"

# Hyprlock config file
HYPRLOCK_CONFIG="$HOME/.config/hypr/hyprlock.conf"

# Kill other running instances of this script
pkill -fx "$0" 2>/dev/null

# Start awww-daemon if not already running
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    exit 0  # Exit if this is the first run
fi

# Select a random wallpaper with valid extensions
WALLPAPER=$(find "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" \) | shuf -n 1)

# Apply wallpaper if found
if [[ -n "$WALLPAPER" ]]; then
    echo "$WALLPAPER" > "/home/barmanji/.config/hypr/lib/current_wallpaper.txt"  # Save the wallpaper path

    # Apply wallpaper with awww
    awww img "$WALLPAPER" \
        --transition-type wave \
        --transition-angle 135 \
        --transition-wave 30,20 \
        --transition-step 200 \
        --transition-duration 1 \
        --transition-fps 200

    # Update Hyprlock config with new wallpaper path (only in the background section)
    sed -i "/background {/,/}/s|path = .*|path = $WALLPAPER|" "$HYPRLOCK_CONFIG"

    # Reload Hyprlock to apply the new wallpaper
    pkill -USR1 hyprlock 2>/dev/null
else
    echo "No valid wallpapers found in $WALLPAPERS_DIR"
fi

# sleep "$INTERVAL"  # Disabled automatic wallpaper change
