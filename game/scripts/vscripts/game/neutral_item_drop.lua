NeutralItemDrop = NeutralItemDrop or {
	neutral_item_list = {},
	drop_period = {
		ot3_demo = {
			10,
			10,
			10,
			10,
			10,
		},
		ot3_necropolis_ffa = {
			120,
			270,
			420,
			570,
			900,
		},
		ot3_gardens_duo = {
			120,
			270,
			420,
			570,
			900,
		},
		ot3_jungle_quintet = {
			120,
			270,
			420,
			570,
			900,
		},
		ot3_desert_octet = {
			120,
			270,
			420,
			570,
			900,
		},
	},
	drop_count = {
		ot3_demo = 8,
		ot3_necropolis_ffa = 3,
		ot3_gardens_duo = 4,
		ot3_jungle_quintet = 7,
		ot3_desert_octet = 10,
	},
	-- i'd rather have them hardcoded than relying on valve keeping naming scheme
	token_item_names = {
		"item_tier1_token",
		"item_tier2_token",
		"item_tier3_token",
		"item_tier4_token",
		"item_tier5_token",
	}
}

ListenToGameEvent("game_rules_state_change",
	function()
		local new_state = GameRules:State_Get()
		if new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			NeutralItemDrop:Activate()
		end
	end,
nil)

function NeutralItemDrop:Activate()
	self.neutral_items_kv = LoadKeyValues("scripts/npc/neutral_items.txt")

	for tier, tier_content in pairs(self.neutral_items_kv) do
		for item_name, _ in pairs(tier_content.items or {}) do
			self.neutral_item_list[item_name] = tier
		end
	end

	for tier, name in pairs(self.token_item_names) do
		self.neutral_item_list[name] = tier
	end

	for i = 1, 5 do
		Timers:CreateTimer(self.drop_period[GetMapName()][i], function() return self:Drop(i) end)
	end
end


function NeutralItemDrop:Drop(tier)
	local item_name = self.token_item_names[tier]

	for team = DOTA_TEAM_FIRST,DOTA_TEAM_CUSTOM_MAX do
		for _, hero in pairs(GameLoop.heroes_by_team[team] or {}) do

			if IsValidEntity(hero) then
				local item = CreateItem(item_name, nil, nil)
				local player_id = hero:GetPlayerOwnerID()
				if IsValidEntity(item) then
					-- goes into stash if setting is enabled
					-- or in inventory, but only if hero has slots for it
					if WebSettings:GetSettingValue(player_id, "neutral_item_into_stash", false) then
						PlayerResource:AddNeutralItemToStash(player_id, team, item)
					else
						if hero:HasAnyAvailableInventorySpace() then
							-- RecordNeutralItemEarned(hero, item, tier)
							hero:AddItem(item)
						else
							PlayerResource:AddNeutralItemToStash(player_id, team, item)
						end
					end


					local origin = hero:GetAbsOrigin()
					local neutral_particle = ParticleManager:CreateParticle("particles/items2_fx/neutralitem_teleport.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleControl(neutral_particle, 0, origin)
					ParticleManager:ReleaseParticleIndex(neutral_particle)

					EmitSoundOnEntityForPlayer("NeutralItem.TeleportToStash", hero, hero:GetPlayerOwnerID())
				end
			end
		end
	end
end


function NeutralItemDrop:CountNeutralItems(unit, tier)
	local count = 0

	for i = DOTA_ITEM_SLOT_7, DOTA_ITEM_NEUTRAL_SLOT do
		local item = unit:GetItemInSlot(i)

		if item and item:IsNeutralDrop() and NeutralItemDrop.neutral_item_list[item:GetAbilityName()] == tier then
			count = count + 1
		end
	end

	return count
end

function NeutralItemDrop:CountNeutralItemsForPlayer(player_id, neutral_item_tier)
	local count = 0
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)

	if hero then
		count = NeutralItemDrop:CountNeutralItems(hero, neutral_item_tier)

		for _, unit in pairs(hero:GetAdditionalOwnedUnits()) do
			if unit:GetClassname() == "npc_dota_lone_druid_bear" then
				count = count + NeutralItemDrop:CountNeutralItems(unit, neutral_item_tier)
			end
		end

		local courier = PlayerResource:GetPreferredCourierForPlayer(player_id)
		if courier then
			count = count + NeutralItemDrop:CountNeutralItems(courier, neutral_item_tier)
		end
	end

	return count
end
