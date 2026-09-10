# AYANEO Air Pro Battery Charge Limit

A Decky Loader plugin and systemd service for controlling the battery charge limit on the **AYANEO Air Pro** under CachyOS/SteamOS.

It may also work on other handhelds that use the same Linux `capacity` and `charge_behaviour` interfaces.

## Features

- Battery charge-limit slider in Decky Loader
- Adjustable charge limit from 50% to 100%
- Systemd service runs automatically in the background
- Checks the battery every 10 seconds
- Uses the device's built-in `charge_behaviour` control

## How It Works

The installer creates `/etc/battery-limit.conf`.

The service then:

1. Reads the current battery capacity from `/sys/class/power_supply/BAT0/capacity`
2. Reads the configured limit from `/etc/battery-limit.conf`
3. Compares the current battery capacity with the limit
4. Changes the device's built-in `/sys/class/power_supply/BAT0/charge_behaviour`
5. Sets `inhibit-charge` when the battery reaches or exceeds the limit
6. Sets `auto` when the battery is below the limit
7. Decky is the front end, allowing you to modify the value in the configuration file without needing to leave Gaming Mode

The service repeats this check every 10 seconds.

## Sleep Behaviour

The service does **not** run while the device is asleep.

Instead, the device keeps whatever `charge_behaviour` state it had when it went to sleep.

For example:

`inhibit-charge` -> Sleep -> `inhibit-charge`

`auto` -> Sleep -> `auto`

This means sleeping the device does not automatically enable or disable charging.

## Why This Exists

This is intended for using the AYANEO Air Pro as a **plugged-in Linux machine**, for example when connected to a TV.

You can leave the handheld plugged in and let the charge limit prevent it from remaining at 100% continuously.

When you want to fully charge the battery, you can:

- Move the Decky slider to a higher limit, or
- Put the device to sleep **before it reaches the charge limit**, allowing it to retain its current `auto` charging behaviour.

## Without Decky

Decky is only the graphical interface.

You can manually change the charge limit by editing:

`/etc/battery-limit.conf`

For example:

    sudo nano /etc/battery-limit.conf

Then enter:

    80

No service restart is required.

## Installation

Run:

    curl -fsSL https://raw.githubusercontent.com/kro44a-cmd/Ayaneo-Air-Pro-battery-charge-limit-decky-plugin-for-CachyOS-SteamOS/main/install.sh | sudo bash

The installer builds and installs the Decky plugin, creates the configuration file, and installs and enables the battery-limit service.

## Requirements

- AYANEO Air Pro
- CachyOS or SteamOS
- systemd
- `/sys/class/power_supply/BAT0/capacity`
- `/sys/class/power_supply/BAT0/charge_behaviour`

Other handhelds may work if they use the same battery interfaces and charging logic.

## Uninstall

You can uninstall directly from GitHub without cloning the repository:

    curl -fsSL https://raw.githubusercontent.com/kro44a-cmd/Ayaneo-Air-Pro-battery-charge-limit-decky-plugin-for-CachyOS-SteamOS/main/uninstall.sh | sudo bash

This removes the Decky plugin, battery-limit service, and battery-limit script.

The configuration file is preserved:

    /etc/battery-limit.conf

To remove it manually:

    sudo rm /etc/battery-limit.conf

## Disclaimer

Use at your own risk. Charging behaviour depends on the device's firmware, kernel, and hardware support.
