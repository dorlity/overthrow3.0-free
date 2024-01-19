ITEM_DEFINITIONS["treasure_1"] = {
	slot = INVENTORY_SLOTS.TREASURES,
	type = ITEM_TYPES.CONSUMABLE,
	rarity = ITEM_RARITIES.UNCOMMON,

	unlocked_with = {
		currency = 9150
	},

	on_consume = Resolve("OnTreasureUsed", "WebTreasure"),
}
ITEM_DEFINITIONS["treasure_2"] = {
	slot = INVENTORY_SLOTS.TREASURES,
	type = ITEM_TYPES.CONSUMABLE,
	rarity = ITEM_RARITIES.RARE,

	unlocked_with = {
		currency = 9300
	},

	on_consume = Resolve("OnTreasureUsed", "WebTreasure"),
}

ITEM_DEFINITIONS["treasure_3"] = {
	slot = INVENTORY_SLOTS.TREASURES,
	type = ITEM_TYPES.CONSUMABLE,
	rarity = ITEM_RARITIES.MYTHICAL,

	unlocked_with = {
		currency = 9800
	},

	on_consume = Resolve("OnTreasureUsed", "WebTreasure"),
}
