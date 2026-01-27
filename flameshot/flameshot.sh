#!/usr/bin/env bash

# Flameshot polybar module
# Left-click: region capture (GUI)
# Right-click: full screen capture
# Middle-click: delayed capture (3s)

SCREENSHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"

# Ensure screenshot directory exists
mkdir -p "$SCREENSHOT_DIR"

case "$1" in
    full)
        flameshot full -p "$SCREENSHOT_DIR"
        ;;
    delay)
        flameshot gui -d 3000
        ;;
    *)
        # Default: region capture GUI
        flameshot gui
        ;;
esac
