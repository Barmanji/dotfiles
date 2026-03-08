#!/usr/bin/env bash

# --- 1. Configuration ---
KEYWORDS="neetcode|ts|scripts|javascript|js|dsa|react|coding|study|nvim|helix|vns|github|stackover|documentation|course|exercism|leetcode|roadmap.sh|google chrome|"
BLACKLIST="reddit|facebook|instagram|twitter|x.com|twitch|discord|netflix|crunchyroll|null|youtube"

TIMER_FILE="$HOME/scripts/study_timer/timer_raw.log"
LOG_FILE="$HOME/scripts/study_timer/total_time_perDay.log"

mkdir -p "$(dirname "$LOG_FILE")"

# --- 2. Logic Functions ---
save_to_log() {
    local session_seconds=$1
    local today=$(date "+%d-%b-%Y")
    [ ! -f "$LOG_FILE" ] && touch "$LOG_FILE"

    local existing_entry=$(grep "^$today:" "$LOG_FILE")
    local total_seconds=$session_seconds

    if [ -n "$existing_entry" ]; then
        local previous_seconds=$(echo "$existing_entry" | awk -F'|' '{print $2}')
        [ "$previous_seconds" -gt 86400 ] && previous_seconds=0
        total_seconds=$((previous_seconds + session_seconds))
        sed -i "/^$today:/d" "$LOG_FILE"
    fi

    local h=$((total_seconds / 3600))
    local m=$(( (total_seconds % 3600) / 60 ))
    local s=$((total_seconds % 60))
    printf "%s: %02dh %02dm %02ds |%d\n" "$today" $h $m $s "$total_seconds" >> "$LOG_FILE"
}

stop_timer() {
    if [ -f "$TIMER_FILE" ]; then
        local start_time=$(cat "$TIMER_FILE")
        local end_time=$(date +%s)
        local elapsed=$((end_time - start_time))

        if [ "$elapsed" -gt 2 ] && [ "$elapsed" -lt 43200 ]; then
            save_to_log "$elapsed"
            notify-send "Timer Stopped" "Session logged ($((elapsed/60))m)." -h string:x-canonical-private-synchronous:timer -t 1500
        fi
        rm -f "$TIMER_FILE"
    fi
}

start_timer() {
    if [ ! -f "$TIMER_FILE" ]; then
        date +%s > "$TIMER_FILE"
        notify-send "Timer Started" "Focusing on: $1" -h string:x-canonical-private-synchronous:timer -t 1500
    fi
}

handle_event() {
    TITLE=$(hyprctl activewindow -j | jq -r ".title" 2>/dev/null)

    if [[ -z "$TITLE" || "$TITLE" == "null" ]]; then
        stop_timer
        return
    fi

    if echo "$TITLE" | grep -Ei "$BLACKLIST" > /dev/null; then
        stop_timer
    elif echo "$TITLE" | grep -Ei "$KEYWORDS" > /dev/null; then
        start_timer "$TITLE"
    else
        stop_timer
    fi
}

# --- 3. The Gatekeeper (Handle 'stop' signal) ---
if [ "$1" == "stop" ]; then
    stop_timer
    # Kill the background socat listener
    pkill -f "test.sh"
    exit 0
fi

# --- 4. Main Listener Loop ---
# Kill any existing instances to prevent duplicates
pkill -f "socat.*hypr" 2>/dev/null

# Clear stale timer on start
rm -f "$TIMER_FILE"

socat -U - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
    case "$line" in
        activewindowv2*|workspace*)
            handle_event
            ;;
    esac
done
