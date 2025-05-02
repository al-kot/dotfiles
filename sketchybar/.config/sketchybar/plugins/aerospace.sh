#!/usr/bin/env bash

source "$HOME/.config/colors/sketchybar.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.color=0xffddc7a1 label.color=0xff1d2021
else
    sketchybar --set $NAME background.color=0xff1d2021 label.color=0xffddc7a1
fi
