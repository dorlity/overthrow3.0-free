-- Fired when hero loses item from inventory
function Events:OnInventoryItemChange(event)
	local item = EntIndexToHScript(event.item_entindex) ---@type CDOTA_Item
	local hero = EntIndexToHScript(event.hero_entindex) ---@type CDOTA_BaseNPC_Hero

	if not IsValidEntity(item) or not IsValidEntity(hero) or hero:IsIllusion() then return end
	if not event.removed and not event.dropped then print("discarded item change - not applicable to neutrals") return end

	local container = item:GetContainer()

	-- If item has container then it dropped to ground
	if item:IsNeutralDrop() and container and item:GetItemSlot() == -1 then
		AddNeutralItemToStashWithEffects(hero:GetPlayerOwnerID(), hero:GetTeam(), item)
	end
end
