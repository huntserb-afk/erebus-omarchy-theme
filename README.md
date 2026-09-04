# Erebus — Omarchy Theme

A dark Greek-mythology-inspired theme system for Omarchy Linux, based on Erebus, the primordial personification of darkness.

Erebus changes throughout the day using systemd timers:

- Dawn — 06:00
- Day — 09:00
- Dusk — 17:00
- Night — 21:00

Each state has its own colors, Hyprland configuration, terminal configuration, and wallpaper.

## Structure

```text
themes/
├── erebus-dawn/
├── erebus-day/
├── erebus-dusk/
└── erebus-night/

wallpapers/
├── EREBUS-DAWN.jpg
├── EREBUS-DAY.jpg
├── EREBUS-DUSK.jpg
└── EREBUS-NIGHT.jpg

darkness/
├── darkness.sh
├── erebus-darkness.service
└── erebus-darkness.timer
