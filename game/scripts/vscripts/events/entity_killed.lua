function Events:OnEntityKilled(event)
	local killed = EntIndexToHScript(event.entindex_killed)
	local killer = EntIndexToHScript(event.entindex_attacker)
	local inflictor

	if event.entindex_inflictor then
		inflictor = EntIndexToHScript(event.entindex_inflictor)
	end

	EventDriver:Dispatch("Events:entity_killed", {
		killed = killed,
		killer = killer,
		inflictor = inflictor
	})
end
