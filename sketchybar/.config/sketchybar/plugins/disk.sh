#!/usr/bin/env sh
AVAIL="$(df -h | grep '/System/Volumes/Data$' | awk '{print int(($4+0)*1.074)}')"
DISKICON=􀤂

sketchybar -m --set $NAME icon=$DISKICON label="$AVAIL"Gb
