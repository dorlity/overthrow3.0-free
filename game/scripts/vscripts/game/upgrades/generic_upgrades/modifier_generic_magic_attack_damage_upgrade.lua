require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_magic_attack_damage_upgrade = class(modifier_base_generic_upgrade)


function modifier_generic_magic_attack_damage_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("magic_attack_damage")
end


function modifier_generic_magic_attack_damage_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_magic_attack_damage_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_magic_attack_damage_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, -- GetModifierProcAttack_BonusDamage_Magical
	}
end


function modifier_generic_magic_attack_damage_upgrade:GetModifierProcAttack_BonusDamage_Magical(params)
	if IsValidEntity(params.target) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, self.bonus, nil)
	end
	return self.bonus
end
