#!/usr/bin/env sh

er="$(networksetup -getairportpower en0)"
WIFIACTIVEICON=􀙇
WIFIINACTIVEICON=􀙈
if [ "$er" = "" ]; then
    sketchybar --set $NAME icon=$WIFIINACTIVEICON label=""
else
    wname=$(ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')

    sketchybar --set $NAME icon=$WIFIACTIVEICON label="$wname"
fi
