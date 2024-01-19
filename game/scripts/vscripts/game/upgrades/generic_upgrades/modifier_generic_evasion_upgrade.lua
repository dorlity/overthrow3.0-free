require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_evasion_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_evasion_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("evasion")
end

function modifier_generic_evasion_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_evasion_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_evasion_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
end


function modifier_generic_evasion_upgrade:GetModifierEvasion_Constant()
	return self.bonus
end
