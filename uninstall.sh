#!/bin/bash
set -e

PLUGIN_DIR="/home/deck/homebrew/plugins/battery-charge-limit"
SCRIPT_PATH="/usr/local/bin/battery-limit.sh"
SERVICE_PATH="/etc/systemd/system/battery-limit.service"
CONFIG_PATH="/etc/battery-limit.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo: sudo ./uninstall.sh"
    exit 1
fi

systemctl disable --now battery-limit.service 2>/dev/null || true
rm -f "$SERVICE_PATH" "$SCRIPT_PATH"
rm -rf "$PLUGIN_DIR"
systemctl daemon-reload

echo "Battery Charge Limit plugin and service removed."
echo "Configuration preserved at $CONFIG_PATH"
