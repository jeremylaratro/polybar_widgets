# Bluetooth

Show Bluetooth status and connected device.

## Features

- Different icons for: off, on, connected
- Shows connected device name
- Left-click: open Blueman manager
- Right-click: toggle power on/off

## Requirements

- `bluetoothctl` (bluez)
- `blueman` (optional, for manager GUI)

## Configuration

Customize colors via environment:
```bash
export BLUETOOTH_CONNECTED_COLOR="#cb75f7"
export BLUETOOTH_ON_COLOR="#cb75f7"
export BLUETOOTH_OFF_COLOR="#9cacad"
```
