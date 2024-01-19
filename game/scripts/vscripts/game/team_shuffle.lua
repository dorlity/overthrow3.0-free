ShuffleTeam = ShuffleTeam or class({})

function ShuffleTeam:Init()
	for team = 0, DOTA_TEAM_COUNT - 1 do
		local color = TEAM_COLORS[team]
		if color then
			SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
		end
	end

	local teams_layout = TEAMS_LAYOUTS[GetMapName()]

	for _, team in pairs(teams_layout.teamlist) do
		GameRules:SetCustomGameTeamMaxPlayers(team, teams_layout.player_count)
		GameLoop.current_kills_count[team] = 0
	end

	GameRules:SetCustomGameBansPerTeam(teams_layout.player_count)

	if DEV_ENABLE_SPECTATOR_TEAM == true then
		GameRules:SetCustomGameTeamMaxPlayers(1, 1)
		CustomNetTables:SetTableValue("game_options", "spectator_slots", {DEV_ENABLE_SPECTATOR_TEAM})
	end

	-- EventDriver:Listen("Events:state_changed", ShuffleTeam.ShuffleTeams, ShuffleTeam)
end

function ShuffleTeam:ShuffleTeams(state)
	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then return end
	print("shuffling")
	local teams_layout = TEAMS_LAYOUTS[GetMapName()]

	local parties = {}

	for player_id = 0, teams_layout.player_count * #teams_layout.teamList - 1 do
		local party_id = tonumber(tostring(PlayerResource:GetPartyID(player_id)))

		if party_id == 0 then
			party_id = player_id + 69420
		end

		if not parties[party_id] then
			parties[party_id] = {}
		end

		table.insert(parties[party_id], player_id)
	end

	--[[ Add - at the start of line to uncomment for testing
	parties = {{0}, {1}, {2}, {3}, {4, 5}, {6, 7, 8, 9}}
	ShuffleTeam.print_debug = true
	--]]

	-- Sort parties from biggest to smallest
	table.sort(parties, function(a,b)
		return #a > #b
	end)

	local teams = {}

	for _, i in pairs(teams_layout.teamlist) do
		local team_data = {}
		team_data.team_id = i
		team_data.player_count = 0
		table.insert(teams, team_data)
	end

	-- Randomise team order so the biggest party isn't always on teal, etc.
	teams = table.shuffled(teams)

	for party_id, party in pairs(parties) do
		table.sort(teams, function(a,b)
			return a.player_count < b.player_count
		end)

		for _, player_id in pairs(party) do
			-- If current team is full, start filling next most empty team
			if teams[1].player_count == teams_layout.player_count then
				table.sort(teams, function(a,b)
					return a.player_count < b.player_count
				end)
			end

			local team_id = teams[1].team_id

			if ShuffleTeam.print_debug then
				print("Setting Party, Player, Team:", party_id, player_id, team_id)
			end

			ShuffleTeam:SetPlayerTeam(player_id, team_id)

			teams[1].player_count = teams[1].player_count + 1
		end
	end
end

function ShuffleTeam:SetPlayerTeam(player_id, team_id)
	if not PlayerResource:GetPlayerLoadedCompletely(player_id) then
		Timers:CreateTimer(1, function()
			ShuffleTeam:SetPlayerTeam(player_id, team_id)
		end)

		return
	end
	local player = PlayerResource:GetPlayer(player_id)

	if player then
		player:SetTeam(team_id)
		PlayerResource:SetCustomTeamAssignment(player_id, team_id)
	end
end
