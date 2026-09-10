import decky

BATTERY_LIMIT_FILE = "/etc/battery-limit.conf"


class Plugin:
    async def get_battery_limit(self) -> int:
        with open(BATTERY_LIMIT_FILE, "r") as f:
            return int(f.read().strip())

    async def set_battery_limit(self, limit: int) -> bool:
        limit = max(50, min(100, int(limit)))

        with open(BATTERY_LIMIT_FILE, "w") as f:
            f.write(str(limit))

        decky.logger.info(f"Battery charge limit set to {limit}%")
        return True

    async def _main(self):
        decky.logger.info("Battery Charge Limit plugin loaded")

    async def _unload(self):
        decky.logger.info("Battery Charge Limit plugin unloaded")
