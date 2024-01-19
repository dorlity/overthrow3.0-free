require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_base_attack_damage_pct_upgrade = class(modifier_base_generic_upgrade)


function modifier_generic_base_attack_damage_pct_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("base_attack_damage_pct")
end


function modifier_generic_base_attack_damage_pct_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_base_attack_damage_pct_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_base_attack_damage_pct_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, -- GetModifierBaseDamageOutgoing_Percentage
	}
end


function modifier_generic_base_attack_damage_pct_upgrade:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end
