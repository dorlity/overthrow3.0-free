function CDOTAPlayerController:GetTeamNumber()
	local hero = self:GetAssignedHero()
	if hero then
		return hero:GetTeamNumber()
	end
end
