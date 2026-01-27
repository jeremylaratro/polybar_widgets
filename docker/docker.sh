#!/usr/bin/env bash
# Docker container count module

if ! command -v docker &>/dev/null; then
    echo "N/A"
    exit 0
fi

# Check if docker daemon is running
if ! docker info &>/dev/null 2>&1; then
    echo "OFF"
    exit 0
fi

running=$(docker ps -q 2>/dev/null | wc -l)
total=$(docker ps -aq 2>/dev/null | wc -l)

if [[ $running -eq 0 ]]; then
    echo "0"
else
    echo "$running/$total"
fi
