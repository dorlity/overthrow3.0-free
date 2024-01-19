require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_primary_attribute_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_primary_attribute_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("attributes")
end

function modifier_generic_primary_attribute_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_primary_attribute_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_primary_attribute_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end


function modifier_generic_primary_attribute_upgrade:GetModifierBonusStats_Strength()
	if self:GetPrimaryAttributeOfParent() == DOTA_ATTRIBUTE_STRENGTH then
		return self.bonus
	end
end

function modifier_generic_primary_attribute_upgrade:GetModifierBonusStats_Agility()
	if self:GetPrimaryAttributeOfParent() == DOTA_ATTRIBUTE_AGILITY then
		return self.bonus
	end
end

function modifier_generic_primary_attribute_upgrade:GetModifierBonusStats_Intellect()
	if self:GetPrimaryAttributeOfParent() == DOTA_ATTRIBUTE_INTELLECT then
		return self.bonus
	end
end
