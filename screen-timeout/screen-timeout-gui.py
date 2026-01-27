#!/usr/bin/env python3
"""
Screen Timeout GUI - Configure DPMS settings via xset
Auto-applies settings on selection
"""

import json
import subprocess
import tkinter as tk
from tkinter import ttk
from pathlib import Path

CONFIG_DIR = Path.home() / ".config" / "screen-timeout"
CONFIG_FILE = CONFIG_DIR / "config.json"


def load_config():
    """Load saved configuration."""
    try:
        if CONFIG_FILE.exists():
            with open(CONFIG_FILE) as f:
                return json.load(f)
    except Exception:
        pass
    return {"enabled": True, "timeout": 600}


def save_config(enabled, timeout):
    """Save configuration to file."""
    try:
        CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        with open(CONFIG_FILE, 'w') as f:
            json.dump({"enabled": enabled, "timeout": timeout}, f)
        return True
    except Exception:
        return False


def get_current_dpms():
    """Get current DPMS timeout values."""
    try:
        result = subprocess.run(['xset', 'q'], capture_output=True, text=True)
        lines = result.stdout.split('\n')
        dpms_enabled = True
        standby = suspend = off = 0

        for line in lines:
            if 'DPMS is Disabled' in line:
                dpms_enabled = False
            if 'Standby:' in line:
                parts = line.split()
                for j, part in enumerate(parts):
                    if part == 'Standby:':
                        standby = int(parts[j + 1])
                    elif part == 'Suspend:':
                        suspend = int(parts[j + 1])
                    elif part == 'Off:':
                        off = int(parts[j + 1])

        return dpms_enabled, standby, suspend, off
    except Exception:
        return True, 600, 600, 600


def apply_dpms(enabled, timeout_seconds):
    """Apply DPMS and screensaver settings."""
    try:
        if enabled:
            subprocess.run(['xset', 's', str(timeout_seconds), str(timeout_seconds)], check=True)
            subprocess.run(['xset', '+dpms'], check=True)
            subprocess.run(['xset', 'dpms', str(timeout_seconds), str(timeout_seconds), str(timeout_seconds)], check=True)
        else:
            subprocess.run(['xset', 's', 'off'], check=True)
            subprocess.run(['xset', 's', '0', '0'], check=True)
            subprocess.run(['xset', '-dpms'], check=True)
        return True
    except subprocess.CalledProcessError:
        return False


class ScreenTimeoutApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Screen Timeout")
        self.root.geometry("340x200")
        self.root.resizable(True, True)
        self.root.minsize(300, 180)

        # Theme colors (customize these)
        self.bg = "#2c3746"
        self.bg_alt = "#343f53"
        self.fg = "#ffffff"
        self.blue = "#176ef1"
        self.teal = "#2aacaa"
        self.yellow = "#f7c067"
        self.gray = "#9cacad"

        self.root.configure(bg=self.bg)

        style = ttk.Style()
        style.theme_use('clam')
        style.configure('TFrame', background=self.bg)
        style.configure('TLabel', background=self.bg, foreground=self.fg, font=('Hack Nerd Font', 10))
        style.configure('TCheckbutton', background=self.bg, foreground=self.fg, font=('Hack Nerd Font', 10))
        style.configure('Header.TLabel', font=('Hack Nerd Font', 11, 'bold'), foreground=self.teal)
        style.configure('Status.TLabel', font=('Hack Nerd Font', 9), foreground=self.gray)

        self.create_widgets()
        self.load_current_settings()

    def create_widgets(self):
        main_frame = ttk.Frame(self.root, padding=10)
        main_frame.pack(fill=tk.BOTH, expand=True)

        header_frame = ttk.Frame(main_frame)
        header_frame.pack(fill=tk.X, pady=(0, 10))

        header = ttk.Label(header_frame, text="Screen Timeout", style='Header.TLabel')
        header.pack(side=tk.LEFT)

        self.status_label = ttk.Label(header_frame, text="", style='Status.TLabel')
        self.status_label.pack(side=tk.RIGHT)

        self.dpms_enabled = tk.BooleanVar(value=True)
        enable_cb = ttk.Checkbutton(main_frame, text="Enable screen timeout",
                                     variable=self.dpms_enabled, command=self.on_toggle)
        enable_cb.pack(anchor=tk.W, pady=(0, 10))

        self.presets_frame = ttk.Frame(main_frame)
        self.presets_frame.pack(fill=tk.X, pady=5)

        presets = [("1m", 60), ("5m", 300), ("10m", 600), ("30m", 1800), ("1h", 3600), ("2h", 7200)]
        self.preset_buttons = []
        for text, seconds in presets:
            btn = tk.Button(self.presets_frame, text=text, width=4,
                           bg=self.bg_alt, fg=self.fg, activebackground=self.blue,
                           activeforeground=self.fg, relief=tk.FLAT, bd=0,
                           command=lambda s=seconds: self.set_timeout(s))
            btn.pack(side=tk.LEFT, padx=2, expand=True)
            self.preset_buttons.append((btn, seconds))

        slider_frame = ttk.Frame(main_frame)
        slider_frame.pack(fill=tk.X, pady=(15, 5))

        self.timeout_var = tk.IntVar(value=600)
        self.slider = tk.Scale(slider_frame, from_=60, to=7200, orient=tk.HORIZONTAL,
                               variable=self.timeout_var, command=self.on_slider_change,
                               bg=self.bg, fg=self.fg, troughcolor=self.bg_alt,
                               highlightthickness=0, activebackground=self.blue,
                               showvalue=False)
        self.slider.pack(fill=tk.X)

        self.time_label = ttk.Label(main_frame, text="10 minutes")
        self.time_label.pack(anchor=tk.CENTER)

    def load_current_settings(self):
        config = load_config()
        if CONFIG_FILE.exists():
            self.dpms_enabled.set(config.get("enabled", True))
            self.timeout_var.set(config.get("timeout", 600))
        else:
            enabled, standby, suspend, off = get_current_dpms()
            self.dpms_enabled.set(enabled)
            timeout = max(standby, suspend, off)
            if timeout > 0:
                self.timeout_var.set(timeout)

        self.update_display()
        self.update_button_highlight()

    def on_toggle(self):
        self.apply_and_save()
        self.update_presets_state()

    def update_presets_state(self):
        state = tk.NORMAL if self.dpms_enabled.get() else tk.DISABLED
        for btn, _ in self.preset_buttons:
            btn.configure(state=state)
        self.slider.configure(state=state)

    def set_timeout(self, seconds):
        self.timeout_var.set(seconds)
        self.apply_and_save()
        self.update_button_highlight()

    def on_slider_change(self, _):
        self.update_display()
        self.update_button_highlight()
        self.apply_and_save()

    def update_display(self):
        seconds = self.timeout_var.get()
        if seconds >= 3600:
            hours = seconds // 3600
            mins = (seconds % 3600) // 60
            text = f"{hours}h {mins}m" if mins > 0 else f"{hours}h"
        else:
            text = f"{seconds // 60}m"
        self.time_label.config(text=text)

    def update_button_highlight(self):
        current = self.timeout_var.get()
        for btn, seconds in self.preset_buttons:
            btn.configure(bg=self.blue if seconds == current else self.bg_alt)

    def apply_and_save(self):
        enabled = self.dpms_enabled.get()
        timeout = self.timeout_var.get()

        if apply_dpms(enabled, timeout):
            save_config(enabled, timeout)
            if enabled:
                self.status_label.config(text=f"[{timeout // 60}m]", foreground=self.teal)
            else:
                self.status_label.config(text="[OFF]", foreground=self.yellow)


def main():
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "--apply":
        config = load_config()
        apply_dpms(config.get("enabled", True), config.get("timeout", 600))
        return

    root = tk.Tk()
    ScreenTimeoutApp(root)
    root.mainloop()


if __name__ == "__main__":
    main()
