if not IsClient() then return end

require("utils/init")
require("extensions/client_init")
require("core_declarations")

require("game/upgrades/declarations")
require("game/upgrades/shared")
require("game/upgrades/generic_upgrades/init") -- client-side modifier linking
require("game/modifiers/init") -- client-side modifier linking
require("modifiers/init") -- client-side modifier linking


GENERIC_UPGRADES_DATA = LoadKeyValues("scripts/upgrades/generic.txt")

for upgrade_name, upgrade_data in pairs(GENERIC_UPGRADES_DATA or {}) do
	upgrade_data.class = upgrade_data.class or "modifier"

	UpgradesUtilities:ParseUpgrade(upgrade_data, upgrade_name, UPGRADE_TYPE.GENERIC)
end

print("[GameMode] - client - init finished!")
