# Polybar Widgets

A collection of custom polybar modules for system monitoring and control.

## Screenshots

### VPN
![VPN](screenshots/vpn.png)

### Uptime
![Uptime](screenshots/uptime.png)

### Docker
![Docker](screenshots/docker.png)

### Updates
![Updates](screenshots/updates.png)

### IDS
![IDS](screenshots/ids.png)

### Brightness
![Brightness](screenshots/brightness.png)

### Audio Mute
![Muted](screenshots/muted.png)

### Webcam
![Webcam](screenshots/webcam.png)

### Microphone
![Mic](screenshots/mic.png)

### Pomodoro
![Pomodoro](screenshots/pomodoro.png)

### Network Speed
![Network Speed](screenshots/netspeed.png)

### Public IP
![Public IP](screenshots/public-ip.png)

## Widgets

| Widget | Description |
|--------|-------------|
| **polybar-core** | Multi-monitor launch script + health monitoring |
| **brightness** | Screen brightness with scroll control |
| **caffeine** | Prevent screen timeout |
| **docker** | Docker container count |
| **netspeed** | Real-time network speed |
| **public-ip** | Public IP with caching |
| **uptime** | System uptime |
| **updates** | Available package updates (Fedora/dnf) |
| **vpn** | VPN connection status |
| **bluetooth** | Bluetooth status + device name |
| **mullvad** | Mullvad VPN status |
| **ids** | Suricata IDS alert counts |
| **screen-timeout** | DPMS control with GUI |
| **flameshot** | Screenshot tool |

## Quick Install

```bash
git clone https://github.com/jeremylaratro/polybar_widgets.git
cd polybar_widgets
./install.sh
```

The interactive installer lets you choose which widgets to install.

## Manual Install

Each widget folder contains:
- `*.sh` - The script(s) to copy to `~/.config/polybar/scripts/`
- `module.ini` - Config snippet to add to your polybar config
- `README.md` - Widget-specific documentation

Example:
```bash
# Install brightness widget
cp brightness/brightness.sh ~/.config/polybar/scripts/
chmod +x ~/.config/polybar/scripts/brightness.sh

# Add module to config.ini (see brightness/module.ini)
```

## Requirements

- polybar
- Nerd Font (for icons)
- Widget-specific deps (see individual READMEs)

## Theme

These widgets use the "Otto" color scheme by default:

```ini
[colors]
background = #2c3746
foreground = #ffffff
blue = #176ef1
red = #fd3762
teal = #2aacaa
yellow = #f7c067
orange = #f77067
purple = #cb75f7
cyan = #5cc6d1
gray = #9cacad
```

## License

MIT
