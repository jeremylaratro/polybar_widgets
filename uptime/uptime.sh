#!/usr/bin/env bash
# Uptime module - shows system uptime in compact format

uptime_seconds=$(cut -d. -f1 /proc/uptime)

days=$((uptime_seconds / 86400))
hours=$(((uptime_seconds % 86400) / 3600))
mins=$(((uptime_seconds % 3600) / 60))

if [[ $days -gt 0 ]]; then
    echo "${days}d ${hours}h"
elif [[ $hours -gt 0 ]]; then
    echo "${hours}h ${mins}m"
else
    echo "${mins}m"
fi
