#!/bin/bash
set -e

PLUGIN_NAME="battery-charge-limit"
PLUGIN_DIR="/home/deck/homebrew/plugins/$PLUGIN_NAME"
SCRIPT_PATH="/usr/local/bin/battery-limit.sh"
SERVICE_PATH="/etc/systemd/system/battery-limit.service"
CONFIG_PATH="/etc/battery-limit.conf"

echo "=== AYANEO Air Pro Battery Charge Limit Installer ==="

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo:"
    echo "  sudo ./install.sh"
    exit 1
fi

if [ ! -d "/home/deck" ]; then
    echo "Error: /home/deck was not found."
    exit 1
fi

if [ ! -e "/sys/class/power_supply/BAT0/capacity" ]; then
    echo "Error: BAT0 capacity interface was not found."
    exit 1
fi

if [ ! -e "/sys/class/power_supply/BAT0/charge_behaviour" ]; then
    echo "Error: BAT0 charge_behaviour interface was not found."
    exit 1
fi

if ! command -v pnpm >/dev/null 2>&1; then
    echo "Error: pnpm 9 is required to build the Decky plugin."
    echo "Install Node.js and pnpm 9, then run this installer again."
    exit 1
fi

if [ ! -f "$CONFIG_PATH" ]; then
    echo "80" > "$CONFIG_PATH"
    chmod 644 "$CONFIG_PATH"
    echo "Created $CONFIG_PATH with default limit: 80%"
else
    echo "Keeping existing $CONFIG_PATH:"
    cat "$CONFIG_PATH"
fi

echo "Installing Node dependencies..."
pnpm install

echo "Building Decky plugin..."
pnpm build

echo "Installing Decky plugin..."
mkdir -p "$PLUGIN_DIR"
rm -rf "$PLUGIN_DIR/dist"
cp -r dist "$PLUGIN_DIR/"
cp main.py "$PLUGIN_DIR/"
cp plugin.json "$PLUGIN_DIR/"
[ -f README.md ] && cp README.md "$PLUGIN_DIR/" || true
[ -f LICENSE ] && cp LICENSE "$PLUGIN_DIR/" || true
[ -f package.json ] && cp package.json "$PLUGIN_DIR/" || true

echo "Installing battery-limit service..."
install -m 755 battery-limit.sh "$SCRIPT_PATH"
install -m 644 battery-limit.service "$SERVICE_PATH"

systemctl daemon-reload
systemctl enable battery-limit.service
systemctl restart battery-limit.service

echo
echo "=== Installation complete ==="
echo "Battery limit: $(cat "$CONFIG_PATH")%"
echo "Decky plugin: $PLUGIN_DIR"
echo "Service: battery-limit.service"
echo
echo "Restart Decky/Steam if the plugin does not appear immediately."
