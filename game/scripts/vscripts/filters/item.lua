Filters.__has_locked_boots = {}

function Filters:ItemAddedToInventoryFilter(event)
	if not event.item_entindex_const then return true end
	if not event.inventory_parent_entindex_const then return true end

	local inventory_parent = EntIndexToHScript(event.inventory_parent_entindex_const)
	local item = EntIndexToHScript(event.item_entindex_const)

	if IsValidEntity(item) and IsValidEntity(inventory_parent) then
		local purchaser = item:GetPurchaser()

		if purchaser then
			if self:OrbAddedToInventoryFilter(item, inventory_parent) then return true end

			local purchaser_id = purchaser:GetPlayerID()
			local correct_inventory = inventory_parent:IsMainHero() or inventory_parent:GetClassname() == "npc_dota_lone_druid_bear" or inventory_parent:IsCourier()

			if (event.item_parent_entindex_const > 0) and item and correct_inventory then
				if not purchaser:CheckPersonalCooldown(item) then
					purchaser:RefundItem(item)
					return false
				end

				if not purchaser:IsMaxItemsForPlayer(item) then
					purchaser:RefundItem(item)
					return false
				end

				if item:GetAbilityName() == "item_boots" and WebSettings:GetSettingValue(purchaser_id, "lock_first_boots") and not Filters.__has_locked_boots[purchaser_id] then
					Filters.__has_locked_boots[purchaser_id] = true
					item:SetCombineLocked(true)
				end

				if not inventory_parent:IsInRangeOfShop(DOTA_SHOP_HOME, true) and item:ItemIsFastBuying(purchaser_id) then
					return item:TransferToBuyer(inventory_parent)
				end
			end
		end

		if not item.suggested_slot and not item:GetContainer() and item:IsNeutralDrop()
		and not inventory_parent:IsInRangeOfShop(DOTA_SHOP_HOME, true) and not inventory_parent:IsTempestDouble()
		and item:ItemIsFastBuying(inventory_parent:GetPlayerOwnerID()) then

			local free_slot = GetFreeSlotForNeutralItem(inventory_parent)
			if free_slot then

				local stash_slot = GetFreeStashSlot(inventory_parent)
				local swap_item

				-- Free first stash slot if we have no space in stash for item transfer
				if not stash_slot then
					swap_item = inventory_parent:GetItemInSlot(DOTA_STASH_SLOT_1)
					stash_slot = DOTA_STASH_SLOT_1
				end

				if swap_item then
					inventory_parent:TakeItem(swap_item)
				end

				event.suggested_slot = stash_slot

				Timers:CreateTimer(0, function()
					inventory_parent:SwapItems(item:GetItemSlot(), free_slot)

					-- Now return item back to stash
					if swap_item then
						swap_item.suggested_slot = DOTA_STASH_SLOT_1
						inventory_parent:AddItem(swap_item)
					end
				end)
			end
		end
	end

	if item.suggested_slot then
		event.suggested_slot = item.suggested_slot
		item.suggested_slot = nil
	end

	return true
end

local ORB_NAMES = {
	item_common_orb_ = "common",
	item_rare_orb_ = "rare",
	item_epic_orb_ = "epic",
}

function Filters:OrbAddedToInventoryFilter(item, hInventoryParent)
	local item_name = item:GetName()
	local purchaser = item:GetPurchaser()
	local owner_team = purchaser:GetTeam()
	local cost = tonumber(item:GetAbilityKeyValues().ItemCost)


	local orb_rarity
	for prefix, rarity in pairs(ORB_NAMES) do
		if string.find(item_name, prefix) then
			orb_rarity = rarity
			break
		end
	end

	if orb_rarity then
		local player_id = purchaser:GetPlayerOwnerID()
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero then
			hero.consumed_orbs_cost = (hero.consumed_orbs_cost or 0) + cost

			if hInventoryParent:IsCourier() then
				hero:SpendGold(cost, DOTA_ModifyGold_PurchaseConsumable)
			end
		end

		UTIL_Remove(item)
		EmitAnnouncerSoundForTeam("custom." .. orb_rarity .. "_orb", owner_team)
		Upgrades:QueueSelectionForTeam(owner_team, RARITY_TEXT_TO_ENUM[orb_rarity])
		EndGameStats:AddCapturedOrb(owner_team, ORB_CAPTURE_TYPE.SHOP, RARITY_TEXT_TO_ENUM[orb_rarity])

		CustomChat:MessageToTeam(player_id, PlayerResource:GetTeam(player_id), "orb_purchased_chat_message_" .. orb_rarity)

		return true
	end
end
