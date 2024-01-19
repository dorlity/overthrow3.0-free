function CDOTA_BaseNPC:HasTalent(talentName)
	if self and not self:IsNull() and self:HasAbility(talentName) then
		if self:FindAbilityByName(talentName):GetLevel() > 0 then return true end
	end

	return false
end


function CDOTA_BaseNPC:FindTalentValue(talentName, key)
	if self:HasAbility(talentName) then
		local value_name = key or "value"
		return self:FindAbilityByName(talentName):GetSpecialValueFor(value_name)
	end

	return 0
end


function CDOTA_BaseNPC:HasShard()
	return self:HasModifier("modifier_item_aghanims_shard")
end


function CDOTA_BaseNPC:GetClones()
	if self:GetUnitName() ~= "npc_dota_hero_meepo" then return {} end

	local clones = {}

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:IsClone() and hero:GetCloneSource() == self then
			table.insert(clones, hero)
		end
	end

	return clones
end


-- Update max health and current health accordingly
function CDOTA_BaseNPC:SetBaseMaxHealthUpdate(new_health)
	local current_health_pct = self:GetHealthPercent()

	self:SetBaseMaxHealth(new_health)

	Timers:CreateTimer(0.01, function()
		self:SetHealth(new_health * current_health_pct)
	end)
end


-- Get attack point accounting for a non 100 attack speed
function CDOTA_BaseNPC:GetRealAttackPoint()
	return self:GetAttackAnimationPoint() * 100 / self:GetDisplayAttackSpeed()
end


function CDOTA_BaseNPC:IsSpiritBear()
	return self:GetUnitLabel() == "spirit_bear"
end


function CDOTA_BaseNPC:DiscardNeutralItem()
	local neutral_item = self:GetItemInSlot(DOTA_ITEM_NEUTRAL_SLOT)
	if not IsValidEntity(neutral_item) then return end

	local item_entity_index = neutral_item:GetEntityIndex()

	ExecuteOrderFromTable({
		UnitIndex = self:GetEntityIndex(),
		OrderType = DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN,
		AbilityIndex = item_entity_index,
		Queue = false,
	})
end


function CDOTA_BaseNPC:IsMonkeyKingSoldier()
	return self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_monkey_king_fur_army_soldier_hidden")
end
