require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_status_resistance_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_status_resistance_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("status_resistance")
end

function modifier_generic_status_resistance_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_status_resistance_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_status_resistance_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end


function modifier_generic_status_resistance_upgrade:GetModifierStatusResistanceStacking()
	return self.bonus
end
