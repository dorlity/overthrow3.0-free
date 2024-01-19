alchemist_goblins_greed_custom = alchemist_goblins_greed_custom or class({})


function alchemist_goblins_greed_custom:Spawn()
	if not IsServer() then return end
	if self._listener then return end

	self:SetLevel(1)

	self._listener = EventDriver:Listen("GameLoop:orb_captured", self.OnOrbCaptured, self)
end


function alchemist_goblins_greed_custom:OnOrbCaptured(event)
	if event.team ~= self:GetTeam() then return end

	local caster = self:GetCaster()

	local gold = self:GetSpecialValueFor("bonus_orb_gold") or 0
	PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold, true, 0)
	SendOverheadEventMessage(caster, OVERHEAD_ALERT_GOLD, caster, gold, nil)
end
