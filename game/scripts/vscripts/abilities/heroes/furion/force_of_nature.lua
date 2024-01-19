furion_force_of_nature_custom = furion_force_of_nature_custom or class({})
LinkLuaModifier("modifier_force_of_nature_treant_lua", "abilities/heroes/furion/force_of_nature", LUA_MODIFIER_MOTION_NONE)


function furion_force_of_nature_custom:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect")
end


function furion_force_of_nature_custom:OnAbilityPhaseStart()
	self.position = self:GetCursorPosition()
	self.aoe = self:GetSpecialValueFor("area_of_effect")
	self.trees = GridNav:GetAllTreesAroundPoint(self.position, self.aoe, false)
	self.caster = self:GetCaster()
	if not self.caster or self.caster:IsNull() then return end

	if #self.trees == 0 then
		DisplayError(self.caster:GetPlayerID(), "dota_hud_error_cant_cast_on_non_tree")
		return false
	end

	return true
end

function furion_force_of_nature_custom:OnSpellStart()
	if not IsServer() then return end

	local treant_count = self:GetSpecialValueFor("treant_count")
	local duration = self:GetSpecialValueFor("duration")
	local treant_hp = self:GetSpecialValueFor("treant_hp")
	local treant_damage = self:GetSpecialValueFor("treant_damage")

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_force_of_nature_cast.vpcf", PATTACH_CUSTOMORIGIN, self.caster )
	ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_staff_base", self.caster:GetOrigin(), true )
	ParticleManager:SetParticleControl( particle, 1, self.position )
	ParticleManager:SetParticleControl( particle, 2, Vector( self.aoe, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( particle )

	GridNav:DestroyTreesAroundPoint(self.position, self.aoe, false)
	EmitSoundOnLocationWithCaster(self.position, "Hero_Furion.ForceOfNature", self.caster )

	for i = 1, treant_count do
		if i <= #self.trees then
			local treant = CreateUnitByName("npc_dota_furion_treant" , self.position, false, self.caster, self.caster, self.caster:GetTeamNumber())
			if treant and not treant:IsNull() then
				treant:AddNewModifier(self.caster, self, "modifier_phased", {duration = FrameTime()})
				treant:AddNewModifier(self.caster, self, "modifier_kill", {duration = duration})
				treant:AddNewModifier(self.caster, self, "modifier_force_of_nature_treant_lua", {duration = duration})
				treant:SetOwner(self.caster)
				treant:SetControllableByPlayer(self.caster:GetPlayerID(), true)

				treant:SetBaseMaxHealth(treant_hp)
				treant:SetMaxHealth(treant_hp)
				treant:SetHealth(treant_hp)
				treant:SetBaseDamageMin(treant_damage - 2)
				treant:SetBaseDamageMax(treant_damage + 2)
			end
		end
	end
end


-- orb upgrades for large treants are linked to regular treants
-- talent value for large treants is 1.5
function furion_force_of_nature_custom:GetLargeTreantHP()
	local large_treant_hp = self:GetSpecialValueFor("large_treant_hp")
	if self:GetCaster():HasTalent("special_bonus_unique_furion") then
		large_treant_hp = large_treant_hp * 1.5
	end
	return large_treant_hp
end


function furion_force_of_nature_custom:GetLargeTreantDamage()
	local large_treant_damage = self:GetSpecialValueFor("large_treant_damage")
	if self:GetCaster():HasTalent("special_bonus_unique_furion") then
		large_treant_damage = large_treant_damage * 1.5
	end
	return large_treant_damage
end



modifier_force_of_nature_treant_lua = modifier_force_of_nature_treant_lua or class({})

function modifier_force_of_nature_treant_lua:IsHidden() return true end
function modifier_force_of_nature_treant_lua:IsPurgable() return false end


function modifier_force_of_nature_treant_lua:OnCreated()
	local ability = self:GetAbility()
	if not IsValidEntity(ability) then return end

	self.movespeed = ability:GetSpecialValueFor("treant_movespeed")
end


function modifier_force_of_nature_treant_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE, -- GetModifierMoveSpeedOverride
	}
end


function modifier_force_of_nature_treant_lua:GetModifierMoveSpeedOverride()
	return self.movespeed or 300
end
