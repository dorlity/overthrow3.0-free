warlock_golem_permanent_immolation_lua = class({})
LinkLuaModifier( "modifier_warlock_golem_permanent_immolation_lua", "abilities/heroes/warlock/golem_permanent_immolation", LUA_MODIFIER_MOTION_NONE )

function warlock_golem_permanent_immolation_lua:GetAOERadius()
	return self:GetSpecialValueFor("aura_radius") or 0
end

function warlock_golem_permanent_immolation_lua:GetIntrinsicModifierName()
	return "modifier_warlock_golem_permanent_immolation_lua"
end


------------------------------------------------------------------------------------------------------------------------------------------------


modifier_warlock_golem_permanent_immolation_lua = class({})

function modifier_warlock_golem_permanent_immolation_lua:IsHidden() return true end
function modifier_warlock_golem_permanent_immolation_lua:IsDebuff() return false end
function modifier_warlock_golem_permanent_immolation_lua:IsPurgable() return false end
function modifier_warlock_golem_permanent_immolation_lua:IsAura() return true end
function modifier_warlock_golem_permanent_immolation_lua:GetModifierAura() return "modifier_warlock_golem_permanent_immolation_debuff" end
function modifier_warlock_golem_permanent_immolation_lua:GetAuraRadius() return self.aura_radius end
function modifier_warlock_golem_permanent_immolation_lua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_warlock_golem_permanent_immolation_lua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_warlock_golem_permanent_immolation_lua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_warlock_golem_permanent_immolation_lua:GetAuraDuration() return 0.5 end

function modifier_warlock_golem_permanent_immolation_lua:OnCreated(kv)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	if not self.ability or self.ability:IsNull() then return end
	if not self.caster or self.caster:IsNull() then return end

	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_warlock_golem_permanent_immolation_lua:OnRefresh(kv)
	self:OnCreated(kv)
end
