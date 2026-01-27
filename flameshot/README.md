# Polybar Flameshot Module

A simple polybar module for taking screenshots with Flameshot.

## Features

- **Left-click**: Region capture with annotation GUI
- **Right-click**: Full screen capture (saved automatically)
- **Middle-click**: 3-second delayed capture

## Requirements

- polybar
- flameshot
- Nerd Font (for the camera icon)

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/i3_utils.git
cd i3_utils/polybar-flameshot
./install.sh
```

Then manually add the module config to your `~/.config/polybar/config.ini`:

```ini
[module/flameshot]
type = custom/text
label = 󰹑
label-foreground = ${colors.cyan}
label-padding = 1
click-left = ~/.config/polybar/scripts/flameshot.sh &
click-right = ~/.config/polybar/scripts/flameshot.sh full &
click-middle = ~/.config/polybar/scripts/flameshot.sh delay &
```

Add `flameshot` to your bar's module list:

```ini
modules-right = ... flameshot ...
```

Reload polybar:

```bash
polybar-msg cmd restart
```

## Configuration

Set a custom screenshot directory:

```bash
export SCREENSHOT_DIR="$HOME/Screenshots"
```

## License

MIT
