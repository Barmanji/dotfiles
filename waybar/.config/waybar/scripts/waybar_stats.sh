#!/usr/bin/env bash

LOG_FILE="$HOME/scripts/study_timer/total_time_perDay.log"
TIMER_FILE="$HOME/scripts/study_timer/timer_raw.log"
today=$(date "+%d-%b-%Y")

# Get already logged time for today
logged_seconds=$(grep "^$today:" "$LOG_FILE" | awk -F'|' '{print $2}')
[ -z "$logged_seconds" ] && logged_seconds=0

# If a session is CURRENTLY active, add that time too
if [ -f "$TIMER_FILE" ]; then
    start_time=$(cat "$TIMER_FILE")
    current_time=$(date +%s)
    active_seconds=$((current_time - start_time))
    total=$((logged_seconds + active_seconds))
    # Output with a "Focusing" icon (e.g., a brain or book)
    icon="󰑉"
else
    total=$logged_seconds
    icon=""
fi

# Format for Waybar (HH:MM)
h=$((total / 3600))
m=$(( (total % 3600) / 60 ))
s=$((total % 60))

# Update the format string to include %02ds for seconds
printf "{\"text\": \"%s %02dh %02dm %02ds\", \"tooltip\": \"Total Study Time Today\"}\n" "$icon" "$h" "$m" "$s"
