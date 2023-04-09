pactl set-source-mute alsa_input.usb-Corsair_CORSAIR_HS70_Pro_Wireless_Gaming_Headset-00.mono-fallback toggle

micStatus=$(pactl get-source-mute alsa_input.usb-Corsair_CORSAIR_HS70_Pro_Wireless_Gaming_Headset-00.mono-fallback | grep yes)

if [ "$micStatus" ]; then
    notify-send "Microphone muted"
else
    notify-send "Microphone unmuted"
fi

