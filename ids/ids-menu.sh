#!/usr/bin/env bash
# IDS Polybar Click Handler
# Left-click: Open GUI
# Right-click: Quick toggle start/stop
# Middle-click: Show quick status

GUI_PATH="${IDS_GUI_PATH:-}"
SERVICE_NAME="${IDS_SERVICE_NAME:-suricata}"
EVE_FILE="/var/log/suricata/eve.json"

# Try common service names
get_service() {
    for svc in "$SERVICE_NAME" "${SERVICE_NAME}-laptop" "suricata" "suricata-laptop"; do
        if systemctl list-unit-files "$svc.service" &>/dev/null; then
            echo "$svc"
            return
        fi
    done
    echo "suricata"
}

SVC=$(get_service)

case "$1" in
    left)
        if [ -n "$GUI_PATH" ] && [ -f "$GUI_PATH" ]; then
            python3 "$GUI_PATH" &
        else
            notify-send "IDS" "No GUI configured. Set IDS_GUI_PATH" -i security-low
        fi
        ;;
    right)
        if systemctl is-active --quiet "$SVC"; then
            pkexec systemctl stop "$SVC"
            notify-send "Suricata IDS" "Stopped" -i security-low
        else
            pkexec systemctl start "$SVC"
            notify-send "Suricata IDS" "Started" -i security-high
        fi
        ;;
    middle)
        if systemctl is-active --quiet "$SVC"; then
            if [ -f "$EVE_FILE" ]; then
                ALERTS=$(tail -200 "$EVE_FILE" 2>/dev/null | grep -c '"event_type":"alert"')
                HTTP=$(tail -200 "$EVE_FILE" 2>/dev/null | grep -c '"event_type":"http"')
                DNS=$(tail -200 "$EVE_FILE" 2>/dev/null | grep -c '"event_type":"dns"')
                notify-send "Suricata IDS Status" "Running\nAlerts: $ALERTS\nHTTP: $HTTP\nDNS: $DNS" -i security-high
            else
                notify-send "Suricata IDS" "Running (no logs yet)" -i security-high
            fi
        else
            notify-send "Suricata IDS" "Not Running" -i security-low
        fi
        ;;
    *)
        if [ -n "$GUI_PATH" ] && [ -f "$GUI_PATH" ]; then
            python3 "$GUI_PATH" &
        fi
        ;;
esac
