require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_health_percentage_upgrade = class(modifier_base_generic_upgrade)


function modifier_generic_health_percentage_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("health_percentage")
end

function modifier_generic_health_percentage_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_health_percentage_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_health_percentage_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end


function modifier_generic_health_percentage_upgrade:GetModifierExtraHealthPercentage()
	return self.bonus
end
