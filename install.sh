#!/usr/bin/env bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OMARCHY_THEMES="$HOME/.config/omarchy/themes"
EREBUS_DIR="$HOME/.config/omarchy/erebus"
SYSTEMD_DIR="$HOME/.config/systemd/user"

echo "╭─[ E R E B U S ]"
echo "╰─[ INSTALLER ]"
echo

echo "[1/5] Creating directories..."
mkdir -p "$OMARCHY_THEMES"
mkdir -p "$EREBUS_DIR/wallpapers"
mkdir -p "$SYSTEMD_DIR"

echo "[2/5] Installing themes..."
for theme in dawn day dusk night abyss; do
    rm -rf "$OMARCHY_THEMES/erebus-$theme"
    cp -a "$REPO_DIR/themes/erebus-$theme" "$OMARCHY_THEMES/"
done

echo "[3/5] Installing wallpapers..."
cp -f "$REPO_DIR/wallpapers/"*.jpg "$EREBUS_DIR/wallpapers/"

echo "[4/5] Installing darkness cycle..."
cp -f "$REPO_DIR/darkness/darkness.sh" "$EREBUS_DIR/darkness.sh"
chmod +x "$EREBUS_DIR/darkness.sh"

cp -f "$REPO_DIR/darkness/erebus-darkness.service" "$SYSTEMD_DIR/"
cp -f "$REPO_DIR/darkness/erebus-darkness.timer" "$SYSTEMD_DIR/"

echo "[5/5] Enabling Erebus..."
systemctl --user daemon-reload
systemctl --user enable --now erebus-darkness.timer

rm -f "$EREBUS_DIR/current-state"

systemctl --user start erebus-darkness.service

echo
echo "╭─[ E R E B U S ]"
echo "╰─[ INSTALLED ]"
echo
echo "Current theme:"
omarchy theme current

echo
echo "Darkness cycle:"
echo "  00:00 → Abyss"
echo "  06:00 → Dawn"
echo "  09:00 → Day"
echo "  17:00 → Dusk"
echo "  21:00 → Night"
echo
echo "The darkness cycle is now active."
