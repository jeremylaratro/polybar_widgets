#!/usr/bin/env bash
# System updates module for Fedora (dnf)

CACHE_FILE="/tmp/polybar-updates-cache"
CACHE_AGE=${UPDATES_CACHE_AGE:-3600}  # 1 hour default

# Check cache
if [[ -f "$CACHE_FILE" ]]; then
    age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE")))
    if [[ $age -lt $CACHE_AGE ]]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Check for updates
count=$(dnf check-update -q 2>/dev/null | grep -c "^\S")

if [[ $count -gt 0 ]]; then
    echo "$count" > "$CACHE_FILE"
    echo "$count"
else
    echo "0" > "$CACHE_FILE"
    echo "0"
fi
