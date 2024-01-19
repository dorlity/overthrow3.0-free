-- For some reason the default invulnerable modifier is dispellable????

modifier_invulnerable_custom = modifier_invulnerable_custom or class({})

function modifier_invulnerable_custom:IsPurgable() return false end
function modifier_invulnerable_custom:IsPermanent() return true end

function modifier_invulnerable_custom:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		-- [MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
