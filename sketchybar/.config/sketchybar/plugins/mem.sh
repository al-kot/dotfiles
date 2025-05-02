#!/bin/sh

MEM="$(top -l 1 | grep -E "^Phys" | awk '{sum+=$2+0} END {print int(sum/8000*100)}')"
MEMICON=" "

sketchybar -m --set $NAME icon=$MEMICON label="$MEM%"
