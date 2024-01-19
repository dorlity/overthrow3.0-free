enchantress_enchant_custom = class({})

-- the list is the same as helm of dominator/overlord
enchantress_enchant_custom.JUNGLE_UNITS = {
	--"npc_dota_neutral_kobold",
	--"npc_dota_neutral_kobold_tunneler",
	"npc_dota_neutral_kobold_taskmaster",
	--"npc_dota_neutral_centaur_outrunner",
	"npc_dota_neutral_centaur_khan",
	--"npc_dota_neutral_fel_beast",
	"npc_dota_neutral_polar_furbolg_champion",
	"npc_dota_neutral_polar_furbolg_ursa_warrior",
	"npc_dota_neutral_warpine_raider",
	"npc_dota_neutral_mud_golem",
	--"npc_dota_neutral_mud_golem_split",
	--"npc_dota_neutral_mud_golem_split_doom",
	--"npc_dota_neutral_ogre_mauler",
	"npc_dota_neutral_ogre_magi",
	--"npc_dota_neutral_giant_wolf",
	"npc_dota_neutral_alpha_wolf",
	--"npc_dota_neutral_wildkin",
	"npc_dota_neutral_enraged_wildkin",
	"npc_dota_neutral_satyr_soulstealer",
	"npc_dota_neutral_satyr_hellcaller",
	--"npc_dota_neutral_jungle_stalker",
	"npc_dota_neutral_gnoll_assassin",
	"npc_dota_neutral_ghost",
	--"npc_dota_neutral_dark_troll",
	"npc_dota_neutral_dark_troll_warlord",
	"npc_dota_neutral_satyr_trickster",
	--"npc_dota_neutral_forest_troll_berserker",
	"npc_dota_neutral_forest_troll_high_priest",
	--"npc_dota_neutral_harpy_scout",
	"npc_dota_neutral_harpy_storm",
}


function enchantress_enchant_custom:Spawn()
	if not IsServer() then return end
	self.enchanted_units = {}
end


function enchantress_enchant_custom:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	if caster == target then
		return UF_SUCCESS
	end

	if target:HasModifier("modifier_enchantress_enchant_controlled") then
		return UF_FAIL_CUSTOM
	end

	if not target:IsConsideredHero() and (target:GetLevel() > (self:GetSpecialValueFor("level_req") or 6)) then
		return UF_FAIL_CUSTOM
	end

	if target:IsAncient() and not caster:HasTalent("special_enchant_ancients_chance") then
		return UF_FAIL_ANCIENT
	end

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		return UF_FAIL_FRIENDLY
	end

	if IsClient() then return end

	return UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber())
end


function enchantress_enchant_custom:GetCustomCastErrorTarget(target)
	if target:HasModifier("modifier_enchantress_enchant_controlled") then
		return "hud_error_enchant_cast_again"
	else
		return "hud_error_enchant_cast_level"
	end
end


function enchantress_enchant_custom:GetCurrentEnchantedUnitsCount()
	local count = 0

	local base_length = #self.enchanted_units

	-- iterating in REVERSE, because `remove` shifts table
	-- otherwise for every remove we'd be skipping next index
	for i = base_length, 1, -1 do
		local unit = self.enchanted_units[i]

		if IsValidEntity(unit) and unit:IsAlive() then
			count = count + 1
		else
			-- exclude invalid from index
			table.remove(self.enchanted_units, i)
		end
	end

	return count
end


function enchantress_enchant_custom:RemoveExcessiveUnits(current_unit_count, max_count)
	if current_unit_count < max_count then return end

	local removed = table.remove(self.enchanted_units, 1)
	removed:ForceKill(false)
end


function enchantress_enchant_custom:PrepareUnit(unit, duration, owner)
	unit:SetControllableByPlayer(owner:GetPlayerOwnerID(), false)
	unit:AddNewModifier(owner, self, "modifier_enchantress_enchant_controlled", {duration = duration})
	unit:AddNewModifier(owner, self, "modifier_dominated", {duration = duration})
	unit:AddNewModifier(owner, self, "modifier_kill", {duration = duration})

	local abilities_level = GetCreepAbilityLevel() + (self:GetSpecialValueFor("bonus_creep_level") or 0)

	for i = 0, 10 do
		local ability = unit:GetAbilityByIndex(i)
		if IsValidEntity(ability) then
			ability:SetLevel(abilities_level)
		end
	end

	table.insert(self.enchanted_units, unit)
end


function enchantress_enchant_custom:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	if target:TriggerSpellAbsorb(self) then return end

	-- Ability Values
	local dominate_duration = self:GetSpecialValueFor("dominate_duration")
	local slow_duration = self:GetSpecialValueFor("slow_duration")

	local max_units = self:GetSpecialValueFor("max_creeps")
	local current_enchanted_units = self:GetCurrentEnchantedUnitsCount()

	if (not target:IsConsideredHero() or target:IsIllusion()) and not target:HasModifier("modifier_vengefulspirit_hybrid_special") then
		self:RemoveExcessiveUnits(current_enchanted_units, max_units)

		target:Purge(true, true, false, false, false)
		target:RemoveModifierByName("modifier_chen_holy_persuasion")
		target:SetOwner(caster)
		target:SetTeam(caster:GetTeam())
		target:Heal(target:GetMaxHealth(), caster)

		self:PrepareUnit(target, dominate_duration, caster)
	elseif caster == target then
		self:RemoveExcessiveUnits(current_enchanted_units, max_units)

		local unit_name = table.random(self.JUNGLE_UNITS)

		local min_distance, max_distance = 140, 210
		local spawn_point = GetRandomPathablePositionWithin(caster:GetAbsOrigin(), max_distance, min_distance)
		spawn_point.z = 0

		local new_unit = CreateUnitByName(unit_name, spawn_point, false, caster, caster, caster:GetTeamNumber())
		FindClearSpaceForUnit(new_unit, spawn_point, true)

		self:PrepareUnit(new_unit, dominate_duration, caster)
	else
		target:Purge(true, false, false, false, false)	-- Basic dispel (just buffs)
		target:AddNewModifier(caster, self, "modifier_enchantress_enchant_slow", {duration = slow_duration * (1 - target:GetStatusResistance())})
	end

	caster:EmitSound("Hero_Enchantress.EnchantCast")
end
