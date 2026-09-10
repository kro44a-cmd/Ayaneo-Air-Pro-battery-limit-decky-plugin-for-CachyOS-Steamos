#!/bin/bash
set -e

PLUGIN_DIR="/home/deck/homebrew/plugins/battery-charge-limit"
SCRIPT_PATH="/usr/local/bin/battery-limit.sh"
SERVICE_PATH="/etc/systemd/system/battery-limit.service"
CONFIG_PATH="/etc/battery-limit.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo:"
    echo "  curl -fsSL https://raw.githubusercontent.com/kro44a-cmd/Ayaneo-Air-Pro-battery-limit-decky-plugin-for-CachyOS-SteamOS/main/uninstall.sh | sudo bash"
    exit 1
fi

echo "=== AYANEO Air Pro Battery Charge Limit Uninstaller ==="

echo "Stopping battery-limit service..."
systemctl disable --now battery-limit.service 2>/dev/null || true

echo "Removing service..."
rm -f "$SERVICE_PATH"

echo "Removing battery-limit script..."
rm -f "$SCRIPT_PATH"

echo "Removing Decky plugin..."
rm -rf "$PLUGIN_DIR"

systemctl daemon-reload

echo
echo "=== Uninstallation complete ==="
echo
echo "Removed:"
echo "- Decky plugin"
echo "- Battery-limit service"
echo "- Battery-limit script"
echo
echo "Configuration preserved:"
echo "$CONFIG_PATH"
echo
echo "To remove the configuration as well:"
echo "  sudo rm $CONFIG_PATH"
