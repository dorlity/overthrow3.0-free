modifier_hidden_caster_dummy = class({})

function modifier_hidden_caster_dummy:IsPurgable() return false end
function modifier_hidden_caster_dummy:IsPermanent() return true end

function modifier_hidden_caster_dummy:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNTARGETABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] 	= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_OUT_OF_GAME] 		= true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
