#!/usr/bin/env bash

theme="launcher.rasi"
dir="$HOME/.config/rofi"

uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=" : Shutdown System"
reboot=" : Reboot System"
lock=" : Lock Session"
suspend=" : Suspend Session"
logout=" : Logout of Session"

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"
chosen="$(echo -e "$options" | $rofi_command -dmenu)"
case $chosen in
    $shutdown)
		systemctl poweroff
        ;;
    $reboot)
		systemctl reboot
        ;;
    $lock)
		dm-tool lock
        ;;
    $suspend)
		xfce4-session-logout --suspend
        ;;
    $logout)
		xfce4-session-logout --logout --fast
        ;;
esac
