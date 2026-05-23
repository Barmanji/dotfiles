#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly


STATE=$(hyprctl -j getoption decoration:blur:enabled | jq ".bool")

if [ "${STATE}" == "false" ]; then
    hyprctl eval 'hl.config({ decoration = { blur = { enabled = true } } })'
    notify-send -e -u critical "Blur"
else
    hyprctl eval 'hl.config({ decoration = { blur = { enabled = false } } })'
    notify-send -e -u critical "Transparent"
fi
