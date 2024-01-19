require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_health_regen_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_health_regen_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("health_regen")
end

function modifier_generic_health_regen_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_health_regen_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_health_regen_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end


function modifier_generic_health_regen_upgrade:GetModifierConstantHealthRegen()
	return self.bonus
end
