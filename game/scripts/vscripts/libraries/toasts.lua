Toasts = Toasts or class({})

function Toasts:NewForPlayer(player_id, toast_type, data)
	local player = PlayerResource:GetPlayer(player_id)
	if not IsValidEntity(player) then return end

	CustomGameEventManager:Send_ServerToPlayer(player, "Toasts:new", {
		toast_type = toast_type,
		data = data
	})
end


function Toasts:NewForTeam(team_id, toast_type, data)
	CustomGameEventManager:Send_ServerToTeam(team_id, "Toasts:new", {
		toast_type = toast_type,
		data = data
	})
end


function Toasts:NewForAll(toast_type, data)
	CustomGameEventManager:Send_ServerToAllClients("Toasts:new", {
		toast_type = toast_type,
		data = data,
	})
end
