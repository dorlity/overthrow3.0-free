LinkLuaModifier ("modifier_devour_weakening_aura", "abilities/heroes/doom/devour_weakening_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_devour_weakening_aura_debuff", "abilities/heroes/doom/devour_weakening_aura", LUA_MODIFIER_MOTION_NONE)

if devour_weakening_aura == nil then
    devour_weakening_aura = class({})
end

function devour_weakening_aura:GetIntrinsicModifierName()
    return "modifier_devour_weakening_aura"
end


------------------------------------------------------------------------------

modifier_devour_weakening_aura = modifier_devour_weakening_aura or class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	IsAura	                = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})

function modifier_devour_weakening_aura:OnCreated()
	local ability = self:GetAbility()
	if not ability then return end

	self.radius = ability:GetSpecialValueFor("radius")
end

function modifier_devour_weakening_aura:OnRefresh()
	self:OnCreated()
end

function modifier_devour_weakening_aura:GetModifierAura()
    return "modifier_devour_weakening_aura_debuff"
end

function modifier_devour_weakening_aura:GetAuraRadius()
    return self.radius
end

function modifier_devour_weakening_aura:GetTexture()
    return "ancient_rock_golem_weakening_aura"
end

function modifier_devour_weakening_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_devour_weakening_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_devour_weakening_aura:GetAuraDuration()
    return 0.3
end

------------------------------------------------------------------------------

modifier_devour_weakening_aura_debuff = modifier_devour_weakening_aura_debuff or class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	AllowIllusionDuplicate	= function(self) return true end,
	IsPermanent             = function(self) return false end,
})

function modifier_devour_weakening_aura_debuff:GetTexture()
    return "ancient_rock_golem_weakening_aura"
end

function modifier_devour_weakening_aura_debuff:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_devour_weakening_aura_debuff:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return (-1) * self:GetAbility():GetSpecialValueFor("armor_reduction")
	else
		return 0
	end
end
