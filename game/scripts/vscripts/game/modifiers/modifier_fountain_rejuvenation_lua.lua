modifier_fountain_rejuvenation_lua = modifier_fountain_rejuvenation_lua or class({})
LinkLuaModifier("modifier_fountain_rejuvenation_effect_lua", "game/modifiers/modifier_fountain_rejuvenation_lua", LUA_MODIFIER_MOTION_NONE)

function modifier_fountain_rejuvenation_lua:IsHidden() return true end
function modifier_fountain_rejuvenation_lua:IsAura() return true end
function modifier_fountain_rejuvenation_lua:IsPurgable() return false end
function modifier_fountain_rejuvenation_lua:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_fountain_rejuvenation_lua:IsAura() return true end
-- tower attack range + DOTA_HULL_SIZE_TOWER = 850 (or per-map override) + 144 = 994
function modifier_fountain_rejuvenation_lua:GetAuraRadius() return self:GetParent():Script_GetAttackRange() + 144 end
function modifier_fountain_rejuvenation_lua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_fountain_rejuvenation_lua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_fountain_rejuvenation_lua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_fountain_rejuvenation_lua:GetModifierAura() return "modifier_fountain_rejuvenation_effect_lua" end


modifier_fountain_rejuvenation_effect_lua = modifier_fountain_rejuvenation_effect_lua or class({})


function modifier_fountain_rejuvenation_effect_lua:GetTexture() return "filler_ability" end

function modifier_fountain_rejuvenation_effect_lua:OnCreated()
	if IsClient() then return end

	local parent = self:GetParent()

	self:RefillBottle(parent)

	parent:Purge(false, true, false, true, true)

	-- this is a bit dirty, but better than listening to unit respawn in separate modifiers
	local shield_modifier = parent:FindModifierByName("modifier_generic_physical_shield_upgrade")
	if shield_modifier and not shield_modifier:IsNull() then shield_modifier:ResetShields() end

	local shield_modifier = parent:FindModifierByName("modifier_generic_magical_shield_upgrade")
	if shield_modifier and not shield_modifier:IsNull() then shield_modifier:ResetShields() end

	self:StartIntervalThink(0.5)
end

function modifier_fountain_rejuvenation_effect_lua:OnIntervalThink()
	local parent = self:GetParent()
	if not IsValidEntity(parent) then return end
	parent:Purge(false, true, false, true, true)

	self:RefillBottle(parent)
end

function modifier_fountain_rejuvenation_effect_lua:RefillBottle(target)
	local bottle = target:FindItemInInventory("item_bottle")
	if bottle and IsValidEntity(bottle) then
		bottle:SetCurrentCharges(3)
	end
end

function modifier_fountain_rejuvenation_effect_lua:CheckState()
	return {
		[MODIFIER_STATE_DEBUFF_IMMUNE] = true,
	}
end

function modifier_fountain_rejuvenation_effect_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, -- GetModifierHealthRegenPercentage
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE, -- GetModifierTotalPercentageManaRegen
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING, -- GetModifierStatusResistanceStacking
	}
end


function modifier_fountain_rejuvenation_effect_lua:GetModifierHealthRegenPercentage()
	return 25
end


function modifier_fountain_rejuvenation_effect_lua:GetModifierTotalPercentageManaRegen()
	return 25
end


function modifier_fountain_rejuvenation_effect_lua:GetModifierStatusResistanceStacking()
	return 50
end
