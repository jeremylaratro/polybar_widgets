# Updates

Show available system updates count (Fedora/dnf).

## Features

- Shows pending update count
- 1-hour cache to avoid slow dnf checks
- Click to open terminal and run upgrade

## Adapting for other distros

Replace the dnf command in updates.sh:

**Arch (pacman):**
```bash
count=$(checkupdates 2>/dev/null | wc -l)
```

**Debian/Ubuntu (apt):**
```bash
count=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
```
