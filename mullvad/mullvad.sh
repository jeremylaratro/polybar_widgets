#!/usr/bin/env bash
# Polybar Mullvad VPN Module

# Colors (customize these)
CONNECTED_COLOR="${MULLVAD_CONNECTED_COLOR:-#176ef1}"
CONNECTING_COLOR="${MULLVAD_CONNECTING_COLOR:-#f7c067}"
OFF_COLOR="${MULLVAD_OFF_COLOR:-#9cacad}"

STATUS=$(mullvad status 2>/dev/null)

if echo "$STATUS" | grep -q "^Connected"; then
    # Extract server location (city/country)
    LOCATION=$(echo "$STATUS" | grep -oP 'to \K[^.]+' | head -1)
    echo "%{F$CONNECTED_COLOR}󰦝%{F-} ${LOCATION}"
elif echo "$STATUS" | grep -q "Connecting"; then
    echo "%{F$CONNECTING_COLOR}󰦝%{F-} ..."
else
    echo "%{F$OFF_COLOR}󰦜%{F-} VPN"
fi
