ChatWheel = ChatWheel or {
	votimer = {},
	vousedcol = {},
	heroes = {},
	blacklist_heroes = {},
	players_muted = {},
	chat_wheel_kv = LoadKeyValues("scripts/hero_chat_wheel_english.txt"),
}

require("game/chat_wheel/chat_wheel_data")
require("game/chat_wheel/chat_wheel")
