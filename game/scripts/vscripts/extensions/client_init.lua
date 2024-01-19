require("extensions/string")
require("extensions/table")
require("extensions/math")
require("extensions/c_dota_modifier_lua")
require("extensions/c_dota_ability_lua")
require("extensions/c_dota_basenpc")

local OldGetMapName = _G.GetMapName
_G.GetMapName = function()
	local map_name, _ = OldGetMapName():gsub("maps/", ""):gsub(".vpk", "")
	return map_name
end
