function Filters:ExecuteOrderFilter(event)
	local order_type = event.order_type
	local player_id = event.issuer_player_id_const
	local target = event.entindex_target ~= 0 and EntIndexToHScript(event.entindex_target) or nil
	local ability = event.entindex_ability ~= 0 and EntIndexToHScript(event.entindex_ability) or nil
	local order_vector = Vector(event.position_x, event.position_y, event.position_z)

	if ability and not ability.GetAbilityName then ability = nil end
	local ability_name = ability and ability:GetAbilityName() or nil

	local unit
	if event.units and event.units["0"] then
		unit = EntIndexToHScript(event.units["0"])
	end

	-- to be sure, let all illusion orders through
	if unit and IsValidEntity(unit) and unit:IsIllusion() then return true end

	if DisableHelp.ExecuteOrderFilter(order_type, ability, target, unit, order_vector) == false then
		return false
	end

	if order_type == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION and ability and order_vector and event.queue == 0 then
		ability.vector_target_position = order_vector
	end

	-- Prevent couriers from picking up certain items
	if order_type == DOTA_UNIT_ORDER_PICKUP_ITEM and player_id ~= -1 then
		if not target or target:IsNull() or not target.GetContainedItem then return true end

		local target_item = target:GetContainedItem()
		if not target_item then return true end

		local item_name = target_item:GetAbilityName()

		if unit and unit:IsCourier() and item_name and COURIER_PICKUP_BLACKLIST[item_name] then
			local position = target:GetAbsOrigin()

			event["position_x"] = position.x
			event["position_y"] = position.y
			event["position_z"] = position.z
			event["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION

			return true
		end
	end

	-- Prevent from buying orbs from the wrong map
	if order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM and player_id ~= -1 and unit then
		if string.match(event.shop_item_name, "_ffa") and not string.match(GetMapName(), "_ffa") then return end
		if string.match(event.shop_item_name, "_duo") and not string.match(GetMapName(), "_duo") then return end
		if string.match(event.shop_item_name, "_quintet") and not string.match(GetMapName(), "_quintet") then return end
		if string.match(event.shop_item_name, "_octet") and not string.match(GetMapName(), "_octet") then return end
	end

	if order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
		if not target or target:IsNull() or not target.GetContainedItem then return true end

		local target_item = target:GetContainedItem()
		if not target_item or not target_item:IsNeutralDrop() then return true end

		local item_tier = NeutralItemDrop.neutral_item_list[ability_name]
		local unit_player_id = unit:GetPlayerOwnerID()
		local items_of_tier = NeutralItemDrop:CountNeutralItemsForPlayer(unit_player_id, item_tier)

		if items_of_tier >= MAX_NEUTRAL_ITEMS_PER_PLAYER then
			DisplayError(player_id, "#hud_error_neutral_item_restriction")
			return false
		end
	end

	if order_type == DOTA_UNIT_ORDER_GIVE_ITEM and IsValidEntity(ability) then
		local target_player_id = target:GetPlayerOwnerID()
		local unit_player_id = unit:GetPlayerOwnerID()
		local item_tier = NeutralItemDrop.neutral_item_list[ability_name]

		local items_of_tier = NeutralItemDrop:CountNeutralItemsForPlayer(target_player_id, item_tier)

		if target_player_id ~= unit_player_id and ability:IsNeutralDrop() and items_of_tier >= MAX_NEUTRAL_ITEMS_PER_PLAYER then
			DisplayError(player_id, "#hud_error_neutral_item_restriction")
			return false
		end
	end

	if order_type == DOTA_UNIT_ORDER_TAKE_ITEM_FROM_NEUTRAL_ITEM_STASH and IsValidEntity(unit) then
		local unit_player_id = unit:GetPlayerOwnerID()

		local item_tier = NeutralItemDrop.neutral_item_list[ability_name]
		local items_of_tier = NeutralItemDrop:CountNeutralItemsForPlayer(unit_player_id, item_tier)

		if items_of_tier >= MAX_NEUTRAL_ITEMS_PER_PLAYER then
			DisplayError(player_id, "#hud_error_neutral_item_restriction")
			return false
		end
	end

	if order_type == DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN then
		-- when item dropped on fountain, teleport to stash instead
		if IsValidEntity(unit) and IsValidEntity(ability) and ability:IsNeutralDrop() then
			local owner_player_id = unit:GetPlayerOwnerID()
			if not owner_player_id or unit ~= GameLoop.hero_by_player_id[owner_player_id] then
				print("non-main hero tried dropping neutral on fountain")
				return false
			end
			unit:TakeItem(ability)
			PlayerResource:AddNeutralItemToStash(player_id, unit:GetTeamNumber(), ability)
		else
			-- something is off, let order through
			return true
		end
		-- prevent default action
		return false
	end

	-- spawn the dark portal on the edge of the orb capture point
	if order_type == DOTA_UNIT_ORDER_CAST_POSITION and ability and ability_name == "abyssal_underlord_dark_portal" and IsValidEntity(unit) then
		local radius_buffered = OrbDropManager.capture_point_radius + 200

		-- find nearest epic spawn point within capture radius of a an order
		local nearest_epic_spawn_point = Entities:FindByClassnameNearest("path_track", order_vector, radius_buffered)

		if IsValidEntity(nearest_epic_spawn_point) then
			local spawn_point_origin = nearest_epic_spawn_point:GetAbsOrigin()

			local new_target_vector = spawn_point_origin + (order_vector - spawn_point_origin):Normalized() * radius_buffered

			event.position_x = new_target_vector.x
			event.position_y = new_target_vector.y

			DisplayError(player_id, "#dota_hud_error_cannot_cast_portal_near_epic_spawners")
		end

		return true
	end

	-- prevent swapping enemies into fountain
	if order_type == DOTA_UNIT_ORDER_CAST_TARGET and ability and ability_name == "vengefulspirit_nether_swap" and IsValidEntity(unit) then
		if unit and unit:HasModifier("modifier_fountain_rejuvenation_effect_lua") and target and target:GetTeamNumber() ~= unit:GetTeamNumber() then
			DisplayError(player_id, "#dota_hud_error_cannot_swap_enemy_into_fountain")
			return false
		end
	end

	return true
end
