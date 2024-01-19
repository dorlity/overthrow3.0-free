C_DOTA_Ability_Lua.ABILITY_KV = LoadKeyValues("scripts/npc/npc_abilities.txt")
table.merge(C_DOTA_Ability_Lua.ABILITY_KV, LoadKeyValues("scripts/npc/npc_abilities_custom.txt"))

function C_DOTA_Ability_Lua:GetUpgradeValueFor(value_name)
	if self.upgrade_values and self.upgrade_values[value_name] then return self.upgrade_values[value_name] end

	if not self.upgrade_name then
		local name = self:GetAbilityName()
		self.upgrade_name = name:gsub("modifier_", ""):gsub("_upgrade", "")
	end

	if not GENERIC_UPGRADES_DATA[self.upgrade_name] then return end

	self.upgrade_values = self.upgrade_values or {}

	self.upgrade_values[value_name] = GENERIC_UPGRADES_DATA[self.upgrade_name]["specials"][value_name]
	return self.upgrade_values[value_name]
end

-- function C_DOTA_Ability_Lua:GetKeyValueNoOverride(value_name, level)
function GetKeyValueNoOverride(ability, value_name, level)
	if not level then level = ability:GetLevel() end
	level = level + 1 -- level starts at 0, need to increment to work properly

	if C_DOTA_Ability_Lua.ABILITY_KV[ability:GetAbilityName()] then
		if C_DOTA_Ability_Lua.ABILITY_KV[ability:GetAbilityName()][value_name] and level then
			local s = string.split(C_DOTA_Ability_Lua.ABILITY_KV[ability:GetAbilityName()][value_name])

			if s[level] then
				return tonumber(s[level]) or s[level] -- Try to cast to number
			else
				return tonumber(s[#s]) or s[#s]
			end
		else
			return C_DOTA_Ability_Lua.ABILITY_KV[ability:GetAbilityName()][value_name]
		end
	else
		print("No kv found for ability:", ability:GetAbilityName())
		return
	end
end

-- Talent helpers
function C_DOTA_BaseNPC:HasTalent(talent_name)
	if not self or self:IsNull() then return end

	local talent = self:FindAbilityByName(talent_name)
	if talent and talent:GetLevel() > 0 then return true end
end


function C_DOTA_BaseNPC:FindTalentValue(talent_name, key)
	if self:HasTalent(talent_name) then
		local value_name = key or "value"
		return self:FindAbilityByName(talent_name):GetSpecialValueFor(value_name)
	end
	return 0
end

-- Automatically gets Ability special value with LinkedSpecialBonus talent if any
function C_DOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = C_DOTA_Ability_Lua.ABILITY_KV[self:GetName()]
	local operator = nil

	for k, v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l, m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]

					if m["LinkedSpecialBonusOperation"] then
						if m["LinkedSpecialBonusOperation"] == "SPECIAL_BONUS_MULTIPLY" then
							operator = "multiply"
						elseif m["LinkedSpecialBonusOperation"] == "SPECIAL_BONUS_SUBTRACT" then
							operator = "minus"
--						elseif m["LinkedSpecialBonusOperation"] == "SPECIAL_BONUS_PERCENTAGE_ADD" then
--							operator = "percent_add"
						end
					end

					break
				end
			end
		end
	end

	if talentName and self:GetCaster():HasModifier("modifier_"..talentName) then
		if operator == nil then
			base = base + self:GetCaster():FindTalentValue(talentName)
		elseif operator == "multiply" then
			base = base * self:GetCaster():FindTalentValue(talentName)
		elseif operator == "minus" then
			base = base - self:GetCaster():FindTalentValue(talentName)
--		elseif operator == "percent_add" then
--			base = base - self:GetCaster():FindTalentValue(talentName)
		end
	end

	return base
end

function CDOTA_Modifier_Lua:CheckUniqueValue(value, tSuperiorModifierNames)
	local hParent = self:GetParent()
	if tSuperiorModifierNames then
		for _,sSuperiorMod in pairs(tSuperiorModifierNames) do
			if hParent:HasModifier(sSuperiorMod) then
				return 0
			end
		end
	end
	if bit.band(self:GetAttributes(), MODIFIER_ATTRIBUTE_MULTIPLE) == MODIFIER_ATTRIBUTE_MULTIPLE then
		if self:GetStackCount() == 1 then
			return 0
		end
	end
	return value
end

function CDOTA_Modifier_Lua:CheckUnique(bCreated)
	return nil
end
