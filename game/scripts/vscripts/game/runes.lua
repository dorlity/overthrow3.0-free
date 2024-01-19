Runes = Runes or {}

function Runes:Init()
	local game_mode_entity = GameRules:GetGameModeEntity()
	game_mode_entity:SetRuneEnabled(DOTA_RUNE_ARCANE, true)
end