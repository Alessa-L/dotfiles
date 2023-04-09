current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -P -o "[0-9]{1,3}%" | head -1 | grep -E -o "[0-9]{1,3}")

max_volume=100

if [ $current_volume -le $max_volume ] && [ $1 == - ]; then
    pactl set-sink-volume @DEFAULT_SINK@ -$2
elif [ $current_volume -lt $max_volume ]; then
    pactl set-sink-volume @DEFAULT_SINK@ $1$2
fi
