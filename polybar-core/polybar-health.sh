#!/usr/bin/env bash

# Polybar Health Monitor
# Checks polybar process count and monitor changes
# Only restarts if polybar has been dead for multiple consecutive checks

LOG_FILE="/tmp/polybar-health.log"
STATE_FILE="/tmp/polybar-monitors.state"
FAILURE_COUNT_FILE="/tmp/polybar-health-failures"
MAX_FAILURES=${POLYBAR_HEALTH_MAX_FAILURES:-2}
BARS_PER_MONITOR=${POLYBAR_BARS_PER_MONITOR:-2}  # top + bottom
LAUNCH_SCRIPT="${POLYBAR_LAUNCH_SCRIPT:-$HOME/.config/polybar/launch.sh}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

get_current_monitors() {
    DISPLAY="${DISPLAY:-:0}" xrandr --query 2>/dev/null | grep " connected" | cut -d" " -f1 | sort
}

get_saved_monitors() {
    if [ -f "$STATE_FILE" ]; then
        sort "$STATE_FILE"
    fi
}

get_failure_count() {
    if [ -f "$FAILURE_COUNT_FILE" ]; then
        cat "$FAILURE_COUNT_FILE"
    else
        echo 0
    fi
}

set_failure_count() {
    echo "$1" > "$FAILURE_COUNT_FILE"
}

check_health() {
    local current_monitors saved_monitors monitor_count running_count expected_count

    current_monitors=$(get_current_monitors)
    saved_monitors=$(get_saved_monitors)

    if [ -z "$current_monitors" ]; then
        monitor_count=0
    else
        monitor_count=$(echo "$current_monitors" | wc -l)
    fi

    running_count=$(pgrep -u "$(id -u)" -x polybar 2>/dev/null | wc -l)
    expected_count=$((monitor_count * BARS_PER_MONITOR))

    # Check if monitors changed
    if [ "$current_monitors" != "$saved_monitors" ] && [ -n "$saved_monitors" ]; then
        log "Monitor change detected - Current: $(echo $current_monitors | tr '\n' ' ') | Saved: $(echo $saved_monitors | tr '\n' ' ')"
        return 1
    fi

    # Check if polybar count matches expected
    if [ "$running_count" -lt "$expected_count" ]; then
        log "Polybar count low - Running: $running_count, Expected: $expected_count"
        return 1
    fi

    return 0
}

# Main health check with consecutive failure tracking
if ! check_health; then
    failures=$(get_failure_count)
    ((failures++))
    set_failure_count "$failures"

    if [ "$failures" -ge "$MAX_FAILURES" ]; then
        log "Health check FAILED ($failures consecutive failures) - restarting polybar"
        set_failure_count 0
        "$LAUNCH_SCRIPT"
        exit 0
    else
        log "Health check FAILED (failure $failures of $MAX_FAILURES required for restart)"
        exit 0
    fi
fi

# Reset failure counter on success
set_failure_count 0
running=$(pgrep -u "$(id -u)" -x polybar 2>/dev/null | wc -l)
monitor_output=$(get_current_monitors)
if [ -z "$monitor_output" ]; then
    monitors=0
else
    monitors=$(echo "$monitor_output" | wc -l)
fi
log "Health check PASSED - $running bars on $monitors monitor(s)"
