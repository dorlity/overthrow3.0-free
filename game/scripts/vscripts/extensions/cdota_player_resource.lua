function CDOTA_PlayerResource:IsBotOrPlayerConnected(player_id)
	local connection_state = self:GetConnectionState(player_id)
	return (connection_state == DOTA_CONNECTION_STATE_CONNECTED or connection_state == DOTA_CONNECTION_STATE_NOT_YET_CONNECTED) and not PlayerDC.has_abandoned[player_id]
end

function CDOTA_PlayerResource:HasPlayerAbandoned(player_id)
	local connection_state = self:GetConnectionState(player_id)
	return connection_state == DOTA_CONNECTION_STATE_ABANDONED
end
