#!/usr/bin/env bash

# Polybar Widgets - Main Installer
# Interactive installer for all polybar widgets

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.config/polybar/scripts"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
header() { echo -e "${BLUE}==>${NC} $1"; }

# Available widgets
WIDGETS=(
    "polybar-core:Core scripts (launch, health monitor)"
    "brightness:Screen brightness control"
    "caffeine:Prevent screen timeout"
    "docker:Docker container status"
    "netspeed:Network speed monitor"
    "public-ip:Public IP display"
    "uptime:System uptime"
    "updates:Available system updates (Fedora)"
    "vpn:VPN connection status"
    "bluetooth:Bluetooth status and control"
    "mullvad:Mullvad VPN status"
    "ids:Suricata IDS status"
    "screen-timeout:DPMS timeout control with GUI"
    "flameshot:Screenshot tool"
)

print_menu() {
    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║         Polybar Widgets Installer          ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""
    echo "Available widgets:"
    echo ""
    local i=1
    for widget in "${WIDGETS[@]}"; do
        name="${widget%%:*}"
        desc="${widget#*:}"
        printf "  %2d) %-15s %s\n" "$i" "$name" "$desc"
        ((i++))
    done
    echo ""
    echo "  a) Install ALL widgets"
    echo "  q) Quit"
    echo ""
}

install_widget() {
    local name="$1"
    local widget_dir="$SCRIPT_DIR/$name"

    if [ ! -d "$widget_dir" ]; then
        warn "Widget '$name' not found"
        return 1
    fi

    header "Installing $name"

    # Special handling for polybar-core
    if [ "$name" = "polybar-core" ]; then
        if [ -f "$widget_dir/install.sh" ]; then
            bash "$widget_dir/install.sh"
        fi
        return 0
    fi

    mkdir -p "$INSTALL_DIR"

    # Copy all shell scripts
    for script in "$widget_dir"/*.sh; do
        if [ -f "$script" ]; then
            cp "$script" "$INSTALL_DIR/"
            chmod +x "$INSTALL_DIR/$(basename "$script")"
            info "Installed $(basename "$script")"
        fi
    done

    # Copy Python scripts
    for script in "$widget_dir"/*.py; do
        if [ -f "$script" ]; then
            cp "$script" "$INSTALL_DIR/"
            chmod +x "$INSTALL_DIR/$(basename "$script")"
            info "Installed $(basename "$script")"
        fi
    done

    # Show module config
    if [ -f "$widget_dir/module.ini" ]; then
        echo ""
        warn "Add to your polybar config.ini:"
        cat "$widget_dir/module.ini"
        echo ""
    fi
}

install_all() {
    header "Installing all widgets"
    mkdir -p "$INSTALL_DIR"

    for widget in "${WIDGETS[@]}"; do
        name="${widget%%:*}"
        install_widget "$name"
        echo ""
    done

    info "All widgets installed to $INSTALL_DIR"
    echo ""
    warn "Don't forget to add module definitions to your polybar config.ini"
    warn "See each widget's module.ini for the config snippet"
}

main() {
    # Check dependencies
    if ! command -v polybar &>/dev/null; then
        warn "polybar not found - install it first"
    fi

    while true; do
        print_menu
        read -p "Select widget(s) to install (e.g., 1,3,5 or 'a' for all): " choice

        case "$choice" in
            q|Q)
                echo "Goodbye!"
                exit 0
                ;;
            a|A)
                install_all
                ;;
            *)
                # Handle comma-separated numbers
                IFS=',' read -ra selections <<< "$choice"
                for sel in "${selections[@]}"; do
                    sel=$(echo "$sel" | tr -d ' ')
                    if [[ "$sel" =~ ^[0-9]+$ ]] && [ "$sel" -ge 1 ] && [ "$sel" -le "${#WIDGETS[@]}" ]; then
                        widget="${WIDGETS[$((sel-1))]}"
                        name="${widget%%:*}"
                        install_widget "$name"
                    else
                        warn "Invalid selection: $sel"
                    fi
                done
                ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

main "$@"
