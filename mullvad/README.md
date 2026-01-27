# Mullvad VPN

Show Mullvad VPN connection status and location.

## Features

- Shows connection status with server location
- Color-coded: connected (blue), connecting (yellow), off (gray)
- Left-click: connect
- Right-click: disconnect

## Requirements

- `mullvad` CLI (Mullvad VPN client)

## Configuration

```bash
export MULLVAD_CONNECTED_COLOR="#176ef1"
export MULLVAD_CONNECTING_COLOR="#f7c067"
export MULLVAD_OFF_COLOR="#9cacad"
```
