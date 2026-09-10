#!/bin/bash
set -u

LIMIT_FILE="/etc/battery-limit.conf"
BATTERY_PATH="/sys/class/power_supply/BAT0"
CAPACITY_FILE="$BATTERY_PATH/capacity"
CHARGE_BEHAVIOUR_FILE="$BATTERY_PATH/charge_behaviour"

while true; do
    if [ ! -r "$LIMIT_FILE" ] || [ ! -r "$CAPACITY_FILE" ] || [ ! -r "$CHARGE_BEHAVIOUR_FILE" ]; then
        sleep 10
        continue
    fi

    LIMIT=$(cat "$LIMIT_FILE")
    CAPACITY=$(cat "$CAPACITY_FILE")
    MODE=$(cat "$CHARGE_BEHAVIOUR_FILE")

    if ! [[ "$LIMIT" =~ ^[0-9]+$ ]] || ! [[ "$CAPACITY" =~ ^[0-9]+$ ]]; then
        sleep 10
        continue
    fi

    if [ "$CAPACITY" -ge "$LIMIT" ] && [ "$MODE" != "inhibit-charge" ]; then
        echo "Battery $CAPACITY% reached limit $LIMIT% - charging disabled"
        echo "inhibit-charge" > "$CHARGE_BEHAVIOUR_FILE"
    elif [ "$CAPACITY" -lt "$LIMIT" ] && [ "$MODE" != "auto" ]; then
        echo "Battery $CAPACITY% below limit $LIMIT% - charging enabled"
        echo "auto" > "$CHARGE_BEHAVIOUR_FILE"
    fi

    sleep 10
done
