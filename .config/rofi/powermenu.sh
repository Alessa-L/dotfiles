#!/usr/bin/env bash

theme="card_square"
dir="$HOME/.config/rofi"

uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -theme $dir/$theme"

# Options
shutdown=""
reboot=""
lock=""
suspend=""
logout=""

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
