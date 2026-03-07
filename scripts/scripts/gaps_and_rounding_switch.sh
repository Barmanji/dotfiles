#!/bin/bash

STATE=$(hyprctl -j getoption general:gaps_in | jq -r '.custom | split(" ")[0] | tonumber')

default_gaps_in=2
default_gaps_out=0,7,7,7
default_rounding=14

if [ "${STATE}" == "2" ]; then
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword decoration:rounding 0
 	notify-send -e -u critical "Gaps & Rounding disabled"
else
    hyprctl keyword general:gaps_in $default_gaps_in
    hyprctl keyword general:gaps_out $default_gaps_out
    hyprctl keyword decoration:rounding $default_rounding
    notify-send -e -u critical "Gaps & Rounding enabled"
fi
