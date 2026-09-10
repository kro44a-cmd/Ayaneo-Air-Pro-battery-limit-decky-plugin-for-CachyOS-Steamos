import {
  PanelSection,
  PanelSectionRow,
  SliderField,
  staticClasses,
  definePlugin,
} from "@decky/ui";
import { callable } from "@decky/api";
import { useState, useEffect } from "react";
import { FaBatteryFull } from "react-icons/fa";

const getBatteryLimit = callable<[], number>("get_battery_limit");
const setBatteryLimit = callable<[limit: number], boolean>("set_battery_limit");

function Content() {
  const [batteryLimit, setBatteryLimitState] = useState<number>(80);
  const [loading, setLoading] = useState<boolean>(true);

  const loadBatteryLimit = async () => {
    try {
      const result = await getBatteryLimit();
      if (result >= 50 && result <= 100) {
        setBatteryLimitState(result);
      }
    } catch (e) {
      console.error("Failed to get battery limit:", e);
    }
    setLoading(false);
  };

  const handleBatteryLimitChange = async (value: number) => {
    setBatteryLimitState(value);
    try {
      await setBatteryLimit(value);
    } catch (e) {
      console.error("Failed to set battery limit:", e);
    }
  };

  useEffect(() => {
    loadBatteryLimit();
  }, []);

  return (
    <PanelSection title="Battery Charge Limit">
      <PanelSectionRow>
        {loading ? (
          <div>Loading...</div>
        ) : (
          <SliderField
            label="Charge Limit"
            value={batteryLimit}
            min={50}
            max={100}
            step={1}
            showValue={true}
            onChange={handleBatteryLimitChange}
          />
        )}
      </PanelSectionRow>
    </PanelSection>
  );
}

export default definePlugin(() => {
  return {
    title: <div className={staticClasses.Title}>Battery Charge Limit</div>,
    content: <Content />,
    icon: <FaBatteryFull />,
  };
});
