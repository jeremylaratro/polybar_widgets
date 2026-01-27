#!/usr/bin/env bash

# Polybar Multi-Monitor Launch Script
# Launches polybar on all connected monitors with health monitoring

LOG_FILE="/tmp/polybar-launch.log"
STATE_FILE="/tmp/polybar-monitors.state"

# Bar names to launch (customize these)
TOP_BAR="${POLYBAR_TOP_BAR:-top1}"
BOTTOM_BAR="${POLYBAR_BOTTOM_BAR:-bottom1}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Terminate already running bar instances
killall -q polybar
log "Killed existing polybar instances"

# Wait until the processes have been shut down
timeout=10
while pgrep -u $UID -x polybar >/dev/null && [ $timeout -gt 0 ]; do
    sleep 0.5
    ((timeout--))
done

if pgrep -u $UID -x polybar >/dev/null; then
    log "WARNING: Could not kill all polybar instances, forcing..."
    killall -9 polybar 2>/dev/null
    sleep 1
fi

# Get connected monitors
get_monitors() {
    if type "xrandr" > /dev/null 2>&1; then
        xrandr --query | grep " connected" | cut -d" " -f1
    fi
}

MONITORS=$(get_monitors)
MONITOR_COUNT=$(echo "$MONITORS" | wc -l)

log "Detected $MONITOR_COUNT monitor(s): $(echo $MONITORS | tr '\n' ' ')"

# Save current monitor state for health checks
echo "$MONITORS" > "$STATE_FILE"

# Launch polybar on all monitors
if [ -n "$MONITORS" ]; then
    for m in $MONITORS; do
        log "Launching bars on monitor: $m"
        MONITOR=$m polybar --reload "$TOP_BAR" 2>> "$LOG_FILE" &
        MONITOR=$m polybar --reload "$BOTTOM_BAR" 2>> "$LOG_FILE" &
    done
else
    log "No monitors detected via xrandr, launching on default"
    polybar --reload "$TOP_BAR" 2>> "$LOG_FILE" &
    polybar --reload "$BOTTOM_BAR" 2>> "$LOG_FILE" &
fi

# Wait briefly and verify launch
sleep 2
RUNNING=$(pgrep -u $UID -x polybar | wc -l)
EXPECTED=$((MONITOR_COUNT * 2))

if [ "$RUNNING" -eq "$EXPECTED" ]; then
    log "SUCCESS: Launched $RUNNING polybar instances (expected $EXPECTED)"
else
    log "WARNING: Running $RUNNING polybar instances (expected $EXPECTED)"
fi

echo "Polybar launched on $MONITOR_COUNT monitor(s)..."
