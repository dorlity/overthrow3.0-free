local lastTimeBuyItemWithCooldown = {}
local maxItemsForPlayersData = {}
d_inventories = {}


-------------------------------------------------------------------------
local itemsCooldownForPlayer = {
}
-------------------------------------------------------------------------
local maxItemsForPlayers = {
}
-------------------------------------------------------------------------
local notFastItems = {
	["item_ward_observer"] = true,
	["item_ward_sentry"] = true,
	["item_smoke_of_deceit"] = true,
	["item_clarity"] = true,
	["item_flask"] = true,
	["item_greater_mango"] = true,
	["item_enchanted_mango"] = true,
	["item_tango"] = true,
	["item_faerie_fire"] = true,
	["item_tpscroll"] = true,
	["item_dust"] = true,
}
-------------------------------------------------------------------------
local fastItems = {
}
-------------------------------------------------------------------------

function CDOTA_BaseNPC:CheckPersonalCooldown(item)
	local buyerEntIndex = self:GetEntityIndex()
	local itemName = item:GetAbilityName()
	local unique_key = itemName .. "_" .. buyerEntIndex
	local playerID = self:GetPlayerID()

	if not itemsCooldownForPlayer[itemName] or item.isTransfer or not item:CheckMaxItemsForPlayer(unique_key) then return true end

	local playerCanBuyItem = lastTimeBuyItemWithCooldown[unique_key] == nil or ((GameRules:GetGameTime() - lastTimeBuyItemWithCooldown[unique_key]) >= itemsCooldownForPlayer[itemName])

	if playerCanBuyItem then
		lastTimeBuyItemWithCooldown[unique_key] = GameRules:GetGameTime()
		return true
	else
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "display_custom_error", { message = "#fast_buy_items" })
		return false
	end

	return true
end

-------------------------------------------------------------------------

function CDOTA_BaseNPC:IsMaxItemsForPlayer(item)
	local buyerEntIndex = self:GetEntityIndex()
	local itemName = item:GetAbilityName()
	local unique_key = itemName .. "_" .. buyerEntIndex
	local playerID = self:GetPlayerID()
	if not maxItemsForPlayers[itemName] or item.isTransfer then return true end

	local isPlayerBoughtMaxItems = item:CheckMaxItemsForPlayer(unique_key)

	if isPlayerBoughtMaxItems then
		maxItemsForPlayersData[unique_key] = maxItemsForPlayersData[unique_key] + 1
	else
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "display_custom_error", { message = "#you_cannot_buy_more_items_this_type" })
		return false
	end

	return true
end

-------------------------------------------------------------------------

function CDOTA_BaseNPC:RefundItem(item)
	self:ModifyGold(item:GetCost(), false, 0)
	UTIL_Remove(item)
end

-------------------------------------------------------------------------

function CDOTA_BaseNPC:DoesHeroHasFreeSlot()
	for i = 0, 15 do
		if self:GetItemInSlot(i) == nil then
			return i
		end
	end
	return false
end

-------------------------------------------------------------------------

function CDOTA_Item:ItemIsFastBuying(player_id)
	return fastItems[self:GetName()] or (WebPlayer:GetSubscriptionTier(player_id) > 0)
end

-------------------------------------------------------------------------

function CDOTA_Item:TransferToBuyer(unit)
	local buyer = self:GetPurchaser()
	local itemName = self:GetName()

	if notFastItems[itemName] or unit:IsIllusion() or self.isTransfer then
		return true
	end

	if not buyer:DoesHeroHasFreeSlot() then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(buyer:GetPlayerID()), "display_custom_error", { message = "#dota_hud_error_cant_purchase_inventory_full" })
		return false
	end

	self.isTransfer = true

	Timers:CreateTimer(0, function()

		if not IsValidEntity(self) then return end

		local itemBuyerInventory = (unit.IsCourier and unit:IsCourier() and unit) or buyer
		itemBuyerInventory:TakeItem(self)

		local container = self:GetContainer()
		if container then
			UTIL_Remove(container)
		end
		local was_locked = self:IsCombineLocked()
		self:SetCombineLocked(true)

		Timers:CreateTimer(0, function()
			if not IsValidEntity(self) then return end

			unit:TakeItem(self)
			if not was_locked then self:SetCombineLocked(false) end
			buyer:AddItem(self)
		end)
	end)
	return true
end

-------------------------------------------------------------------------

function CDOTA_Item:CheckMaxItemsForPlayer(unique_key)
	if not maxItemsForPlayers[self:GetAbilityName()] then return true end
	if not maxItemsForPlayersData[unique_key] then
		maxItemsForPlayersData[unique_key] = 1
	end
	return maxItemsForPlayersData[unique_key] <= maxItemsForPlayers[self:GetAbilityName()]
end

-------------------------------------------------------------------------
function CreateDummyInventoryForPlayer(playerId, unit)
	local old_d_inventory = GetDummyInventory(playerId)
	if old_d_inventory then
		old_d_inventory:Kill(nil, nil)
	end

	local startPointSpawn = unit:GetAbsOrigin() + (RandomFloat(100, 100))
	local dInventory = CreateUnitByName("npc_dummy_inventory", startPointSpawn, true, unit, unit, PlayerResource:GetTeam(playerId))
	dInventory:SetControllableByPlayer(playerId, true)
	dInventory:AddNewModifier(dInventory, nil, "modifier_dummy_inventory_custom", {duration = -1})
	dInventory:AddNoDraw()
	d_inventories[playerId] = dInventory
end
-------------------------------------------------------------------------
function CDOTA_BaseNPC:IsMonkeyClone()
	return (self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_wukongs_command_warrior"))
end
-------------------------------------------------------------------------
function CDOTA_BaseNPC:IsMainHero()
	return
		self and (not self:IsNull()) and self:IsRealHero() and not self:IsTempestDouble()
		and not self:IsMonkeyClone() and not self:IsClone() and not self:IsSpiritBear()
end
-------------------------------------------------------------------------
function GetDummyInventory(player_id)
	return d_inventories[player_id] or nil
end
