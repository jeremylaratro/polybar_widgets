# Polybar Core

Multi-monitor launch script and health monitoring for polybar.

## Features

### launch.sh
- Detects all connected monitors via xrandr
- Launches top and bottom bars on each monitor
- Saves monitor state for health checking
- Logging to `/tmp/polybar-launch.log`

### polybar-health.sh
- Monitors polybar process count
- Detects monitor hotplug changes
- Requires consecutive failures before restart (prevents flapping)
- Automatic restart via systemd timer

## Installation

```bash
./install.sh
```

This installs:
- `~/.config/polybar/launch.sh`
- `~/.config/polybar/polybar-health.sh`
- Systemd timer for health monitoring

## Configuration

Environment variables:
```bash
# Bar names (must match your config.ini)
export POLYBAR_TOP_BAR="top1"
export POLYBAR_BOTTOM_BAR="bottom1"

# Health check settings
export POLYBAR_HEALTH_MAX_FAILURES=2  # consecutive failures before restart
export POLYBAR_BARS_PER_MONITOR=2     # number of bars per monitor
```

## Systemd commands

```bash
# Check timer status
systemctl --user status polybar-health.timer

# View health logs
journalctl --user -u polybar-health.service -f

# Disable health monitoring
systemctl --user disable --now polybar-health.timer
```

## i3/Hyprland integration

Add to your config:
```
exec_always --no-startup-id ~/.config/polybar/launch.sh
```
