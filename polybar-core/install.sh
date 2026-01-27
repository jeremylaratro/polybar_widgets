#!/usr/bin/env bash

# Polybar Core Installer
# Installs launch script, health monitor, and systemd timer

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POLYBAR_DIR="${HOME}/.config/polybar"
SYSTEMD_DIR="${HOME}/.config/systemd/user"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

check_deps() {
    if ! command -v polybar &>/dev/null; then
        error "polybar not found. Install it first."
    fi
    if ! command -v xrandr &>/dev/null; then
        error "xrandr not found. Install it first."
    fi
    info "Dependencies OK"
}

install_scripts() {
    mkdir -p "$POLYBAR_DIR"

    cp "$SCRIPT_DIR/launch.sh" "$POLYBAR_DIR/"
    chmod +x "$POLYBAR_DIR/launch.sh"
    info "Installed launch.sh"

    cp "$SCRIPT_DIR/polybar-health.sh" "$POLYBAR_DIR/"
    chmod +x "$POLYBAR_DIR/polybar-health.sh"
    info "Installed polybar-health.sh"
}

install_systemd() {
    mkdir -p "$SYSTEMD_DIR"

    cp "$SCRIPT_DIR/polybar-health.service" "$SYSTEMD_DIR/"
    cp "$SCRIPT_DIR/polybar-health.timer" "$SYSTEMD_DIR/"

    systemctl --user daemon-reload
    info "Installed systemd units"
}

enable_health_timer() {
    read -p "Enable health check timer? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        systemctl --user enable --now polybar-health.timer
        info "Health timer enabled"
    else
        warn "Timer not enabled. Enable later with: systemctl --user enable --now polybar-health.timer"
    fi
}

main() {
    echo "================================"
    echo " Polybar Core Installer"
    echo "================================"
    echo ""

    check_deps
    install_scripts
    install_systemd
    enable_health_timer

    echo ""
    info "Installation complete!"
    echo ""
    echo "Usage:"
    echo "  Launch polybar:  ~/.config/polybar/launch.sh"
    echo "  Check health:    systemctl --user status polybar-health.timer"
    echo ""
    echo "Configuration (env vars):"
    echo "  POLYBAR_TOP_BAR=top1"
    echo "  POLYBAR_BOTTOM_BAR=bottom1"
    echo "  POLYBAR_HEALTH_MAX_FAILURES=2"
    echo "  POLYBAR_BARS_PER_MONITOR=2"
}

main "$@"
