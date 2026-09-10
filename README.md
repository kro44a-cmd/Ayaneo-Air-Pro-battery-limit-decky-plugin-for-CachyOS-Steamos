# AYANEO Air Pro Battery Charge Limit

A Decky Loader plugin and systemd service for setting and enforcing a battery
charge limit on the AYANEO Air Pro under CachyOS/SteamOS.

The Decky plugin provides the GUI. The systemd service performs the actual
battery monitoring and charging control.

## Features

- Battery charge-limit slider inside Decky Loader
- Configurable from 50% to 100%
- Creates `/etc/battery-limit.conf` automatically
- Default limit: 80%
- Existing battery-limit settings are preserved during reinstall
- Systemd service starts automatically at boot
- No service restart is required when the limit is changed
- Uses the Linux `charge_behaviour` interface

## Requirements

### Device

The device must expose these Linux power-supply interfaces:

```text
/sys/class/power_supply/BAT0/capacity
/sys/class/power_supply/BAT0/charge_behaviour
```

The installer checks for both before installing the service.

### Operating system

- CachyOS or SteamOS
- Linux system with systemd
- A working Decky Loader installation

### For building/installing from source

- Node.js 16.14 or newer
- pnpm 9
- Git
- `sudo` / root privileges

The Decky plugin template currently recommends Node.js 16.14+ and pnpm 9
for building plugins.

> End users installing a pre-built Decky release do not need Node.js or pnpm.
> They are only required when building the plugin from source.

## Installation

### One-command setup from GitHub

Clone the repository and run the installer:

```bash
git clone https://github.com/kro44a-cmd/Ayaneo-Air-Pro-battery-limit-decky-plugin-for-CachyOS-SteamOS.git && cd Ayaneo-Air-Pro-battery-limit-decky-plugin-for-CachyOS-SteamOS && sudo ./install.sh
```

The installer will:

1. Check the required battery interfaces.
2. Create `/etc/battery-limit.conf` with `80` if it does not exist.
3. Build the Decky frontend.
4. Install the Decky plugin.
5. Install the battery-limit systemd service.
6. Enable the service at boot.
7. Start the service.

An existing `/etc/battery-limit.conf` is not overwritten.

## Configuration

The Decky slider writes the selected percentage to:

```text
/etc/battery-limit.conf
```

For example:

```text
80
```

The file is intentionally simple: it contains only the desired battery
percentage.

## How it works

The Decky plugin writes the selected limit to:

```text
/etc/battery-limit.conf
```

The systemd service checks the battery every 10 seconds.

When the battery reaches or exceeds the configured limit:

```text
/sys/class/power_supply/BAT0/charge_behaviour
```

is set to:

```text
inhibit-charge
```

When the battery falls below the configured limit, it is set back to:

```text
auto
```

The Decky plugin itself does not continuously monitor the battery.

## Development / building

```bash
pnpm install
pnpm build
```

The frontend build is generated in:

```text
dist/
```

## Uninstall

From the repository directory:

```bash
sudo ./uninstall.sh
```

The Decky plugin and systemd service are removed.

The configuration file is intentionally preserved:

```text
/etc/battery-limit.conf
```

To remove it manually:

```bash
sudo rm /etc/battery-limit.conf
```

## License

See `LICENSE`.

## Disclaimer

This software changes the device's charging behavior through the Linux power
supply interface. Use it at your own risk. Hardware support depends on the
device exposing the required `BAT0` interfaces.
