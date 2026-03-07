#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly


STATE=$(hyprctl -j getoption decoration:blur:enabled | jq ".int")

if [ "${STATE}" == "0" ]; then
    hyprctl keyword decoration:blur:enabled true
    notify-send -e -u critical "Blur"
else
    hyprctl keyword decoration:blur:enabled false
    notify-send -e -u critical "Transparent"
fi
