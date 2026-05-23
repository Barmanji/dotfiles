#!/bin/bash

# Notification icon

# Get current mute state (this outputs "MUTED" or "UNMUTED")
state=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $3}')

if [ "$state" = "[MUTED]" ]; then
    # If muted, unmute
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
    notify-send -e -u critical  "Microphone Unmuted"
else
    # If unmuted, mute
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
    notify-send -e -u critical "Microphone Muted"
fi
