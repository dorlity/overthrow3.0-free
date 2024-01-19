function Events:OnItemPickUp(event)
	local item = EntIndexToHScript(event.ItemEntityIndex)
	local item_name = event.itemname
	local owner_entindex = event.HeroEntityIndex or event.UnitEntityIndex or nil
	local owner = (owner_entindex and EntIndexToHScript(owner_entindex)) or nil
end
