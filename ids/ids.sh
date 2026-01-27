#!/usr/bin/env bash
# Polybar IDS Status Module
# Shows Suricata IDS status with alert counts by severity

EVE_FILE="/var/log/suricata/eve.json"
EVE_DIR="/var/log/suricata"
CONFIG_FILE="$HOME/.config/ids-suite/settings.conf"
SERVICE_NAME="${IDS_SERVICE_NAME:-suricata}"

# Colors
COLOR_ICON="${IDS_ICON_COLOR:-#176ef1}"
COLOR_HIGH="${IDS_HIGH_COLOR:-#fd3762}"
COLOR_MEDIUM="${IDS_MEDIUM_COLOR:-#f77067}"
COLOR_LOW="${IDS_LOW_COLOR:-#f7c067}"
COLOR_OK="${IDS_OK_COLOR:-#2aacaa}"
COLOR_OFF="${IDS_OFF_COLOR:-#9cacad}"

# Read retention minutes from shared config (default 120 minutes)
if [ -f "$CONFIG_FILE" ]; then
    RETENTION_MINUTES=$(grep -E "^retention_minutes=" "$CONFIG_FILE" 2>/dev/null | cut -d= -f2 | tr -d '[:space:]')
fi
RETENTION_MINUTES=${RETENTION_MINUTES:-120}

# Find active EVE log file (handles log rotation)
find_active_eve() {
    if [ -f "$EVE_FILE" ] && [ -s "$EVE_FILE" ]; then
        echo "$EVE_FILE"
        return
    fi
    local latest=$(ls -t "$EVE_DIR"/eve.json-* 2>/dev/null | grep -v '\.gz$' | head -1)
    if [ -n "$latest" ] && [ -s "$latest" ]; then
        echo "$latest"
        return
    fi
    echo "$EVE_FILE"
}

ACTIVE_EVE=$(find_active_eve)

# Check if Suricata is running
if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null || \
   systemctl is-active --quiet "${SERVICE_NAME}-laptop" 2>/dev/null; then

    if [ -f "$ACTIVE_EVE" ] && [ -r "$ACTIVE_EVE" ]; then
        CUTOFF=$(date -d "${RETENTION_MINUTES} minutes ago" +%Y-%m-%dT%H:%M:%S 2>/dev/null)

        if [ -n "$CUTOFF" ]; then
            ALERTS=$(tail -10000 "$ACTIVE_EVE" 2>/dev/null | \
                grep '"event_type":"alert"' | \
                awk -v cutoff="$CUTOFF" -F'"timestamp":"' '{
                    if (NF > 1) {
                        split($2, a, "\"");
                        ts = substr(a[1], 1, 19);
                        if (ts >= cutoff) print $0
                    }
                }')
        else
            ALERTS=$(tail -500 "$ACTIVE_EVE" 2>/dev/null | grep '"event_type":"alert"')
        fi

        if [ -n "$ALERTS" ]; then
            HIGH=$(echo "$ALERTS" | grep -c '"severity":1' 2>/dev/null)
            MEDIUM=$(echo "$ALERTS" | grep -c '"severity":2' 2>/dev/null)
            LOW=$(echo "$ALERTS" | grep -c '"severity":3' 2>/dev/null)
        else
            HIGH=0; MEDIUM=0; LOW=0
        fi

        HIGH=${HIGH:-0}; MEDIUM=${MEDIUM:-0}; LOW=${LOW:-0}
        TOTAL=$((HIGH + MEDIUM + LOW))

        if [ "$TOTAL" -gt 0 ]; then
            OUTPUT=""
            [ "$HIGH" -gt 0 ] && OUTPUT="%{F$COLOR_HIGH}${HIGH}%{F-}"
            if [ "$MEDIUM" -gt 0 ]; then
                [ -n "$OUTPUT" ] && OUTPUT="${OUTPUT}/"
                OUTPUT="${OUTPUT}%{F$COLOR_MEDIUM}${MEDIUM}%{F-}"
            fi
            if [ "$LOW" -gt 0 ]; then
                [ -n "$OUTPUT" ] && OUTPUT="${OUTPUT}/"
                OUTPUT="${OUTPUT}%{F$COLOR_LOW}${LOW}%{F-}"
            fi
            echo "%{F$COLOR_ICON}󰒃%{F-} IDS ${OUTPUT}"
        else
            echo "%{F$COLOR_ICON}󰒃%{F-} IDS %{F$COLOR_OK}0%{F-}"
        fi
    else
        echo "%{F$COLOR_ICON}󰒃%{F-} IDS %{F$COLOR_OK}0%{F-}"
    fi
else
    echo "%{F$COLOR_OFF}󰒄%{F-} IDS"
fi
