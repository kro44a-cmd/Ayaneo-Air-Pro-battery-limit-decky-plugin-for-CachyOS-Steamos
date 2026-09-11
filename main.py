import decky

BATTERY_LIMIT_FILE = "/etc/battery-limit.conf"


class Plugin:
    async def get_battery_limit(self) -> int:
        try:
            with open(BATTERY_LIMIT_FILE, "r") as f:
                return int(f.read().strip())
        except Exception as e:
            decky.logger.error(f"Failed to read battery limit: {e}")
            return 80

    async def set_battery_limit(self, limit: int) -> bool:
        try:
            limit = max(50, min(100, int(limit)))

            with open(BATTERY_LIMIT_FILE, "w") as f:
                f.write(str(limit))

            decky.logger.info(f"Battery charge limit set to {limit}%")
            return True

        except Exception as e:
            decky.logger.error(f"Failed to write battery limit: {e}")
            return False

    async def _main(self):
        decky.logger.info("Battery Charge Limit plugin loaded")

    async def _unload(self):
        decky.logger.info("Battery Charge Limit plugin unloaded")
