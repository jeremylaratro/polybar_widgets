#!/usr/bin/env bash
# Bluetooth status module with device name

# Colors (customize these)
CONNECTED_COLOR="${BLUETOOTH_CONNECTED_COLOR:-#cb75f7}"
ON_COLOR="${BLUETOOTH_ON_COLOR:-#cb75f7}"
OFF_COLOR="${BLUETOOTH_OFF_COLOR:-#9cacad}"

# Check if bluetooth is powered on
if bluetoothctl show | grep -q "Powered: yes"; then
    # Check if any device is connected
    if bluetoothctl info 2>/dev/null | grep -q "Connected: yes"; then
        # Get connected device name
        device=$(bluetoothctl info | grep "Name:" | cut -d' ' -f2-)
        echo "%{F$CONNECTED_COLOR}󰂱%{F-} $device"
    else
        echo "%{F$ON_COLOR}󰂯%{F-}"
    fi
else
    echo "%{F$OFF_COLOR}󰂲%{F-}"
fi
