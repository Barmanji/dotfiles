#!/usr/bin/env bash
#
# # Wait 5 seconds before launching YouTube Music to allow network to initialize
# sleep 5
#
# # Launch YouTube Music in background
# youtube-music &
#
# # Wait until any player is available via playerctl
# until playerctl --player=%any status &>/dev/null; do
#   sleep 5
# done
#
# # Pause playback
# playerctl --all-players pause

# 1. Count how many chromium instances are running BEFORE launching YT Music
initial_count=$(playerctl --list-all 2>/dev/null | grep -c "chromium")

# Wait 5 seconds to allow network to initialize
sleep 5

# Launch YouTube Music in background
youtube-music &

# 2. Wait until a NEW chromium instance registers on MPRIS
until [ "$(playerctl --list-all 2>/dev/null | grep -c "chromium")" -gt "$initial_count" ]; do
  sleep 1
done

# 3. Give the web app an extra moment to load the page and trigger autoplay
sleep 3

# 4. Target the active chromium players and pause them
playerctl --player=chromium pause
