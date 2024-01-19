require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_movement_speed_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_movement_speed_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("movement_speed")
end

function modifier_generic_movement_speed_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_movement_speed_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_movement_speed_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_generic_movement_speed_upgrade:GetModifierMoveSpeedBonus_Constant()
	return self.bonus
end
