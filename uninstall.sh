#!/usr/bin/env bash
set -e

OMARCHY_THEMES="$HOME/.config/omarchy/themes"
EREBUS_DIR="$HOME/.config/omarchy/erebus"
SYSTEMD_DIR="$HOME/.config/systemd/user"

echo "╭─[ E R E B U S ]"
echo "╰─[ UNINSTALLER ]"
echo

echo "[1/4] Stopping darkness cycle..."
systemctl --user disable --now erebus-darkness.timer 2>/dev/null || true
systemctl --user stop erebus-darkness.service 2>/dev/null || true

echo "[2/4] Removing Erebus themes..."
for theme in dawn day dusk night abyss; do
    rm -rf "$OMARCHY_THEMES/erebus-$theme"
done

echo "[3/4] Removing Erebus files..."
rm -rf "$EREBUS_DIR"
rm -f "$SYSTEMD_DIR/erebus-darkness.service"
rm -f "$SYSTEMD_DIR/erebus-darkness.timer"

echo "[4/4] Reloading systemd..."
systemctl --user daemon-reload

echo
echo "Erebus has been removed."
echo "Your other Omarchy themes and settings were left untouched."
