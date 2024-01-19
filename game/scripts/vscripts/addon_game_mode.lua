_G.GameMode = GameMode or {}

require("core_declarations")
require("precache")

require("extensions/init")
require("utils/init")
require("libraries/init")
require("filters/init")
require("events/init")
require("game/init")
require("modifiers/init")

function Activate()
	GameMode:Init()
end


function Precache(context)
	print("[GameMode] Precache started")
	PrecacheManager:Run(context)
	print("[GameMode] Precache finished")
end


function GameMode:Init()
	print("[GameMode] Init started")

	local seed = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(seed))

	local game_mode_entity = GameRules:GetGameModeEntity()
	game_mode_entity.GameMode = self

	GameLoop:Init()
	Events:Init()

	ShuffleTeam:Init()
	OrbDropManager:Init()
	Filters:Init()
	CustomChat:Init()
	Runes:Init()

	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetGoldPerTick(0)
	GameRules:SetShowcaseTime(0.0)
	GameRules:SetStrategyTime(0)
	GameRules:SetPreGameTime(PREGAME_TIME)
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:SetCustomGameSetupAutoLaunchDelay(3)
	GameRules:SetTreeRegrowTime(30)
	GameRules:SetStartingGold(700)

	Convars:SetInt("tv_delay", 10)

	game_mode_entity:SetLoseGoldOnDeath(false)
	game_mode_entity:SetFreeCourierModeEnabled(GetMapName() ~= "ot3_demo")
	game_mode_entity:SetPauseEnabled(IsInToolsMode())
	game_mode_entity:SetRandomHeroBonusItemGrantDisabled(true)
	game_mode_entity:SetCanSellAnywhere(true)
	game_mode_entity:SetUseTurboCouriers(true)

	if IsInToolsMode() then
		game_mode_entity:SetFixedRespawnTime(1)
		game_mode_entity:SetDraftingBanningTimeOverride(0)
		GameRules:SetCustomGameSetupAutoLaunchDelay(3)
	end

	if IsInToolsMode() or GetMapName() == "ot3_demo" then OT3Demo:Init(game_mode_entity) end

	EventDriver:Dispatch("GameMode:init_finished", {})

	print("[GameMode] Init finished")
end


function GameMode:IsDeveloper(player_id)
	local steam_id = tostring(PlayerResource:GetSteamID(player_id))

	return DEVELOPERS[steam_id] == true
end
