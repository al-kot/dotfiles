#!/bin/sh

cur=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep 'KeyboardLayout Name' | sed -E 's/^.+ = \"?([^\"]+)\"?;$/\1/')

if [ "$cur" = "Colemak DH Matrix" ]; then
    sketchybar --set $NAME label="CO"
elif [ "$cur" = "U.S." ]; then
    sketchybar --set $NAME label="US"
elif [ "$cur" = "RussianWin" ]; then
    sketchybar --set $NAME label="RU"
elif [ "$cur" = "Colemak" ]; then
    sketchybar --set $NAME label="CO"
else
    sketchybar --set $NAME label="??"
fi


