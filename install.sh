#!/bin/bash
set -e

REPO="kro44a-cmd/Ayaneo-Air-Pro-battery-limit-decky-plugin-for-CachyOS-SteamOS"
PLUGIN_DIR="/home/deck/homebrew/plugins/battery-charge-limit"
CONFIG="/etc/battery-limit.conf"

if [ "$EUID" -ne 0 ]; then
    echo "Run with sudo:"
    echo "sudo bash install.sh"
    exit 1
fi

echo "== AYANEO Battery Charge Limit Installer =="

# Install Git if needed
if ! command -v git >/dev/null 2>&1; then
    echo "Installing Git..."
    pacman -Sy --noconfirm git
fi

# Install Node.js if needed
if ! command -v node >/dev/null 2>&1; then
    echo "Installing Node.js..."
    pacman -Sy --noconfirm nodejs npm
fi

# Install pnpm if needed
if ! command -v pnpm >/dev/null 2>&1; then
    echo "Installing pnpm..."
    npm install -g pnpm@9
fi

TMP=$(mktemp -d)
cd "$TMP"

echo "Downloading repository..."
git clone "https://github.com/$REPO.git"
cd Ayaneo-Air-Pro-battery-limit-decky-plugin-for-CachyOS-SteamOS

echo "Installing JS dependencies..."
pnpm install

echo "Building Decky plugin..."
pnpm build

echo "Installing Decky plugin..."
mkdir -p "$PLUGIN_DIR"
rm -rf "$PLUGIN_DIR/dist"
cp -r dist "$PLUGIN_DIR/"
cp main.py plugin.json "$PLUGIN_DIR/"

echo "Creating config..."
if [ ! -f "$CONFIG" ]; then
    echo 80 > "$CONFIG"
fi

echo "Installing battery service..."
install -m755 battery-limit.sh /usr/local/bin/battery-limit.sh
install -m644 battery-limit.service /etc/systemd/system/battery-limit.service

systemctl daemon-reload
systemctl enable --now battery-limit.service

echo
echo "Done."
echo "Battery limit: $(cat "$CONFIG")%"
echo
echo "Future one-liner:"
echo "curl -fsSL https://raw.githubusercontent.com/$REPO/main/install.sh | sudo bash"
