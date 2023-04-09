#!/bin/bash

# Small script to switch between two hardcoded sound output devices

current_sink=$(pactl get-default-sink)

# Set patterns for devices to be toggled. Have to match to second column
# in output of "pactl list short sinks".
toggle1="HDMI"
toggle2="HS70"

# Read the output of "pactl list short sinks" line by line and and set up toggles
while read -r stream; do
    if echo "$stream" | grep -q -i "$toggle1"; then
      toggle1_sink=$(echo "$stream" | cut -f2)
    fi
    if echo "$stream" | grep -q -i "$toggle2"; then
      toggle2_sink=$(echo "$stream" | cut -f2)
    fi
done < <(pactl list short sinks)

# Change sink and create a notification informing the switch
if [ "$current_sink" = "$toggle1_sink" ]; then
    pactl set-default-sink "$toggle2_sink"
    notify-send "Audio output changed to: HS70"
else
    pactl set-default-sink "$toggle1_sink"
    notify-send "Audio output changed to: HDMI"
fi
