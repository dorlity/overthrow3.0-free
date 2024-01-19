modifier_no_collision = modifier_no_collision or class({})


function modifier_no_collision:IsHidden() return true end


function modifier_no_collision:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
