require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_all_attributes_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_all_attributes_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("attributes")
end

function modifier_generic_all_attributes_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_all_attributes_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_all_attributes_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end


function modifier_generic_all_attributes_upgrade:GetModifierBonusStats_Strength()
	return self.bonus
end

function modifier_generic_all_attributes_upgrade:GetModifierBonusStats_Agility()
	return self.bonus
end

function modifier_generic_all_attributes_upgrade:GetModifierBonusStats_Intellect()
	return self.bonus
end
