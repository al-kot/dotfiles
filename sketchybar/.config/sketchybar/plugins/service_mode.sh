#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$MODE" = "on" ]; then
    sketchybar --set service_mode drawing=on
else
    sketchybar --set service_mode drawing=off
fi
