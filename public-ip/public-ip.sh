#!/usr/bin/env bash
# Public IP module with caching

CACHE_FILE="/tmp/polybar-public-ip"
CACHE_AGE=${PUBLIC_IP_CACHE_AGE:-300}  # 5 minutes default

# Check cache
if [[ -f "$CACHE_FILE" ]]; then
    age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
    if [[ $age -lt $CACHE_AGE ]]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Fetch public IP
ip=$(curl -s --max-time 3 ifconfig.me 2>/dev/null || curl -s --max-time 3 icanhazip.com 2>/dev/null)

if [[ -n "$ip" && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "$ip" > "$CACHE_FILE"
    echo "$ip"
else
    [[ -f "$CACHE_FILE" ]] && cat "$CACHE_FILE" || echo "N/A"
fi
