-- NOTE: this filter is disabled
function Filters:ModifyGoldFilter(event)
	local player_id = event.player_id_const
	local hero = (player_id and PlayerResource:GetSelectedHeroEntity(player_id)) or nil

	return true
end
