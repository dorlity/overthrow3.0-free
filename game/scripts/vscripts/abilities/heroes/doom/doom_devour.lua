local BASIC_ABILITY_SETS = {
	-- order within brackets is important! we want the player to get active abilities on ability index 3 and 4
	-- and auras behind ulti for valid hotkeys

	{ "devour_disarm", "kobold_tunneler_prospecting" },
	{ "devour_break", "devour_speed_aura" },
	{ "forest_troll_high_priest_heal", "devour_heal_amp_aura" },
	{ "fel_beast_haunt", "ghost_frost_attack" },
	{ "harpy_storm_chain_lightning", "harpy_scout_take_off" },
	{ "centaur_khan_war_stomp", "devour_cloak_aura" },
	{ "giant_wolf_intimidate", "alpha_wolf_critical_strike", "devour_command_aura" },
	{ "satyr_trickster_purge", "satyr_soulstealer_mana_burn", "devour_mana_aura" },
	{ "ogre_bruiser_ogre_smash", "ogre_magi_frost_armor" },
	{ "mud_golem_hurl_boulder", "mud_golem_rock_destroy" },
	{ "satyr_hellcaller_shockwave", "devour_unholy_aura" },
	{ "devour_endurance_aura", "devour_enrage_attack_speed" },
	{ "polar_furbolg_ursa_warrior_thunder_clap", "devour_enrage_damage" },
	{ "enraged_wildkin_hurricane", "enraged_wildkin_tornado", "devour_toughness_aura" },
	{ "dark_troll_warlord_ensnare", "dark_troll_warlord_raise_dead", "hill_troll_rally" },
	{ "warpine_raider_seed_shot", "gnoll_assassin_envenomed_weapon" },		-- idk where to put envenomed weapon so this one is a wildcard
}

local ANCIENT_ABILITY_SETS = {
	-- order within brackets is important! we want the player to get active abilities on ability index 3 and 4
	-- and auras behind ulti

	{ "black_dragon_fireball", "devour_dragonhide_aura", "devour_magic_amplification_aura" },	-- TODO readd "black_dragon_splash_attack" because it's useless, splash is for ranged units only
	{ "big_thunder_lizard_frenzy", "big_thunder_lizard_slam", "big_thunder_lizard_wardrums_aura" }, -- TODO devour_wardrums_aura -> the vanilla aura works fine, except it is hidden on the caster, if someone wants to rewrite the accuracy part be my guest
	{ "devour_hp_aura", "devour_weakening_aura" },
	{ "ice_shaman_incendiary_bomb", "devour_time_warp_aura" },

	-- Prowler abilites (deprecated)
	--[[
		{ "spawnlord_aura" },
		{ "spawnlord_master_stomp", "spawnlord_master_freeze" },
	]]
}

doom_devour_custom = {}

function doom_devour_custom:CastFilterResult()
	local caster = self:GetCaster()

	if caster:HasModifier("modifier_muerta_parting_shot_soul_clone") then
		return UF_FAIL_CUSTOM
	end
end

function doom_devour_custom:GetCustomCastError()
	return "dota_hud_error_ability_is_hidden"
end

function doom_devour_custom:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	caster:EmitSound("Hero_DoomBringer.Devour")

	ParticleManager:SetParticleControlEnt(
		ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster),
		1,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		caster:GetOrigin(),
		true
	)

	-- Rubick should not steal abilities with devour, according to vanilla behavior
	if caster:GetUnitName() == "npc_dota_hero_doom_bringer" and not self:GetAutoCastState() then
		if self.ability_set then	-- if ability_set exists, remove it
			for i, ability_name in ipairs(self.ability_set) do
				if ability_name then
					if i == 1 or i == 2 then
						caster:SwapAbilities("doom_bringer_empty" .. i, ability_name, true, false)
					end
					caster:RemoveAbility(ability_name)

				end
			end
		end

		if caster:HasTalent("special_devour_ancients_chance") then		-- target ancients
			local chance = caster:FindTalentValue("special_devour_ancients_chance") or 0
			if RollPercentage(chance) then
				self.is_ancient_roll = true
			else
				self.is_ancient_roll = false
			end
		end

		if not self.sets or #self.sets == 0 then
			if self.is_ancient_roll then
				self.sets = table.shuffled(ANCIENT_ABILITY_SETS)
				self.is_ancient_set = true
			else
				self.sets = table.shuffled(BASIC_ABILITY_SETS)
				self.is_ancient_set = false
			end

		else
			if self.is_ancient_roll and not self.is_ancient_set then
				self.sets = table.shuffled(ANCIENT_ABILITY_SETS)
				self.is_ancient_set = true
			elseif not self.is_ancient_roll and self.is_ancient_set then	-- not ancient roll is a basic roll
				self.sets = table.shuffled(BASIC_ABILITY_SETS)
				self.is_ancient_set = false
			end
		end

		self.previous_ability_set = self.ability_set
		self.ability_set = table.remove(self.sets)		-- get new ability_set from random shuffle

		if self.ability_set and self.previous_ability_set then
			while self.ability_set == self.previous_ability_set do	-- sometimes you get same ability if previous one emptied the list and the new one from the list is the same one
				self.ability_set = table.remove(self.sets)			-- very low chance with many abilities, but it can happen
			end
		end

		if self.ability_set then
			for i, ability_name in ipairs(self.ability_set) do
				if ability_name then
					local ability = caster:AddAbility(ability_name)
					ability:SetStolen(true)
					ability:SetLevel(GetCreepAbilityLevel() + (self:GetSpecialValueFor("bonus_creep_level") or 0))
					if i == 1 or i == 2 then
						caster:SwapAbilities("doom_bringer_empty" .. i, ability_name, false, true)
					end
				end
			end
		end
	end

	local gold = self:GetSpecialValueFor("cast_bonus_gold")
	local exp = self:GetSpecialValueFor("cast_bonus_exp")

	caster:ModifyGold(gold, false, DOTA_ModifyGold_CreepKill)
	caster:AddExperience(exp, DOTA_ModifyXP_CreepKill, false, true)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, caster, gold, nil)

	caster:AddNewModifier(caster, self, "modifier_doom_devour_custom", {duration = self:GetCooldownTimeRemaining()})

end

LinkLuaModifier("modifier_doom_devour_custom", "abilities/heroes/doom/doom_devour", LUA_MODIFIER_MOTION_NONE)
modifier_doom_devour_custom = {
	OnCreated = function(self)
		self.ability = self:GetAbility()
		self.armor = self.ability:GetSpecialValueFor("devour_bonus_armor")
	end,
	OnRefresh = function(self) self.armor = self.ability:GetSpecialValueFor("devour_bonus_armor") end,
	IsHidden = function() return false end,
	IsPurgable = function() return false end,
	IsDebuff = function() return false end,
	GetModifierPhysicalArmorBonus = function(self) return self.armor end,
	GetModifierMagicalResistanceBonus = function(self) return self.ability:GetSpecialValueFor("magic_resist") end,
	GetAttributes = function() return MODIFIER_ATTRIBUTE_MULTIPLE end,
	RemoveOnDeath = function(self) return false end,
}

function modifier_doom_devour_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_doom_devour_custom:OnDestroy()
	if (not IsServer()) then return end

	local parent = self:GetParent()
	local ability = self:GetAbility()

	if parent and ability then
		local gold = ability:GetSpecialValueFor("devour_bonus_gold")

		parent:ModifyGold(gold, false, DOTA_ModifyGold_CreepKill)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, parent, gold, nil)
	end
end
