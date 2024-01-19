function CDOTA_Ability_Lua:GetUpgradeValueFor(value_name)
	if self.upgrade_values and self.upgrade_values[value_name] then return self.upgrade_values[value_name] end

	if not self.upgrade_name then
		local name = self:GetAbilityName()
		self.upgrade_name = name:gsub("modifier_", ""):gsub("_upgrade", "")
	end

	if not GenericUpgrades.generic_upgrades_data[self.upgrade_name] then return end

	self.upgrade_values = self.upgrade_values or {}

	self.upgrade_values[value_name] = GenericUpgrades.generic_upgrades_data[self.upgrade_name]["specials"][value_name]
	return self.upgrade_values[value_name]
end

-- Automatically gets Ability special value with LinkedSpecialBonus talent if any
function CDOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = self:GetAbilityKeyValues()
	for k,v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l,m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				end
			end
		end
	end
	if talentName then
		local talent = self:GetCaster():FindAbilityByName(talentName)
		if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
	end
	return base
end
