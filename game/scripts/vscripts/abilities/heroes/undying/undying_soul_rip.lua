undying_soul_rip_custom = undying_soul_rip_custom or class({})

function undying_soul_rip_custom:IsTargetTombstone(target)
	return target and target.GetClassname and target:GetClassname() == "npc_dota_unit_undying_tombstone"
end

function undying_soul_rip_custom:IsTargetZombie(target)
	return target and target.GetClassname and target:GetClassname() == "npc_dota_unit_undying_zombie"
end

function undying_soul_rip_custom:CastFilterResultTarget(target)
	if self:IsTargetTombstone(target) and target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return UF_SUCCESS
	elseif self:IsTargetZombie(target) then
		return UF_FAIL_CUSTOM
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function undying_soul_rip_custom:GetCustomCastErrorTarget(target)
	if self:IsTargetZombie(target) then
		return "#hud_error_undying_soul_rip_cannot_be_cast_on_zombies"
	end
end

function undying_soul_rip_custom:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if not caster or caster:IsNull() then return end
	if not target or target:IsNull() then return end

	if target:TriggerSpellAbsorb(self) then return end -- Cancel if linken

	local damage_per_unit = self:GetSpecialValueFor("damage_per_unit")
	local max_units = self:GetSpecialValueFor("max_units")
	local radius = self:GetSpecialValueFor("radius")
	local tombstone_heal = self:GetSpecialValueFor("tombstone_heal")

	caster:EmitSound("Hero_Undying.SoulRip.Cast")

	local hp_removal_damage_table = {
		--victim
		damage			= damage_per_unit,
		damage_type		= DAMAGE_TYPE_PURE,
		damage_flags	= DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, -- Putting reflection flag here in case of unwanted interactions
		attacker		= caster,
		ability			= self
	}

	local soul_rip_damage_table = {
		--victim
		--damage
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags	= DOTA_DAMAGE_FLAG_NONE,
		attacker		= caster,
		ability			= self
	}

	-- "Does not count Undying, the target, wards, buildings, invisible enemies and units in the Fog of War."
	-- "Spell immune allies are counted, including the zombies from Tombstone."
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local unit_counter = 0
	for _, unit in pairs(units) do
		if unit ~= caster and unit ~= target then
			local particle
			if target:GetTeamNumber() ~= caster:GetTeamNumber() then
				particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", PATTACH_POINT_FOLLOW, target)
			else
				particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_POINT_FOLLOW, target)
			end

			ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)

			-- "Units which require a certain amount of attacks to be killed do not lose health when counted in by Soul Rip."
			if self:IsTargetZombie(unit) then
				local modifier = unit:FindModifierByName("modifier_undying_tombstone_zombie")
				if modifier then
					local stacks = modifier:GetUpgradeStacks()
					if stacks then
						unit_counter = unit_counter + stacks
					end
				end
			else
				hp_removal_damage_table.victim = unit
				ApplyDamage(hp_removal_damage_table)
			end

			unit_counter = unit_counter + 1

			if unit_counter >= max_units then
				break
			end
		end
	end

	if unit_counter < 1 then return end

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		local heal = damage_per_unit * unit_counter
		if self:IsTargetTombstone(target) then
			heal = tombstone_heal
		end
		target:HealWithParams(heal, self, false, true, caster, false)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)
		target:EmitSound("Hero_Undying.SoulRip.Ally")
	else
		soul_rip_damage_table.victim = target
		soul_rip_damage_table.damage = damage_per_unit * unit_counter
		ApplyDamage(soul_rip_damage_table)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage_per_unit * unit_counter, nil)
		target:EmitSound("Hero_Undying.SoulRip.Enemy")
	end
end
