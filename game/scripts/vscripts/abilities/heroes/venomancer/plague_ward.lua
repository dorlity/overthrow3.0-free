-- Original code ported from Dota IMBA
-- Creator: AltiV
-- Editor: EarthSalamander
LinkLuaModifier("modifier_venomancer_plague_ward_custom_shard", "abilities/heroes/venomancer/plague_ward", LUA_MODIFIER_MOTION_NONE)

venomancer_plague_ward_custom = venomancer_plague_ward_custom or class({})

local shard_multiplier = 2

function venomancer_plague_ward_custom:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_venomancer_8")
end

function venomancer_plague_ward_custom:OnSpellStart(keys)
	if not IsServer() then return end
	local position = self:GetCursorPosition()
	local caster = self:GetCaster()

	if keys and keys.target_entindex then
		local target = EntIndexToHScript(keys.target_entindex)

		if target then
			position = target:GetAbsOrigin() + RandomVector(100)
		end
	else
		local spawn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(spawn_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(spawn_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(spawn_fx)
	end

	local multiplier = caster.venomous_gale_shard_flag and shard_multiplier or 1
	local plague_ward = CreateUnitByName("npc_dota_venomancer_plague_ward_"..math.min(self:GetLevel(), 4), position, true, caster, caster, caster:GetTeamNumber())
	plague_ward:EmitSound("Hero_Venomancer.Plague_Ward")

	plague_ward:SetForwardVector(caster:GetForwardVector())
	plague_ward:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetTalentSpecialValueFor("duration")})
	plague_ward:AddNewModifier(caster, self, "modifier_neutral_spell_immunity_visible", {duration = self:GetTalentSpecialValueFor("duration")})

	local ward_hp = self:GetSpecialValueFor("ward_hp_tooltip")
	local ward_damage = self:GetSpecialValueFor("ward_damage_tooltip")

	plague_ward:SetBaseMaxHealth(ward_hp * multiplier)
	plague_ward:SetMaxHealth(ward_hp * multiplier)
	plague_ward:SetHealth(ward_hp * multiplier)

	-- Modifications to damage is not possible due to weird valve stuff sticking to the ability's special value
	-- Multiplication is instead done in the shard modifier below.
	plague_ward:SetBaseDamageMin(ward_damage - 1)
	plague_ward:SetBaseDamageMax(ward_damage + 1)

	if caster.venomous_gale_shard_flag then
		plague_ward:AddNewModifier(caster, self, "modifier_venomancer_plague_ward_custom_shard", {})
	end

	if caster.GetPlayerID then
		plague_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	elseif caster:GetOwner() and caster:GetOwner().GetPlayerID then
		plague_ward:SetControllableByPlayer(caster:GetOwner():GetPlayerID(), true)
	end
end

modifier_venomancer_plague_ward_custom_shard = modifier_venomancer_plague_ward_custom_shard or class({})

function modifier_venomancer_plague_ward_custom_shard:IsHidden()
	return true
end

function modifier_venomancer_plague_ward_custom_shard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_venomancer_plague_ward_custom_shard:GetModifierBaseDamageOutgoing_Percentage()
	return (shard_multiplier - 1) * 100
end

function modifier_venomancer_plague_ward_custom_shard:GetModifierModelScale()
	return 50
end
