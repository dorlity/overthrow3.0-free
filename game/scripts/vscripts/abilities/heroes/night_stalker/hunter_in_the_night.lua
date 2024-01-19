night_stalker_hunter_in_the_night_custom = class({})

function night_stalker_hunter_in_the_night_custom:GetIntrinsicModifierName()
	return "modifier_night_stalker_hunter_in_the_night"
end

function night_stalker_hunter_in_the_night_custom:GetBehavior()
	if self:GetCaster():HasShard() then return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function night_stalker_hunter_in_the_night_custom:GetCooldown(level)
	if self:GetCaster():HasShard() then
		return self:GetSpecialValueFor("shard_cooldown")
	end
end

function night_stalker_hunter_in_the_night_custom:GetCastRange(loc, target)
	if self:GetCaster():HasShard() then
		return self:GetSpecialValueFor("shard_cast_range")
	end
end

-- Cannot target Ancients
function night_stalker_hunter_in_the_night_custom:CastFilterResultTarget(target)
	if self:GetCaster() == target then return UF_SUCCESS end

	if IsServer() then
		if target:IsAncient() then
			if GameRules:IsDaytime() then		-- throws error on client
				return UF_FAIL_ANCIENT
			else
				return UF_SUCCESS
			end
		end
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, self:GetCaster():GetTeamNumber())
end

function night_stalker_hunter_in_the_night_custom:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	local heal_health = caster:GetMaxHealth() * self:GetSpecialValueFor("shard_hp_restore_pct") * 0.01
	local heal_mana = caster:GetMaxMana() * self:GetSpecialValueFor("shard_mana_restore_pct") * 0.01

	if caster == target then
		heal_health = heal_health * self:GetSpecialValueFor("shard_self_cast_pct") * 0.01
		heal_mana = heal_mana * self:GetSpecialValueFor("shard_self_cast_pct") * 0.01
	else
		target:Kill(self, caster)
	end

	caster:HealWithParams(heal_health, self, false, true, caster, false)
	caster:GiveMana(heal_mana)

	-- Play ability effects
	target:EmitSound("Hero_Nightstalker.Hunter.Target")

	local hunter_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_shard_hunter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(hunter_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(hunter_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(hunter_pfx)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, heal_health, nil)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, heal_mana, nil)
end
