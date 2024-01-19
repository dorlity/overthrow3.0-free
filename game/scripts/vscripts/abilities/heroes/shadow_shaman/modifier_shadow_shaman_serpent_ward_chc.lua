---@class modifier_shadow_shaman_serpent_ward_chc:CDOTA_Modifier_Lua
modifier_shadow_shaman_serpent_ward_chc = class({})


function modifier_shadow_shaman_serpent_ward_chc:IsHidden() return true end
function modifier_shadow_shaman_serpent_ward_chc:IsPurgable() return false end
function modifier_shadow_shaman_serpent_ward_chc:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_shadow_shaman_serpent_ward_chc:OnCreated(kv)
	self.parent = self:GetParent()
	self.team = self.parent:GetTeamNumber()
	self.pos = self.parent:GetAbsOrigin()

	local ability = self:GetAbility()

	if not ability then return end

	local caster = self:GetCaster()

	if not caster then return end

	self.bonus_attack_range = ability:GetSpecialValueFor("bonus_attack_range")
	self.scepter_split_count = ability:GetSpecialValueFor("scepter_split_count") - 1
end


function modifier_shadow_shaman_serpent_ward_chc:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end


function modifier_shadow_shaman_serpent_ward_chc:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_HEALTHBAR_PIPS, -- GetModifierHealthBarPips
	}

	local caster = self:GetCaster()

	if caster and caster:HasScepter() and IsServer() then
		table.insert(funcs, MODIFIER_PROPERTY_PRE_ATTACK)
		table.insert(funcs, MODIFIER_EVENT_ON_ATTACK_CANCELLED)
	end

	return funcs
end


function modifier_shadow_shaman_serpent_ward_chc:GetDisableHealing()
	return 1
end


function modifier_shadow_shaman_serpent_ward_chc:GetModifierHealthBarPips()
	return math.ceil(self.parent:GetMaxHealth() / 2)
end


function modifier_shadow_shaman_serpent_ward_chc:GetModifierAttackRangeBonus()
	return self.bonus_attack_range
end


function modifier_shadow_shaman_serpent_ward_chc:GetModifierPreAttack(event)
	if self.lock_attack_event then return end

	local attack_point = self.parent:GetRealAttackPoint()
	local record = event.record
	self.record = event.record

	Timers:CreateTimer(attack_point, function()
		self:OnAttackCompleted(record, event.target)
	end)
end


function modifier_shadow_shaman_serpent_ward_chc:OnAttackCancelled(event)
	if self.parent ~= event.attacker then return end
	self.record = nil
end


function modifier_shadow_shaman_serpent_ward_chc:OnAttackCompleted(record, original_target)
	if record ~= self.record then return end

	local targets = FindUnitsInRadius(
		self.team,
		self.pos,
		nil,
		self.parent:Script_GetAttackRange(),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_OTHER,
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
		FIND_ANY_ORDER,
		false
	)

	targets = table.shuffle(targets)

	local split_count_remaining = self.scepter_split_count

    for _, target in pairs(targets or {}) do
        if IsValidEntity(target) and target ~= original_target then
            self.lock_attack_event = true
            self.parent:PerformAttack(target, false, false, true, false, true, false, false)
            self.lock_attack_event = false

            split_count_remaining = split_count_remaining - 1
            if split_count_remaining <= 0 then break end
        end
    end
end




function modifier_shadow_shaman_serpent_ward_chc:GetModifierAvoidDamage(params)
	local health = self.parent:GetHealth()

	if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return 1
	end

	local damage = params.attacker:IsRealHero() and 2 or 1

	if health > damage then
		self.parent:SetHealth(health - damage)
	else
		self.parent:Kill(nil, params.attacker)
	end

	return 1
end


function modifier_shadow_shaman_serpent_ward_chc:GetUnitLifetimeFraction()
    return (self:GetDieTime() - GameRules:GetGameTime()) / self:GetDuration()
end


if IsClient() then return end

function modifier_shadow_shaman_serpent_ward_chc:OnDestroy()
	self:GetParent():ForceKill(false)
end
