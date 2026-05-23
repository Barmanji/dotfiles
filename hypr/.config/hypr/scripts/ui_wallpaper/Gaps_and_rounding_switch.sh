#!/bin/bash

STATE=$(hyprctl -j getoption general:gaps_in | jq -r '.css | split(" ")[0] | tonumber')

default_gaps_in=2
default_gaps_out=0,7,7,7
default_rounding=14

if [ "${STATE}" == "2" ]; then
hyprctl eval 'hl.config({ general = { gaps_in = 0, gaps_out = 0 }, decoration = { rounding = 0 } })'
 	notify-send -e -u critical "Gaps & Rounding disabled"
else
hyprctl eval "hl.config({
    general = {
        gaps_in = $default_gaps_in,
        gaps_out = {top = 0, left = 7, right = 7, bottom = 7}
    },
    decoration = {
        rounding = $default_rounding
    }
})"
    notify-send -e -u critical "Gaps & Rounding enabled"
fi
