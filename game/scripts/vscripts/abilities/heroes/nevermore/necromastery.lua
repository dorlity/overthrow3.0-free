modifier_nevermore_necromastery_auto = modifier_nevermore_necromastery_auto or class({})

function modifier_nevermore_necromastery_auto:IsHidden() return true end
function modifier_nevermore_necromastery_auto:IsPurgable() return false end
function modifier_nevermore_necromastery_auto:RemoveOnDeath() return false end

function modifier_nevermore_necromastery_auto:OnCreated()
	if not IsServer() then return end
	self.init = false
	self.interval = 6.0

	self:StartIntervalThink(FrameTime())
end

function modifier_nevermore_necromastery_auto:OnIntervalThink()
	local maxSouls = 0
	local ability = self:GetParent():FindAbilityByName("nevermore_necromastery")

	if ability then
		if self.init == false and ability:GetLevel() > 0 then
			self.init = true
			self:StartIntervalThink(self.interval)
			return
		end

		if self:GetParent():HasScepter() then
			maxSouls = ability:GetSpecialValueFor("necromastery_max_souls_scepter")
		else
			maxSouls = ability:GetSpecialValueFor("necromastery_max_souls")
		end
	else
		return
	end

	local modifier = self:GetParent():FindModifierByName("modifier_nevermore_necromastery")

	if modifier and modifier:GetStackCount() < maxSouls then
		modifier:IncrementStackCount()
	end
end
