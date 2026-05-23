#!/usr/bin/env bash

# Wait 5 seconds before launching YouTube Music to allow network to initialize
sleep 5

# Launch YouTube Music in background
youtube-music &

# Wait until any player is available via playerctl
until playerctl --player=%any status &>/dev/null; do
  sleep 1
done

# Pause playback
playerctl --player=%any pause
