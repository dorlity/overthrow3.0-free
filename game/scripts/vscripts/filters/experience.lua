function Filters:FilterModifyExperience(event)
	local hero = event.hero_entindex_const and EntIndexToHScript(event.hero_entindex_const)

	if hero and hero.IsTempestDouble and hero:IsTempestDouble() then
		return false
	end

	return true
end
