#!/usr/bin/env bash

# Polybar Flameshot Module Installer

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.config/polybar/scripts"
CONFIG_FILE="${HOME}/.config/polybar/config.ini"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# Check dependencies
check_deps() {
    if ! command -v flameshot &>/dev/null; then
        error "flameshot not found. Install it first: sudo dnf install flameshot"
    fi

    if ! command -v polybar &>/dev/null; then
        error "polybar not found. Install it first."
    fi

    info "Dependencies OK"
}

# Install script
install_script() {
    mkdir -p "$INSTALL_DIR"
    cp "$SCRIPT_DIR/flameshot.sh" "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/flameshot.sh"
    info "Script installed to $INSTALL_DIR/flameshot.sh"
}

# Show module config
show_config() {
    echo ""
    warn "Add this module to your polybar config.ini:"
    echo ""
    cat "$SCRIPT_DIR/module.ini"
    echo ""
    warn "Then add 'flameshot' to your bar's modules-right (or modules-left):"
    echo "  modules-right = ... flameshot ..."
    echo ""
}

# Main
main() {
    echo "================================"
    echo " Polybar Flameshot Module"
    echo "================================"
    echo ""

    check_deps
    install_script
    show_config

    info "Installation complete!"
    echo ""
    echo "Actions:"
    echo "  Left-click:   Region capture (GUI)"
    echo "  Right-click:  Full screen capture"
    echo "  Middle-click: 3-second delayed capture"
    echo ""
    echo "Reload polybar: polybar-msg cmd restart"
}

main "$@"
