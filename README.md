# AYANEO Air Pro Battery Charge Limit

The installer now bootstraps everything automatically.

## One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/kro44a-cmd/Ayaneo-Air-Pro-battery-limit-decky-plugin-for-CachyOS-SteamOS/main/install.sh | sudo bash
```

### The installer automatically installs

- Git (if missing)
- Node.js
- npm
- pnpm 9
- Builds the Decky plugin
- Creates `/etc/battery-limit.conf`
- Installs and enables `battery-limit.service`
- Installs the Decky plugin
