function ChatWheel:Init()
	ChatWheel.players_muted = {
		Voice = {},
		Text = {},
	}
	for i = 0, 23 do
		ChatWheel.players_muted.Voice[i] = {}
		ChatWheel.players_muted.Text[i] = {}
	end

	EventStream:Listen("chat_wheel:select_vo", ChatWheel.SelectVO, ChatWheel)

	EventStream:Listen("chat_wheel:save", function(data)
		local player_id = data.PlayerID
		if not IsValidPlayerID(player_id) then return end

		WebSettings:SetSettingValue(player_id, "chat_wheel_favs", data.favourites)
	end)
	EventStream:Listen("update_mute_players", function(data)
		if data and data.PlayerID and data.players then
			local from_id = data.PlayerID
			for target_id, b_voice_muted in pairs(data.players) do
				ChatWheel.players_muted[data.type][from_id][target_id] = b_voice_muted == 1
			end
		end
	end)
end

function ChatWheel:SelectVO(keys)
	if not keys.num then return end

	local selectedid = 1
	local selectedid2 = nil
	local selectedstr = nil
	local startheronums = 110

	if keys.num >= startheronums then
		local locnum = keys.num - startheronums
		local mesarrs = {
			"_laugh",
			"_thank",
			"_deny",
			"_1",
			"_2",
			"_3",
			"_4",
			"_5"
		}

		selectedstr = ChatWheel.heroes[math.floor(locnum / 8) + 1] .. mesarrs[math.fmod(locnum, 8) + 1]
		selectedid = math.floor(locnum / 8) + 2
		selectedid2 = math.fmod(locnum, 8) + 1
	else
		if keys.num < (startheronums - 8) then
			local mesarrs = {
				--dp1
				"Applause",
				"Crash_and_Burn",
				"Crickets",
				"Party_Horn",
				"Rimshot",
				"Charge",
				"Drum_Roll",
				"Frog",
				--dp2
				"Headshake",
				"Kiss",
				"Ow",
				"Snore",
				"Bockbock",
				"Crybaby",
				"Sad_Trombone",
				"Yahoo",
				--misc
				"",
				"Sleighbells",
				"Sparkling_Celebration",
				"Greevil_Laughter",
				"Frostivus_Magic",
				"Ceremonial_Drums",
				"Oink_Oink",
				"Celebratory_Gong",
				--en an
				"patience",
				"wow",
				"all_dead",
				"brutal",
				"disastah",
				"oh_my_lord",
				"youre_a_hero",
				--en an2
				"that_was_questionable",
				"playing_to_win",
				"what_just_happened",
				"looking_spicy",
				"no_chill",
				"ding_ding_ding",
				"absolutely_perfect",
				"lets_play",
				--ch an
				"duiyou_ne",
				"wan_bu_liao_la",
				"po_liang_lu",
				"tian_huo",
				"jia_you",
				"zou_hao_bu_song",
				"liu_liu_liu",
				--ch an2
				"hu_lu_wa",
				"ni_qi_bu_qi",
				"gao_fu_shuai",
				"gan_ma_ne_xiong_di",
				"bai_tuo_shei_qu",
				"piao_liang",
				"lian_dou_xiu_wai_la",
				"zai_jian_le_bao_bei",
				--ru an
				"bozhe_ti_posmotri",
				"zhil_do_konsta",
				"ay_ay_ay",
				"ehto_g_g",
				"eto_prosto_netchto",
				"krasavchik",
				"bozhe_kak_eto_bolno",
				--ru an2
				"oy_oy_bezhat",
				"eto_nenormalno",
				"eto_sochno",
				"kreasa_kreasa",
				"kak_boyge_te_byechenya",
				"eto_ge_popayx_feeda",
				"da_da_da_nyet",
				"wot_eto_bru",
				--bp19
				"kooka_laugh",
				"monkey_biz",
				"orangutan_kiss",
				"skeeter",
				"crowd_groan",
				"head_bonk",
				"record_scratch",
				"ta_da",
				--epic
				"easiest_money",
				"echo_slama_jama",
				"next_level",
				"oy_oy_oy",
				"ta_daaaa",
				"ceeb",
				"goodness_gracious",
				--epic2
				"nakupuuu",
				"whats_cooking",
				"eughahaha",
				"glados_chat_21",
				"glados_chat_01",
				"glados_chat_07",
				"glados_chat_04",
				"",
				--kor cas
				"kor_yes_no",
				"kor_scan",
				"kor_immortality",
				"kor_roshan",
				"kor_yolo",
				"kor_million_dollar_house",
				"",
				"",
			}
			selectedstr = mesarrs[keys.num]
			selectedid2 = keys.num
		else
			local locnum = keys.num - (startheronums - 8)
			local player = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
			if not IsValidEntity(player) then return end
			local nowheroname = string.sub(player:GetName(), 15)
			local mesarrs = {
				"_laugh",
				"_thank",
				"_deny",
				"_1",
				"_2",
				"_3",
				"_4",
				"_5"
			}
			local herolocid = 2
			for i=1, #ChatWheel.heroes do
				if nowheroname == ChatWheel.heroes[i] then
					break
				end
				herolocid = herolocid + 1
			end
			selectedstr = nowheroname .. mesarrs[locnum + 1]
			selectedid = herolocid
			selectedid2 = locnum + 1
		end
	end

	if selectedstr and selectedid2 then

		if ChatWheel.vousedcol[keys.PlayerID] == nil then ChatWheel.vousedcol[keys.PlayerID] = 0 end

		if ChatWheel.votimer[keys.PlayerID] then
			if GameRules:GetGameTime() - ChatWheel.votimer[keys.PlayerID] > 5 + ChatWheel.vousedcol[keys.PlayerID] then
				ChatSound(ChatWheel.heroesvo[selectedid][selectedid2], keys.PlayerID)
				CustomChat:MessageToAll(keys.PlayerID, ChatWheel.chat_wheel_kv["dota_chatwheel_message_"..selectedstr])

				ChatWheel.votimer[keys.PlayerID] = GameRules:GetGameTime()
				ChatWheel.vousedcol[keys.PlayerID] = ChatWheel.vousedcol[keys.PlayerID] + 1
			else
				local remaining_cd = string.format("%.1f", 5 + ChatWheel.vousedcol[keys.PlayerID] - (GameRules:GetGameTime() - ChatWheel.votimer[keys.PlayerID]))
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID), "display_custom_error_with_value", {
					message = "#wheel_cooldown",
					values = {
						["sec"] = remaining_cd,
					},
				})
			end
		else
			ChatSound(ChatWheel.heroesvo[selectedid][selectedid2], keys.PlayerID)
			CustomChat:MessageToAll(keys.PlayerID, ChatWheel.chat_wheel_kv["dota_chatwheel_message_"..selectedstr])

			ChatWheel.votimer[keys.PlayerID] = GameRules:GetGameTime()
			ChatWheel.vousedcol[keys.PlayerID] = ChatWheel.vousedcol[keys.PlayerID] + 1
		end
	end
end

function ChatSound(phrase, source_player_id)
	local all_heroes = HeroList:GetAllHeroes()

	for _, hero in pairs(all_heroes) do
		if hero:IsRealHero() and hero:IsControllableByAnyPlayer() then
			local player_id = hero:GetPlayerOwnerID()

			if player_id and not ChatWheel.players_muted.Voice[player_id][tostring(source_player_id)] then
				local player = PlayerResource:GetPlayer(player_id)
				CustomGameEventManager:Send_ServerToPlayer(player, "chat_wheel:emit_sound", {
					sound = phrase
				})

				if phrase == "soundboard.ceb.start" then
					Timers:CreateTimer(2, function()
						StopGlobalSound("soundboard.ceb.start")
						CustomGameEventManager:Send_ServerToPlayer(player, "chat_wheel:emit_sound", {
							sound = "soundboard.ceb.stop"
						})
					end)
				end
			end
		end
	end
end


ChatWheel:Init()
