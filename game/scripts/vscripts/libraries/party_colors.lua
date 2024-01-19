if PartyColors == nil then PartyColors = class({}) end

EventDriver:Listen("Events:state_changed", function(event)
	if event.state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		PartyColors:Activate()
	end
end)

function PartyColors:Activate()
	print("[PartyColors] setting a shared color for players in a party")

	local parties = {}
	local party_indexes = {}
	local party_members_count = {}
	local party_index = 1

	for id = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		if PlayerResource:IsValidPlayerID(id) then
			local party_id = tonumber(tostring(PlayerResource:GetPartyID(id)))
			if party_id and party_id > 0 then
				if not party_indexes[party_id] then
					party_indexes[party_id] = party_index
					party_index = party_index + 1
				end

				local party_index = party_indexes[party_id]
				parties[id] = party_index

				party_members_count[party_index] = party_members_count[party_index] or 0
				party_members_count[party_index] = party_members_count[party_index] + 1
			end
		end
	end

	for id, party in pairs(parties) do
		if party_members_count[party] and party_members_count[party] < 2 then -- Can't have a party with less than 2 people in it!
			parties[id] = nil
		end
	end

	DeepPrintTable(parties)

	if parties then
		CustomNetTables:SetTableValue("game_state", "parties", parties)
	end
end
