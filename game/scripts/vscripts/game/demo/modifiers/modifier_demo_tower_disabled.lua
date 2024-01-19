modifier_demo_tower_disabled = modifier_demo_tower_disabled or class({})


function modifier_demo_tower_disabled:IsHidden() return true end
function modifier_demo_tower_disabled:IsPurgable() return false end


function modifier_demo_tower_disabled:CheckState()
	return {
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_CANNOT_TARGET_ENEMIES] = true,
	}
end
