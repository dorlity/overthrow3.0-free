elder_titan_natural_order_lua = class({})
LinkLuaModifier("modifier_elder_titan_natural_order_lua", "abilities/heroes/elder_titan/elder_titan_natural_order", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elder_titan_natural_order_aura_magic_resistance_lua", "abilities/heroes/elder_titan/elder_titan_natural_order", LUA_MODIFIER_MOTION_NONE)


function elder_titan_natural_order_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius") or 0
end

function elder_titan_natural_order_lua:GetIntrinsicModifierName()
	return "modifier_elder_titan_natural_order_lua"
end

function elder_titan_natural_order_lua:GetAbilityTextureName()
	if self:GetCaster():GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		return "elder_titan_natural_order_spirit"
	end
	return "elder_titan_natural_order"
end


-----------------------------------------------------------------------------------------------------------------------------------------------------------


modifier_elder_titan_natural_order_lua = class({})

function modifier_elder_titan_natural_order_lua:IsHidden() return true end
function modifier_elder_titan_natural_order_lua:IsDebuff() return false end
function modifier_elder_titan_natural_order_lua:IsPurgable() return false end
function modifier_elder_titan_natural_order_lua:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_elder_titan_natural_order_lua:OnCreated(keys)
	if not IsServer() then return end
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	if not self.ability or self.ability:IsNull() then return end
	if not self.caster or self.caster:IsNull() then return end

	self.owner = self.caster
	if self.caster:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		self.owner = self.caster:GetOwner()
		self.ancestral_spirit = self.caster
	end
	if not self.owner or self.owner:IsNull() then return end

	if self.caster == self.ancestral_spirit then
		self.ancestral_spirit:AddNewModifier(self.owner, self.ability, "modifier_elder_titan_natural_order_aura_magic_resistance_lua", {})
		return
	end

	self.owner:AddNewModifier(self.owner, self.ability, "modifier_elder_titan_natural_order_aura_armor", {})
	self.owner:AddNewModifier(self.owner, self.ability, "modifier_elder_titan_natural_order_aura_magic_resistance_lua", {})
end

function modifier_elder_titan_natural_order_lua:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_elder_titan_natural_order_lua:OnDestroy()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	self.parent = self:GetParent()
	if not self.parent or self.parent:IsNull() then return end

	if self.parent:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		local owner_natural_order = self.owner:FindAbilityByName(self:GetAbility():GetAbilityName())
		if owner_natural_order then
			self.owner:AddNewModifier(self.owner, owner_natural_order, "modifier_elder_titan_natural_order_aura_magic_resistance_lua", {})
		end
	else
		self.parent:RemoveModifierByName("modifier_elder_titan_natural_order_aura_armor")
		self.parent:RemoveModifierByName("modifier_elder_titan_natural_order_aura_magic_resistance_lua")
	end
end

function modifier_elder_titan_natural_order_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
end

function modifier_elder_titan_natural_order_lua:OnAbilityExecuted(keys)
	if not IsServer() then return end
	if not self.caster or self.caster:IsNull() then return end
	if self.caster ~= keys.unit then return end
	if keys.ability:GetAbilityName() ~= "elder_titan_ancestral_spirit_lua" then return end	-- the spirit does not have this ability

	self.caster:RemoveModifierByName("modifier_elder_titan_natural_order_aura_magic_resistance_lua")
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------


-- valve broke the magic resist aura in 7.32 that's why there's a lua version of only one aura
modifier_elder_titan_natural_order_aura_magic_resistance_lua = class({})

function modifier_elder_titan_natural_order_aura_magic_resistance_lua:IsPurgable() return false end
function modifier_elder_titan_natural_order_aura_magic_resistance_lua:IsHidden() return true end

function modifier_elder_titan_natural_order_aura_magic_resistance_lua:IsAura() return true end
function modifier_elder_titan_natural_order_aura_magic_resistance_lua:GetAuraRadius() return self.radius end
function modifier_elder_titan_natural_order_aura_magic_resistance_lua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS end
function modifier_elder_titan_natural_order_aura_magic_resistance_lua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_elder_titan_natural_order_aura_magic_resistance_lua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_elder_titan_natural_order_aura_magic_resistance_lua:GetModifierAura() return "modifier_elder_titan_natural_order_magic_resistance" end

function modifier_elder_titan_natural_order_aura_magic_resistance_lua:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	if not self.ability or self.ability:IsNull() then return end
	if not self.caster or self.caster:IsNull() then return end

	self.owner = self.caster
	if self.caster:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" then
		self.owner = self.caster:GetOwner()
		self.ancestral_spirit = self.caster
	end
	if not self.owner or self.owner:IsNull() then return end

	-- precache owner stuff because kvs are changed only for the owner and not the spirit
	local owner_natural_order = self.owner:FindAbilityByName("elder_titan_natural_order_lua")
	if IsValidEntity(owner_natural_order) then
		self.radius = owner_natural_order:GetSpecialValueFor("radius") or 0
	end
end

function modifier_elder_titan_natural_order_aura_magic_resistance_lua:OnRefresh()
	self:OnCreated()
end
