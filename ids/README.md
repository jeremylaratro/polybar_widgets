# IDS (Suricata)

Show Suricata IDS status with color-coded alert counts.

## Features

- Shows alert counts by severity (high/medium/low)
- Color-coded: red=high, orange=medium, yellow=low
- Time-windowed alerts (configurable retention)
- Left-click: open GUI (if configured)
- Right-click: toggle service on/off
- Middle-click: quick status notification

## Requirements

- Suricata IDS
- Read access to `/var/log/suricata/eve.json`

## Configuration

```bash
# Service name (default: suricata, also tries suricata-laptop)
export IDS_SERVICE_NAME="suricata"

# Optional GUI path
export IDS_GUI_PATH="/path/to/ids-gui.py"

# Colors
export IDS_ICON_COLOR="#176ef1"
export IDS_HIGH_COLOR="#fd3762"
export IDS_MEDIUM_COLOR="#f77067"
export IDS_LOW_COLOR="#f7c067"
export IDS_OK_COLOR="#2aacaa"
export IDS_OFF_COLOR="#9cacad"
```

## Alert retention

Create `~/.config/ids-suite/settings.conf`:
```
retention_minutes=120
```
