#!/bin/bash
# Power Profile Toggle Script for Hyprland

# Check if power-profiles-daemon is running
if ! systemctl is-active --quiet power-profiles-daemon; then
    echo "Error: power-profiles-daemon is not running"
    echo "Please start it with: sudo systemctl enable --now power-profiles-daemon"
    exit 1
fi

# Get current power profile
current_profile=$(powerprofilesctl get)

# Toggle between balanced and performance
if [ "$current_profile" = "balanced" ]; then
    powerprofilesctl set performance
    notify-send -t 1000 "Power Profile" "Switched to Performance mode" -i battery-full
    echo "Switched to Performance mode"
elif [ "$current_profile" = "performance" ]; then
    powerprofilesctl set balanced
    notify-send -t 1000 "Power Profile" "Switched to Balanced mode" -i battery-good
    echo "Switched to Balanced mode"
else
    # If currently on power-saver, switch to balanced
    powerprofilesctl set balanced
    notify-send -t 1000 "Power Profile" "Switched to Balanced mode" -i battery-good
    echo "Switched to Balanced mode (from power-saver)"
fi

# Display current profile
echo "Current profile: $(powerprofilesctl get)"

