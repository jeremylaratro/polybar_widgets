#!/usr/bin/env bash
# VPN status module - checks for active VPN connections

# Check for common VPN interfaces
vpn_interfaces="tun0 tun1 wg0 wg1 vpn0 ppp0"

for iface in $vpn_interfaces; do
    if ip link show "$iface" &>/dev/null 2>&1; then
        # Get VPN name from NetworkManager if available
        vpn_name=$(nmcli -t -f NAME,TYPE con show --active 2>/dev/null | grep -E "vpn|wireguard" | cut -d: -f1 | head -1)
        if [[ -n "$vpn_name" ]]; then
            echo "$vpn_name"
        else
            echo "$iface"
        fi
        exit 0
    fi
done

# Check NetworkManager for active VPN
vpn_active=$(nmcli -t -f TYPE con show --active 2>/dev/null | grep -E "vpn|wireguard")
if [[ -n "$vpn_active" ]]; then
    vpn_name=$(nmcli -t -f NAME,TYPE con show --active 2>/dev/null | grep -E "vpn|wireguard" | cut -d: -f1 | head -1)
    echo "$vpn_name"
    exit 0
fi

echo "OFF"
