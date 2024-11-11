#!/bin/sh

while true; do
    n=$(yay -Qu | wc -l)

    if [ "$n" -eq "0" ]; then
        echo "{\"text\":\"\",\"alt\":\"updated\",\"tooltip\":\"System is up to date\",\"class\":\"updated\"}"
    else
        echo "{\"text\":\"$n\",\"alt\":\"update-needed\",\"tooltip\":\"System is up to date\",\"class\":\"update-needed\"}"
    fi
    sleep 60
done

