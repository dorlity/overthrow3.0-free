require("game/upgrades/generic_upgrades/modifier_base_generic_upgrade")
modifier_generic_gpm_upgrade = class(modifier_base_generic_upgrade)

function modifier_generic_gpm_upgrade:RecalculateBonusPerUpgrade()
	self:CalculateBonusPerUpgrade("gpm")
	self:GetParent().gpm_bonus = self.bonus
end

function modifier_generic_gpm_upgrade:OnCreated()
	self:OnRefresh()
end

function modifier_generic_gpm_upgrade:OnRefresh(old_stack_count)
	self:RecalculateBonusPerUpgrade()
end
