COMMON_AURA_CONTROL_POINTS = {
	[0] = {
		attach_type = PATTACH_POINT_FOLLOW,
		attachment = "attach_hitlock"
	},
}

ITEM_DEFINITIONS["aura_green_1"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNCOMMON,

	unlocked_with = {
		subscription_tier = 1,
	},

	particles = {
		{
			path = "particles/cosmetic/auras/test_aura_1_sup1/test_aura_1_sup1.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},

	sound_effect_name = "Blink_Layer.Swift",
}

ITEM_DEFINITIONS["aura_purple_1"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.COMMON,

	unlocked_with = {
		subscription_tier = 2,
	},

	particles = {
		{
			path = "particles/cosmetic/auras/test_aura_3_treasure/test_aura_3_treasure.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["diretide_emblem_orange"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.IMMORTAL,

	unlocked_with = {
		subscription_tier = 2,
	},

	particles = {
		{
			path = "particles/cosmetic/auras/diretide_emblem_red/diretide_emblem_red.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["emblem_ti7"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.LEGENDARY,

	unlocked_with = {
		subscription_tier = 2,
	},

	particles = {
		{
			path = "particles/econ/events/ti7/ti7_hero_effect.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["emblem_ti8"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.LEGENDARY,

	unlocked_with = {
		subscription_tier = 2,
	},

	particles = {
		{
			path = "particles/econ/events/ti8/ti8_hero_effect.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["emblem_ti9"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.LEGENDARY,

	unlocked_with = {
		subscription_tier = 2,
	},

	particles = {
		{
			path = "particles/cosmetic/auras/overgrown_emblem/overgrown_emblem.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["emblem_ti10"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.IMMORTAL,

	unlocked_with = {
		subscription_tier = 2,
	},

	particles = {
		{
			path = "particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["newbloom_aura"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.RARE,

	unlocked_with = {
		subscription_tier = 2,
	},

	particles = {
		{
			path = "particles/cosmetic/auras/newbloom/newbloom.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["aura_gyrus"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.COMMON,

	particles = {
		{
			path = "particles/cosmetic/auras/gyrus/gyrus.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["aura_orbis"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNCOMMON,

	particles = {
		{
			path = "particles/cosmetic/auras/orbis/orbis.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["aura_virtus"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.RARE,

	particles = {
		{
			path = "particles/cosmetic/auras/virtus/virtus.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["aura_anima"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.MYTHICAL,

	particles = {
		{
			path = "particles/cosmetic/auras/anima/anima.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["game_breaker"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.ARCANA,

	particles = {
		{
			path = "particles/cosmetic/auras/game_breaker/game_breaker.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_1_silver"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/001/silver_aura.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_1_golden"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/001/gold_aura.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_2_silver"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/002/s1_23_silver_reward.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_2_golden"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/002/s1_23_gold_reward.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_3_silver"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/003/s2_23_silver_reward.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_3_golden"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/003/s2_23_gold_reward.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_4_silver"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/004/s3_23_silver_reward.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}

ITEM_DEFINITIONS["season_reset_4_golden"] = {
	slot = INVENTORY_SLOTS.AURA,
	type = ITEM_TYPES.EQUIPMENT,
	rarity = ITEM_RARITIES.UNIQUE,

	particles = {
		{
			path = "particles/cosmetic/auras/season_reward/004/s3_23_gold_reward.vpcf",
			attach_type = PATTACH_POINT_FOLLOW,
			control_points = COMMON_AURA_CONTROL_POINTS,
		},
	},
}