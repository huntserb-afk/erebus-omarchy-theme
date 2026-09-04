#!/usr/bin/env bash
set -Eeuo pipefail

REPO="huntserb-afk/erebus-omarchy-theme"
BRANCH="main"
ARCHIVE_URL="https://codeload.github.com/${REPO}/tar.gz/refs/heads/${BRANCH}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "╭─[ E R E B U S ]"
echo "╰─[ ONE-COMMAND INSTALLER ]"
echo

echo "[1/7] Checking requirements..."

for cmd in bash curl tar omarchy systemctl; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "ERROR: Required command not found: $cmd"
        exit 1
    }
done

[[ -d "$HOME/.config/omarchy" ]] || {
    echo "ERROR: Omarchy configuration directory not found."
    exit 1
}

echo "Requirements: OK"
echo

echo "[2/7] Downloading Erebus..."

ARCHIVE="$TMP_DIR/erebus.tar.gz"

curl -fL --retry 3 --connect-timeout 10 \
    "$ARCHIVE_URL" -o "$ARCHIVE"

echo "Download: OK"
echo

echo "[3/7] Extracting Erebus..."

tar -xzf "$ARCHIVE" -C "$TMP_DIR"

REPO_DIR="$TMP_DIR/erebus-omarchy-theme-$BRANCH"

[[ -d "$REPO_DIR" ]] || {
    echo "ERROR: Invalid Erebus archive."
    exit 1
}

for state in dawn day dusk night; do
    [[ -d "$REPO_DIR/themes/erebus-$state" ]] || {
        echo "ERROR: Missing theme: erebus-$state"
        exit 1
    }
done

for file in \
    "$REPO_DIR/darkness/darkness.sh" \
    "$REPO_DIR/darkness/erebus-darkness.service" \
    "$REPO_DIR/darkness/erebus-darkness.timer"
do
    [[ -f "$file" ]] || {
        echo "ERROR: Missing required file: $file"
        exit 1
    }
done

echo "Archive validation: OK"
echo

echo "[4/7] Preparing installation..."

OMARCHY_THEMES="$HOME/.config/omarchy/themes"
EREBUS_DIR="$HOME/.config/omarchy/erebus"
SYSTEMD_DIR="$HOME/.config/systemd/user"
STAGE="$TMP_DIR/stage"

mkdir -p "$STAGE/themes" "$STAGE/wallpapers" "$STAGE/systemd"

for state in dawn day dusk night; do
    cp -a "$REPO_DIR/themes/erebus-$state" "$STAGE/themes/"
done

cp -f "$REPO_DIR/wallpapers/"*.jpg "$STAGE/wallpapers/"
cp -f "$REPO_DIR/darkness/darkness.sh" "$STAGE/darkness.sh"
cp -f "$REPO_DIR/darkness/erebus-darkness.service" "$STAGE/systemd/"
cp -f "$REPO_DIR/darkness/erebus-darkness.timer" "$STAGE/systemd/"

chmod +x "$STAGE/darkness.sh"
bash -n "$STAGE/darkness.sh"

echo "Installation files: OK"
echo

echo "[5/7] Installing themes and wallpapers..."

mkdir -p "$OMARCHY_THEMES" "$EREBUS_DIR/wallpapers" "$SYSTEMD_DIR"

for state in dawn day dusk night; do
    rm -rf "$OMARCHY_THEMES/erebus-$state"
    cp -a "$STAGE/themes/erebus-$state" "$OMARCHY_THEMES/"
done

cp -f "$STAGE/wallpapers/"*.jpg "$EREBUS_DIR/wallpapers/"
cp -f "$STAGE/darkness.sh" "$EREBUS_DIR/darkness.sh"
cp -f "$STAGE/systemd/erebus-darkness.service" "$SYSTEMD_DIR/"
cp -f "$STAGE/systemd/erebus-darkness.timer" "$SYSTEMD_DIR/"

echo "Files installed: OK"
echo

echo "[6/7] Enabling darkness cycle..."

systemctl --user daemon-reload
systemctl --user enable --now erebus-darkness.timer

rm -f "$EREBUS_DIR/current-state"
systemctl --user start erebus-darkness.service

systemctl --user is-active --quiet erebus-darkness.timer || {
    echo "ERROR: Erebus timer failed to start."
    exit 1
}

echo "Darkness cycle: ACTIVE"
echo

echo "[7/7] Verifying installation..."

for state in dawn day dusk night; do
    test -f "$OMARCHY_THEMES/erebus-$state/colors.toml"
    test -f "$OMARCHY_THEMES/erebus-$state/hyprland.conf"
    test -f "$OMARCHY_THEMES/erebus-$state/alacritty.toml"
    test -f "$OMARCHY_THEMES/erebus-$state/backgrounds/EREBUS.jpg"
done

test -x "$EREBUS_DIR/darkness.sh"
test -f "$SYSTEMD_DIR/erebus-darkness.service"
test -f "$SYSTEMD_DIR/erebus-darkness.timer"

echo "Verification: PASSED"
echo

echo "╭─[ E R E B U S ]"
echo "╰─[ INSTALLED ]"
echo
echo "Current theme:"
omarchy theme current
echo
echo "Darkness cycle:"
echo "  06:00 → Dawn"
echo "  09:00 → Day"
echo "  17:00 → Dusk"
echo "  21:00 → Night"
echo "  00:00–05:59 → Night"
echo
echo "The darkness cycle is now active."
