#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/huntserb-afk/erebus-omarchy-theme.git"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "╭─[ E R E B U S ]"
echo "╰─[ ONE-COMMAND INSTALLER ]"
echo

echo "[1/6] Downloading Erebus..."
git clone --depth 1 --branch main "$REPO_URL" "$TMP_DIR/repo"

REPO_DIR="$TMP_DIR/repo"
OMARCHY_THEMES="$HOME/.config/omarchy/themes"
EREBUS_DIR="$HOME/.config/omarchy/erebus"
SYSTEMD_DIR="$HOME/.config/systemd/user"

echo "[2/6] Creating directories..."
mkdir -p "$OMARCHY_THEMES"
mkdir -p "$EREBUS_DIR/wallpapers"
mkdir -p "$SYSTEMD_DIR"

echo "[3/6] Installing themes..."
for theme in dawn day dusk night abyss; do
    rm -rf "$OMARCHY_THEMES/erebus-$theme"
    cp -a "$REPO_DIR/themes/erebus-$theme" "$OMARCHY_THEMES/"
done

echo "[4/6] Installing wallpapers..."
cp -f "$REPO_DIR/wallpapers/"*.jpg "$EREBUS_DIR/wallpapers/"

echo "[5/6] Installing darkness cycle..."
cp -f "$REPO_DIR/darkness/darkness.sh" "$EREBUS_DIR/darkness.sh"
chmod +x "$EREBUS_DIR/darkness.sh"

cp -f "$REPO_DIR/darkness/erebus-darkness.service" "$SYSTEMD_DIR/"
cp -f "$REPO_DIR/darkness/erebus-darkness.timer" "$SYSTEMD_DIR/"

echo "[6/6] Enabling Erebus..."
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
