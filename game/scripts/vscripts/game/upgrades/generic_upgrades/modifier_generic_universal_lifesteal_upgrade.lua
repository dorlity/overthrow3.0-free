require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_universal_lifesteal_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_universal_lifesteal_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("lifesteal")
end

function modifier_generic_universal_lifesteal_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end

function modifier_generic_universal_lifesteal_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


if not IsServer() then return end


function modifier_generic_universal_lifesteal_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end


function modifier_generic_universal_lifesteal_upgrade:GetModifierProcAttack_Feedback(params)
	if params.damage <= 0 then return end
	if not IsValidEntity(params.target) then return end
	if params.target:IsBuilding() then return end
	if params.target:IsOther() then return end

	local attacker = params.attacker
	local steal = params.damage * (self.bonus/100)

	attacker:HealWithParams(steal, attacker, true, true, attacker, false) -- this function still doesn't do its particle magic

	local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, params.attacker)
	ParticleManager:SetParticleControl(particle, 0, params.attacker:GetAbsOrigin())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, params.attacker, steal, nil)
end


function modifier_generic_universal_lifesteal_upgrade:OnTakeDamage(params)
	local parent = self:GetParent()
	if parent ~= params.attacker then return end
	if parent == params.unit then return end -- self-damage is not healed
	if params.damage <= 0 then return end
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	if params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then return end

	local steal = math.max(1, params.damage * ( self.bonus / 100))

	if params.unit and not params.unit:IsHero() then
		steal = 0.2 * steal
	end

	parent:HealWithParams(steal, params.inflictor, false, true, parent, true)

	local particle = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
	ParticleManager:SetParticleControl(particle, 0, parent:GetAbsOrigin())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, steal, nil)
end
