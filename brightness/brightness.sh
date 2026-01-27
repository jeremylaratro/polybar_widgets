#!/usr/bin/env bash
# Polybar brightness module script
# Usage: brightness.sh [up|down|get]

STEP=${BRIGHTNESS_STEP:-5}

case "$1" in
    up)
        brightnessctl set +${STEP}% > /dev/null
        ;;
    down)
        brightnessctl set ${STEP}%- > /dev/null
        ;;
esac

# Output current brightness percentage
brightnessctl -m | cut -d',' -f4 | tr -d '%'
