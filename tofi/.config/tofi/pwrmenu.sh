#!/bin/sh

case $(printf "%s\n" "poweroff" "reboot" "suspend" "hibernate" | tofi $@) in
	"poweroff")
		systemctl poweroff
		;;
	"reboot")
		systemctl reboot
		;;
	"suspend")
		systemctl suspend
		;;
	"hibernate")
		systemctl hibernate
		;;
esac
