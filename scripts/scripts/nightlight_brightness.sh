#!/usr/bin/env bash

currTime=$(date +%-H)
currTemp=$(hyprctl hyprsunset temperature)
currGamma=$(hyprctl hyprsunset gamma)

if [[ "$currTemp" -le 4000 ]]; then
    hyprctl hyprsunset gamma 100
    hyprctl hyprsunset temperature 6000
    notify-send -e -u critical "NightLight Off"
else
    hyprctl hyprsunset temperature 4000
    hyprctl hyprsunset gamma 90
    notify-send -e -u critical "NightLight On"
fi


