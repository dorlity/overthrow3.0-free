modifier_shadow_shaman_shackles_dummy_duration = class({})

function modifier_shadow_shaman_shackles_dummy_duration:IsHidden() return true end
function modifier_shadow_shaman_shackles_dummy_duration:IsPurgable() return false end

function modifier_shadow_shaman_shackles_dummy_duration:OnCreated()
	self.ability = self:GetAbility()
	if self.ability then self.ability.channel_duration = self:GetDuration() end
end

function modifier_shadow_shaman_shackles_dummy_duration:OnDestroy()
	if self.ability then self.ability.channel_duration = nil end
end
