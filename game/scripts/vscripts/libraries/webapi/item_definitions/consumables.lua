ITEM_DEFINITIONS["test_consumable"] = {
	slot = INVENTORY_SLOTS.MISC,
	type = ITEM_TYPES.CONSUMABLE,
	rarity = ITEM_RARITIES.UNIQUE,

	-- using Resolve since item definitions are created before relevant module is loaded
	-- alternatively, anonymous function or global function could be used
	-- i.e. on_use = function(item_name, item_data, definition) ... end
	on_use = Resolve("OnTestUse", "Equipment")
}

CONSUMABLE_TEST_FILLER = {
	slot = INVENTORY_SLOTS.MISC,
	type = ITEM_TYPES.CONSUMABLE,
	rarity = ITEM_RARITIES.COMMON,
	on_use = Resolve("OnTestUse", "Equipment"),
}

ITEM_DEFINITIONS["test_consumable_0_1"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_2"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_3"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_4"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_5"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_6"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_7"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_8"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_9"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_0_10"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_1"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_2"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_3"] = {
	slot = INVENTORY_SLOTS.MISC,
	type = ITEM_TYPES.CONSUMABLE,
	rarity = ITEM_RARITIES.ARCANA,
	on_use = Resolve("OnTestUse", "Equipment"),
}
ITEM_DEFINITIONS["test_consumable_1_4"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_5"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_6"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_7"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_8"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_9"] = CONSUMABLE_TEST_FILLER
ITEM_DEFINITIONS["test_consumable_1_10"] = CONSUMABLE_TEST_FILLER
