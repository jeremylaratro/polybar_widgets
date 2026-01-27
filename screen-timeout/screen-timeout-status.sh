#!/usr/bin/env bash
# Polybar module script - displays current DPMS timeout status

dpms_info=$(xset q 2>/dev/null | grep -A5 "DPMS")

if echo "$dpms_info" | grep -q "DPMS is Disabled"; then
    echo "OFF"
else
    # Get the "Off:" value (when screen turns off)
    timeout=$(echo "$dpms_info" | grep "Standby:" | awk '{print $6}')
    if [ -z "$timeout" ] || [ "$timeout" = "0" ]; then
        echo "OFF"
    else
        mins=$((timeout / 60))
        if [ $mins -ge 60 ]; then
            hours=$((mins / 60))
            echo "${hours}h"
        else
            echo "${mins}m"
        fi
    fi
fi
