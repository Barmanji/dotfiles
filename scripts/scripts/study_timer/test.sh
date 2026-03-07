#!/usr/bin/env bash

# --- Whitelist: Timer starts if title contains these ---
KEYWORDS="neetcode|ts|scripts|javascript|js|~|dsa|react|coding|study|nvim|helix|vns|github|stackover|documentation|course|exercism|leetcode|roadmap.sh|google chrome|"

# --- Blacklist: Timer STOPS if title contains these, even if a whitelist word is present ---
# Example: "javascript - Reddit" would stop because of 'reddit'
BLACKLIST="reddit|facebook|instagram|twitter|x.com|twitch|discord|netflix|crunchyroll|null"

# File Paths
TIMER_FILE="$HOME/scripts/study_timer/timer_raw.log"
LOG_FILE="$HOME/scripts/study_timer/total_time_perDay.log"

mkdir -p "$(dirname "$LOG_FILE")"

save_to_log() {
    local session_seconds=$1
    local today=$(date +%Y-%m-%d)
    touch "$LOG_FILE"

    local existing_entry=$(grep "^$today:" "$LOG_FILE")
    local total_seconds=$session_seconds

    if [ -n "$existing_entry" ]; then
        local previous_seconds=$(echo "$existing_entry" | awk -F'|' '{print $2}')

        # Safety catch for massive/buggy numbers
        if [ "$previous_seconds" -gt 86400 ]; then previous_seconds=0; fi

        total_seconds=$((previous_seconds + session_seconds))
        sed -i "/^$today:/d" "$LOG_FILE"
    fi

    local h=$((total_seconds / 3600))
    local m=$(( (total_seconds % 3600) / 60 ))
    local s=$((total_seconds % 60))
    printf "%s: %02dh %02dm %02ds |%d\n" "$today" $h $m $s "$total_seconds" >> "$LOG_FILE"
}

start_timer() {
    if [ ! -f "$TIMER_FILE" ]; then
        date +%s > "$TIMER_FILE"
        notify-send "Timer Started" "Focusing on: $1" -h string:x-canonical-private-synchronous:timer -t 1500
    fi
}

stop_timer() {
    if [ -f "$TIMER_FILE" ]; then
        local start_time=$(cat "$TIMER_FILE")
        local end_time=$(date +%s)
        local elapsed=$((end_time - start_time))

        if [ "$elapsed" -gt 2 ] && [ "$elapsed" -lt 43200 ]; then
            save_to_log "$elapsed"
            notify-send "Timer Stopped" "Session logged." -h string:x-canonical-private-synchronous:timer -t 1500
        fi
        rm "$TIMER_FILE"
    fi
}

handle_event() {
    TITLE=$(hyprctl activewindow -j | jq -r ".title" 2>/dev/null)
    echo "$TITLE"

    # 1. Check Blacklist FIRST
    if echo "$TITLE" | grep -Ei "$BLACKLIST" > /dev/null; then
        stop_timer
    # 2. Check Whitelist SECOND
    elif echo "$TITLE" | grep -Ei "$KEYWORDS" > /dev/null; then
        start_timer "$TITLE"
    # 3. If neither, stop
    else
        stop_timer
    fi
}

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    case "$line" in
        activewindowv2*|workspace*)
            handle_event
            ;;
    esac
done
