# Screen Timeout

Display and configure screen timeout/DPMS settings with a GUI.

## Features

- Shows current timeout (e.g., "10m", "1h", "OFF")
- Click to open GUI with preset buttons
- Auto-applies settings immediately
- Saves config to restore on login

## Requirements

- `xset` (X11)
- Python 3 with tkinter

## Files

- `screen-timeout-status.sh` - Polybar status script
- `screen-timeout-gui.py` - GUI configuration tool

## Restore on login

Add to your startup:
```bash
~/.config/polybar/scripts/screen-timeout-gui.py --apply
```
