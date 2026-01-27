#!/usr/bin/env bash
# Network speed module - shows upload/download rates

IFACE=$(ip route | grep default | awk '{print $5}' | head -1)

if [[ -z "$IFACE" ]]; then
    echo "N/A"
    exit 0
fi

RX_FILE="/tmp/polybar-netspeed-rx"
TX_FILE="/tmp/polybar-netspeed-tx"
TIME_FILE="/tmp/polybar-netspeed-time"

rx_now=$(cat /sys/class/net/"$IFACE"/statistics/rx_bytes 2>/dev/null || echo 0)
tx_now=$(cat /sys/class/net/"$IFACE"/statistics/tx_bytes 2>/dev/null || echo 0)
time_now=$(date +%s%N)

if [[ -f "$RX_FILE" && -f "$TX_FILE" && -f "$TIME_FILE" ]]; then
    rx_old=$(cat "$RX_FILE")
    tx_old=$(cat "$TX_FILE")
    time_old=$(cat "$TIME_FILE")

    time_diff=$(( (time_now - time_old) / 1000000000 ))
    [[ $time_diff -eq 0 ]] && time_diff=1

    rx_rate=$(( (rx_now - rx_old) / time_diff ))
    tx_rate=$(( (tx_now - tx_old) / time_diff ))

    # Format rates
    format_rate() {
        local rate=$1
        if [[ $rate -gt 1048576 ]]; then
            echo "$(( rate / 1048576 ))M"
        elif [[ $rate -gt 1024 ]]; then
            echo "$(( rate / 1024 ))K"
        else
            echo "${rate}B"
        fi
    }

    down=$(format_rate $rx_rate)
    up=$(format_rate $tx_rate)

    echo "↓${down} ↑${up}"
else
    echo "..."
fi

echo "$rx_now" > "$RX_FILE"
echo "$tx_now" > "$TX_FILE"
echo "$time_now" > "$TIME_FILE"
