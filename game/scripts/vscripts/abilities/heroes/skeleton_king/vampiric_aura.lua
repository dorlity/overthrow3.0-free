modifier_skeleton_king_vampiric_aura_auto = modifier_skeleton_king_vampiric_aura_auto or class({})

function modifier_skeleton_king_vampiric_aura_auto:IsHidden() return true end
function modifier_skeleton_king_vampiric_aura_auto:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_auto:RemoveOnDeath() return false end

function modifier_skeleton_king_vampiric_aura_auto:OnCreated()
	if not IsServer() then return end
	self.init = false
	self.interval = 10.0

	self:StartIntervalThink(FrameTime())
end

function modifier_skeleton_king_vampiric_aura_auto:OnIntervalThink()
	local max_charges = 0
	local parent = self:GetParent()
	local ability = parent:FindAbilityByName("skeleton_king_vampiric_aura")

	if ability then
		if self.init == false and ability:GetLevel() > 0 then
			self.init = true
			self:StartIntervalThink(self.interval)
			return
		end
		max_charges = ability:GetSpecialValueFor("max_skeleton_charges") + parent:FindTalentValue("special_bonus_unique_wraith_king_5")
	else
		return
	end

	local modifier = parent:FindModifierByName("modifier_skeleton_king_vampiric_aura")

	if modifier and modifier:GetStackCount() < max_charges then
		modifier:IncrementStackCount()
	end
end
