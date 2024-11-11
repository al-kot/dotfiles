#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5


# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host='host'

# Options
shutdown=' Shutdown'
reboot=' Reboot'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$host" \
		-config "$HOME/.config/rofi/pwrmenu.rasi"
}

# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-config "$HOME/.config/rofi/pwrmenu.rasi"
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ $1 == '--shutdown' ]]; then
        systemctl poweroff
    elif [[ $1 == '--reboot' ]]; then
        systemctl reboot
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
esac
