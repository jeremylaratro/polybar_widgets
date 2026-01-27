#!/usr/bin/env bash
# Caffeine module - toggle screen timeout prevention
# Click to toggle, shows status when active

STATE_FILE="/tmp/polybar-caffeine-state"

toggle() {
    if [[ -f "$STATE_FILE" ]]; then
        # Disable caffeine - restore saved timeout
        saved_timeout=$(cat "$STATE_FILE")
        xset s "$saved_timeout" "$saved_timeout"
        xset dpms "$saved_timeout" "$saved_timeout" "$saved_timeout"
        rm -f "$STATE_FILE"
    else
        # Enable caffeine - save current timeout and disable
        current=$(xset q | grep "timeout:" | awk '{print $2}')
        echo "$current" > "$STATE_FILE"
        xset s off
        xset -dpms
    fi
}

status() {
    if [[ -f "$STATE_FILE" ]]; then
        echo "ON"
    else
        echo "OFF"
    fi
}

case "$1" in
    toggle) toggle ;;
    *) status ;;
esac
