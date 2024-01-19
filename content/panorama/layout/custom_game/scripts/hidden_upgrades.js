const HIDDEN_UPGRADES = {
	morphling_morph: ["bonus_attributes"],
	nevermore_shadowraze2: [
		"shadowraze_damage",
		"stack_bonus_damage",
		"shadowraze_radius",
		"duration",
		"shadowraze_radius",
		"cooldown_and_manacost",
	],
	nevermore_shadowraze3: [
		"shadowraze_damage",
		"stack_bonus_damage",
		"shadowraze_radius",
		"duration",
		"shadowraze_radius",
		"cooldown_and_manacost",
	],
	nevermore_necromastery: ["necromastery_max_souls_scepter"],
};

GameUI.IsHiddenUpgrade = (ability_name, upgrade_name) => {
	return HIDDEN_UPGRADES[ability_name] != undefined && HIDDEN_UPGRADES[ability_name].indexOf(upgrade_name) > -1;
};
