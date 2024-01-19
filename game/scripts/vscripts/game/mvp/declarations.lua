MVP_REWARDS = {
	{items = {bp_reroll = 8}}, -- MVP
	{items = {bp_reroll = 4}}, -- runner up 1
	{items = {bp_reroll = 4}}, -- runner up 2
}


---@class MVP_TYPE
---@type table<string, number>
MVP_TYPE = {
	NONE = 0,
	WINNER = 1,
	RUNNER_UP_1 = 2,
	RUNNER_UP_2 = 3,
}


---@class MVP_CATEGORY
---@type table<string, number>
MVP_CATEGORY = {
	WARDS = 1,
	-- KILLS_AND_ASSISTS = 2, -- deprecated in favour of separate categories
	DAMAGE_DEALT = 3,
	DAMAGE_TAKEN = 4,
	ALLY_HEALING = 5,
	ORBS_CAPTURED = 6,
	UPGRADES_VARIETY = 7,
	STUN_DURATION = 8,

	KILLS = 9,
	ASSISTS = 10,
	LEAST_DEATHS = 11,
	UNITS_SUMMONED = 12,
}

-- categories mentioned here have their ranks multiplied by desired value
-- to tweak category impact on overall MVP result
MVP_WEIGHT_OVERRIDE = {
	[MVP_CATEGORY.UPGRADES_VARIETY] = 0.2, -- 5x less valuable
	[MVP_CATEGORY.UNITS_SUMMONED] = 0.2,
	[MVP_CATEGORY.WARDS] = 0.3,
	[MVP_CATEGORY.DAMAGE_TAKEN] = 0.6,
	[MVP_CATEGORY.ASSISTS] = 0.6,
	[MVP_CATEGORY.ALLY_HEALING] = 0.7,
	[MVP_CATEGORY.DAMAGE_DEALT] = 0.8,
	[MVP_CATEGORY.ORBS_CAPTURED] = 0.9,
	[MVP_CATEGORY.LEAST_DEATHS] = 0.9,
}


MVP_ASCENDING = false -- highest value = highest rank
MVP_DESCENDING = true -- lowest value = highest rank

-- Overrides category rank sorting (default is MVP_ASCENDING)
---@class MVP_RANK_ORDER
---@type table<MVP_CATEGORY, number>
MVP_RANK_ORDER = {
	[MVP_CATEGORY.LEAST_DEATHS] = MVP_DESCENDING,
}


-- being a leader in certain category grants more points towards total score
MVP_LEADER_MULTIPLIER = 3


---@class MVP_ACCESSOR
---@type table<MVP_CATEGORY, function>
MVP_ACCESSOR = {
	[MVP_CATEGORY.WARDS] = function(player_id)
		local wards = EndGameStats:GetStats(player_id).wards
		return wards["npc_dota_observer_wards"] + wards["npc_dota_sentry_wards"]
	end,

	[MVP_CATEGORY.DAMAGE_DEALT] = function(player_id) return EndGameStats:GetStats(player_id).hero_damage or 0 end,
	[MVP_CATEGORY.DAMAGE_TAKEN] = function(player_id) return EndGameStats:GetStats(player_id).damage_taken or 0 end,
	[MVP_CATEGORY.ALLY_HEALING] = function(player_id) return EndGameStats:GetStats(player_id).total_healing or 0 end,
	[MVP_CATEGORY.ORBS_CAPTURED] = function(player_id) return MVPController.orb_capture_score[player_id] or 0 end,
	[MVP_CATEGORY.UPGRADES_VARIETY] = function(player_id) return MVPController:GetUniqueUpgradesCount(player_id) or 0 end,
	[MVP_CATEGORY.STUN_DURATION] = function(player_id) return PlayerResource:GetStuns(player_id) or 0 end,
	[MVP_CATEGORY.KILLS] = function(player_id) return PlayerResource:GetKills(player_id) or 0 end,
	[MVP_CATEGORY.ASSISTS] = function(player_id) return PlayerResource:GetAssists(player_id) or 0 end,
	[MVP_CATEGORY.LEAST_DEATHS] = function(player_id) return PlayerResource:GetDeaths(player_id) end,
	[MVP_CATEGORY.UNITS_SUMMONED] = function(player_id) return MVPController:GetUnitsSummonedCount(player_id) end,

	-- deprecated
	-- [MVP_CATEGORY.KILLS_AND_ASSISTS] = function(player_id) return PlayerResource:GetAssists(player_id) + PlayerResource:GetKills(player_id) end,
}


MVP_EXCLUDED_CATEGORIES_PER_MAP = {
	-- healing excluded cause self-healing is discarded, and no other allies to heal
	ot3_necropolis_ffa = {MVP_CATEGORY.ALLY_HEALING},
}
