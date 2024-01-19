require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_manaburn_upgrade = class(modifier_base_generic_upgrade)


function modifier_generic_manaburn_upgrade:RecalculateBonusPerUpgrade()
	self.mana_burned = self:CalculateBonusPerUpgrade("mana_burned")
	self.burned_as_damage = self:GetUpgradeValueFor("fixed_burned_as_damage")
	self.illusion_pct = self:GetUpgradeValueFor("fixed_mana_burned_illusion_pct") / 100
end


function modifier_generic_manaburn_upgrade:OnCreated()
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_manaburn_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end


function modifier_generic_manaburn_upgrade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK, -- GetModifierProcAttack_Feedback
	}
end


function modifier_generic_manaburn_upgrade:GetModifierProcAttack_Feedback(params)
	local target = params.target
	if not IsValidEntity(target) then return end

	local parent = self:GetParent()
	if not IsValidEntity(parent) then return end

	local mana_burned = self.mana_burned
	if parent:IsIllusion() then mana_burned = mana_burned * self.illusion_pct end

	local actual_reduced = target:Script_ReduceMana(mana_burned, nil)

	ApplyDamage({
		victim = target,
		attacker = self:GetParent(),
		ability = self,
		damage = actual_reduced * self.burned_as_damage,
		damage_type = DAMAGE_TYPE_MAGICAL
	})

	-- do not play manaburn particle again if diffusals would do that anyway
	if not parent:HasItemInInventory("item_diffusal_blade") then
		local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end
end
