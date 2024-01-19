modifier_undying_tombstone_intrinsic_lua = class({})

function modifier_undying_tombstone_intrinsic_lua:IsPurgable() return false end
function modifier_undying_tombstone_intrinsic_lua:IsHidden() return true end


function modifier_undying_tombstone_intrinsic_lua:OnCreated()
	self:OnRefresh()
end


function modifier_undying_tombstone_intrinsic_lua:OnRefresh()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.debuff_duration = self.ability:GetSpecialValueFor("slow_duration")
end


if not IsServer() then return end


function modifier_undying_tombstone_intrinsic_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
	}
end


function modifier_undying_tombstone_intrinsic_lua:OnDeath(params)
	if params.unit ~= self.parent then return end
	if self.parent:IsIllusion() then return end
	if params.unit:FindTalentValue("special_bonus_unique_undying_3") == 0 then return end
	if self.ability:GetLevel() == 0 then return end

	self.parent:SetCursorPosition(self.parent:GetAbsOrigin())
	self.ability:OnSpellStart()
end


function modifier_undying_tombstone_intrinsic_lua:GetModifierProcAttack_Feedback(params)
	if self.parent:IsIllusion() then return end
	if not self.parent:HasShard() then return end
	if not self.parent:HasModifier("modifier_undying_flesh_golem") then return end
	if self.ability:GetLevel() == 0 then return end

	self.ability:SpawnOrUpgradeZombie(params.target, self.parent)
end
