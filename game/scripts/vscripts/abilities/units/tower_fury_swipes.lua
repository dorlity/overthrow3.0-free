tower_fury_swipes = class({})
LinkLuaModifier( "modifier_tower_fury_swipes", "abilities/units/tower_fury_swipes", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_fury_swipes_debuff", "abilities/units/tower_fury_swipes", LUA_MODIFIER_MOTION_NONE )

function tower_fury_swipes:GetIntrinsicModifierName()
	return "modifier_tower_fury_swipes"
end


------------------------------------------------------------------------------------------------------------------------------------------


modifier_tower_fury_swipes = class({})


function modifier_tower_fury_swipes:IsHidden() return true end
function modifier_tower_fury_swipes:IsDebuff() return false end
function modifier_tower_fury_swipes:IsPurgable() return false end


function modifier_tower_fury_swipes:OnCreated(kv)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if not self.caster or self.caster:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.damage_per_stack = self.ability:GetSpecialValueFor("damage_per_stack")
	self.reset_time = self.ability:GetSpecialValueFor("reset_time")
end


function modifier_tower_fury_swipes:OnRefresh(kv)
	self:OnCreated(kv)
end


function modifier_tower_fury_swipes:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
	}
end


function modifier_tower_fury_swipes:GetOverrideAttackMagical() return 1 end


function modifier_tower_fury_swipes:GetModifierProcAttack_BonusDamage_Pure( params )
	if not IsServer() then return end
	if self.parent:PassivesDisabled() then return 0 end

	local target = params.target
	if not target or target:IsNull() or not target:IsAlive() then return 0 end
	if target:GetTeamNumber() == self.parent:GetTeamNumber() then return 0 end

	if target:IsCreep() or target:IsOther() then
		target:Kill(self.ability, self.parent)
		return 0
	end

	local stacks = 1
	local modifier = target:FindModifierByNameAndCaster("modifier_tower_fury_swipes_debuff", self:GetAbility():GetCaster())
	if modifier then
		stacks = modifier:GetStackCount()
	end
	local new_modifier = target:AddNewModifier(self.parent, self.ability, "modifier_tower_fury_swipes_debuff", { duration = self.reset_time })
	if new_modifier then
		stacks = stacks + 1
		new_modifier:SetStackCount(stacks)
	end

	target:EmitSound("DOTA_Item.SilverEdge.Target")
	target:AddNewModifier(self.parent, self.ability, "modifier_silver_edge_debuff", {duration = 1})

	return stacks * self.damage_per_stack
end


--------------------------------------------------------------------------------------------------------------------------------------------------


modifier_tower_fury_swipes_debuff = class({})


function modifier_tower_fury_swipes_debuff:IsHidden() return false end
function modifier_tower_fury_swipes_debuff:IsDebuff() return true end
function modifier_tower_fury_swipes_debuff:IsPurgable() return false end


function modifier_tower_fury_swipes_debuff:OnCreated( kv )
	self.ability = self:GetAbility()
	if not self.ability or self.ability:IsNull() then return end
	self.damage_per_stack = self.ability:GetSpecialValueFor("damage_per_stack")
end


function modifier_tower_fury_swipes_debuff:OnRefresh( kv )
	self:OnCreated(kv)
end


function modifier_tower_fury_swipes_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end


function modifier_tower_fury_swipes_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_tower_fury_swipes_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,

		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
end


function modifier_tower_fury_swipes_debuff:GetDisableHealing() return 1 end


function modifier_tower_fury_swipes_debuff:OnTooltip()
	return self:GetStackCount() * self.damage_per_stack
end
