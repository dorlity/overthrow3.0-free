modifier_hero_status_fx = class({})

function modifier_hero_status_fx:IsHidden() return true end
function modifier_hero_status_fx:IsPurgable() return false end
function modifier_hero_status_fx:RemoveOnDeath() return false end

function modifier_hero_status_fx:OnCreated(kv)
	self:SetHasCustomTransmitterData(true)

	if IsServer() then
		self.status_fx_name = kv.status_fx_name
		self:SendBuffRefreshToClients()
	end
end


function modifier_hero_status_fx:GetStatusEffectName()
	if self.status_fx_name then return self.status_fx_name end
end


function modifier_hero_status_fx:AddCustomTransmitterData()
	return {
		status_fx_name = self.status_fx_name
	}
end

function modifier_hero_status_fx:HandleCustomTransmitterData(data)
	self.status_fx_name = data.status_fx_name
end
