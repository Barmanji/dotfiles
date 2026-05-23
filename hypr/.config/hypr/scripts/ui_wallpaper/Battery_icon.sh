#!/bin/bash

# Get the current battery percentage and charging state
battery_info=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
battery_percentage=$(echo "$battery_info" | grep -i percentage | awk '{print $2}' | sed 's/%//')
charging_state=$(echo "$battery_info" | grep -i state | awk '{print $2}')

# Define Nerd Font icons for charging and discharging states
if [ "$charging_state" = "charging" ]; then
    if [ "$battery_percentage" -ge 75 ]; then
        icon=""  # Fully charged charging icon
    elif [ "$battery_percentage" -ge 50 ]; then
        icon=""  # Medium battery charging icon
    elif [ "$battery_percentage" -ge 25 ]; then
        icon=""  # Low battery charging icon
    else
        icon=""  # Critical battery charging icon
    fi
else
    if [ "$battery_percentage" -ge 75 ]; then
        icon=""  # Fully charged icon
    elif [ "$battery_percentage" -ge 50 ]; then
        icon=""  # Medium battery icon
    elif [ "$battery_percentage" -ge 25 ]; then
        icon=""  # Low battery icon
    elif [ "$battery_percentage" -ge 15 ]; then
        icon=""  # Critical low battery icon
    else
        icon="!"  # Critical battery icon
    fi
fi

# Print the icon along with the battery percentage
echo "$icon $battery_percentage%"

