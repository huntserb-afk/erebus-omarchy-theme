#!/usr/bin/env bash

STATE_FILE="$HOME/.config/omarchy/erebus/current-state"
WALLPAPER_DIR="$HOME/.config/omarchy/erebus/wallpapers"

HOUR=$(date +%H)

if (( HOUR >= 6 && HOUR < 9 )); then
    STATE="dawn"
elif (( HOUR >= 9 && HOUR < 17 )); then
    STATE="day"
elif (( HOUR >= 17 && HOUR < 21 )); then
    STATE="dusk"
else
    STATE="night"
fi

THEME="erebus-$STATE"

case "$STATE" in
    dawn)  WALLPAPER="$WALLPAPER_DIR/EREBUS-DAWN.jpg" ;;
    day)   WALLPAPER="$WALLPAPER_DIR/EREBUS-DAY.jpg" ;;
    dusk)  WALLPAPER="$WALLPAPER_DIR/EREBUS-DUSK.jpg" ;;
    night) WALLPAPER="$WALLPAPER_DIR/EREBUS-NIGHT.jpg" ;;
esac

LAST_STATE=""

if [[ -f "$STATE_FILE" ]]; then
    LAST_STATE=$(cat "$STATE_FILE")
fi

echo "╭─[ E R E B U S ]"
echo "╰─[ DARKNESS: $STATE ]"

if [[ "$STATE" != "$LAST_STATE" ]]; then
    echo "$STATE" > "$STATE_FILE"

    echo "Erebus awakens: $THEME"

    omarchy theme set "$THEME"
    sleep 1
    omarchy theme bg set "$WALLPAPER"
fi
