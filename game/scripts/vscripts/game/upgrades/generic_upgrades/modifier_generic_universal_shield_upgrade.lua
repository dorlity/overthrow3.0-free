require("game/upgrades/generic_upgrades/modifier_base_shield_handler")
modifier_generic_universal_shield_upgrade = modifier_generic_universal_shield_upgrade or class(modifier_base_shield_handler)

function modifier_generic_universal_shield_upgrade:GetTexture() return "universal_shield" end


function modifier_generic_universal_shield_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT, -- GetModifierIncomingDamageConstant
	}
end


function modifier_generic_universal_shield_upgrade:GetModifierIncomingDamageConstant(event)
	return self:HandleShieldDamage(event)
end
