const LOCAL_PLAYER_ID = Game.GetLocalPlayerID();
const MAP_NAME = Game.GetMapInfo().map_display_name;

Object.values = function (object) {
	return Object.keys(object).map(function (key) {
		return object[key];
	});
};

Array.prototype.includes = function (searchElement, fromIndex) {
	return this.indexOf(searchElement, fromIndex) !== -1;
};

String.prototype.includes = function (searchString, position) {
	return this.indexOf(searchString, position) !== -1;
};

function SetInterval(callback, interval) {
	interval = interval / 1000;
	$.Schedule(interval, function reschedule() {
		$.Schedule(interval, reschedule);
		callback();
	});
}

function SubscribeToNetTableKey(tableName, key, callback) {
	var immediateValue = CustomNetTables.GetTableValue(tableName, key) || {};
	if (immediateValue != null) callback(immediateValue);
	CustomNetTables.SubscribeNetTableListener(tableName, function (_tableName, currentKey, value) {
		if (currentKey === key && value != null) callback(value);
	});
}

const FindDotaHudElement = (id) => dotaHud.FindChildTraverse(id);
const dotaHud = (() => {
	let panel = $.GetContextPanel();
	while (panel) {
		if (panel.id === "DotaHud") return panel;
		panel = panel.GetParent();
	}
})();

var useChineseDateFormat = $.Language() === "schinese" || $.Language() === "tchinese";
/** @param {Date} date */
function formatDate(date) {
	return useChineseDateFormat
		? date.getFullYear() + "-" + date.getMonth() + "-" + date.getDate()
		: date.getMonth() + "/" + date.getDate() + "/" + date.getFullYear();
}

let boostGlow = false;
let glowSchelude;
const CENTER_SCREEN_MENUS = ["CollectionDotaU"];

function _GetVarFromUniquePortraitsData(player_id, hero_name, path) {
	const unique_portraits = CustomNetTables.GetTableValue("game_state", "portraits");
	if (unique_portraits && unique_portraits[player_id]) {
		return `${path}${unique_portraits[player_id]}.png`;
	} else {
		return `${path}${hero_name}.png`;
	}
}

function GetPortraitImage(player_id, hero_name) {
	return _GetVarFromUniquePortraitsData(player_id, hero_name, "file://{images}/heroes/");
}
function GetPortraitIcon(player_id, hero_name) {
	return _GetVarFromUniquePortraitsData(player_id, hero_name, "file://{images}/heroes/icons/");
}

let colors_exceptions = {
	[-1]: "#ffffffff",
};
function GetHEXPlayerColor(player_id) {
	let player_color = Players.GetPlayerColor(player_id).toString(16);
	if (colors_exceptions[player_id]) player_color = colors_exceptions[player_id];

	return player_color == null
		? "#000000"
		: "#" +
				player_color.substring(6, 8) +
				player_color.substring(4, 6) +
				player_color.substring(2, 4) +
				player_color.substring(0, 2);
}

function LocalizeWithValues(line, kv) {
	let result = $.Localize(line);
	Object.entries(kv).forEach(([k, v]) => {
		result = result.replace(`%%${k}%%`, v);
	});
	return result;
}

function Stacktrace(name) {
	$.Msg(new Error(name).stack);
}
function FormatBigNumber(x) {
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function GetModifierStackCount(unit_index, m_name) {
	for (var i = 0; i < Entities.GetNumBuffs(unit_index); i++) {
		var buff_name = Buffs.GetName(unit_index, Entities.GetBuff(unit_index, i));
		if (buff_name == m_name) {
			return Buffs.GetStackCount(unit_index, Entities.GetBuff(unit_index, i));
		}
	}
}

JSON.print = (object) => {
	let result_string;
	try {
		result_string = JSON.stringify(
			object,
			(key, value) => {
				return value;
			},
			"	",
		);
	} catch (e) {
		$.Msg(e);
	}
	let result_array = result_string.split("\n");
	while (result_array.length) {
		$.Msg(result_array.splice(0, 50).join("\n"));
	}
};
Math.clamp = function (num, min, max) {
	return this.min(this.max(num, min), max);
};

Math.float_interpolate = function (min, max, float) {
	return Math.round(min + (max - min) * float);
};

const _default_context_for_localization = $.GetContextPanel();
if (!$.LocalizeEngine) {
	$.LocalizeEngine = $.Localize;
	$.Localize = function (text, panel) {
		if (typeof text == "number") text = Math.round(text).toString();

		if (!text.startsWith("#")) text = `#${text}`;

		const localizedText = $.LocalizeEngine(text, panel || _default_context_for_localization);
		if (localizedText == text) return text.substring(1);

		return localizedText;
	};
}

function FormatSeconds(v, b_hours) {
	let hours = 0;
	if (b_hours) {
		hours = Math.floor(v / 3600);
		v = v - 3600 * hours;
	}
	const minutes = Math.floor(v / 60);
	v = v - 60 * minutes;
	return `${b_hours ? hours.toString() + ":" : ""}${minutes.toString().padStart(2, "0")}:${Math.floor(v)
		.toString()
		.padStart(2, "0")}`;
}

function IsSpectating() {
	return (
		(Game.GetLocalPlayerInfo() &&
			Game.GetLocalPlayerInfo().player_team_id &&
			Game.GetLocalPlayerInfo().player_team_id == 1) ||
		!Game.GetLocalPlayerInfo()
	);
}

function Distance2D(A, B) {
	const x_diff = A[0] - B[0];
	const y_diff = A[1] - B[1];
	return Math.sqrt(x_diff * x_diff + y_diff * y_diff);
}

Game.GetTeamScore = function (team) {
	const nt = CustomNetTables.GetTableValue("game_state", "team_score");

	if (!nt || !nt[team]) return 0;

	return nt[team];
};

function _Notify(listeners_array, data) {
	// filter invalid callbacks out
	listeners_array = listeners_array.filter((item) => {
		return typeof item == "function";
	});
	for (const callback of listeners_array) {
		try {
			callback(data);
		} catch (e) {
			$.Msg("Error in _Notify: ", e);
		}
	}
}

String.prototype.format = function () {
	var args = arguments;
	return this.replace(/{(\d+)}/g, function (match, number) {
		return typeof args[number] != "undefined" ? args[number] : match;
	});
};

Object.fromEntries = (entries) => {
	let result_object = {};
	for (let [key, value] of entries) {
		result_object[key] = value;
	}
	return result_object;
};

Array.prototype.random = function () {
	return this[Math.floor(Math.random() * this.length)];
};

function BuildTooltipParams(object) {
	let array = [];
	Object.entries(object).forEach(([k, v]) => {
		if (k && v) {
			v = typeof v == "object" ? JSON.stringify(v) : v.toString();
			array.push(`${k.toString()}=${v}`);
		}
	});
	return array.join("&");
}

function RandomInt(min, max) {
	let rand = min + Math.random() * (max + 1 - min);
	return Math.floor(rand);
}

const UPGRADE_TYPE = {
	DEFAULT: 1,
	GENERIC: 2,
};
const RARITY = {
	COMMON: 1,
	RARE: 2,
	EPIC: 4,
};
const OPERATOR = {
	ADD: 1,
	MULTIPLY: 2,
};

function InferAbilityValue(ent_index, upgrade_data) {
	// FIXME: GetSpecialValue and GetLevelSpecialValueFor fetching values with upgrades applied
	// and there's no apparent way to get around this without sending base values from lua, which kinda sucks
	// for now special value is considered 0

	const ability_name = upgrade_data.ability_name;
	const upgrade_name = upgrade_data.upgrade_name;

	if (!ability_name) return 0;
	if (upgrade_name == "cooldown_and_manacost" || ability_name == "generic") return 0;

	const ability = Entities.GetAbilityByName(ent_index, ability_name);
	if (!ability || ability == -1) return 0;

	const value = Abilities.GetLevelSpecialValueFor(ability, upgrade_name, Abilities.GetLevel(ability));

	return value;
}

function CalculateUpgradeValue(ent_index, value, count, upgrade_data) {
	upgrade_data.operator = upgrade_data.operator || OPERATOR.ADD;
	let result = 0;
	let final_multiplier = 1;

	if (upgrade_data.talents && ent_index) {
		Object.entries(upgrade_data.talents).forEach(([talent_name, operation]) => {
			let operator, value;
			if (typeof operation == "number") {
				operator = "+";
				value = operation;
			} else {
				operator = operation.charAt(0);
				value = Number(operation.slice(1));
			}
			const talent = Entities.GetAbilityByName(ent_index, talent_name);
			if (Abilities.GetLevel(talent) > 0) {
				if (operator == "+") result += value;
				else if (operator == "x") final_multiplier *= value;
			}
		});
	}

	let upgrade_value = value * final_multiplier;

	if (upgrade_data.operator == OPERATOR.ADD) result += value * count;
	else if (upgrade_data.operator == OPERATOR.MULTIPLY) {
		let target = upgrade_data.multiplicative_target !== undefined ? upgrade_data.multiplicative_target : 100;
		result += upgrade_data.multiplicative_base_value || 0;

		const abs_upgrade_value = Math.abs(upgrade_value / (result - target));
		result = (target - result) * (1 - Math.pow(1 - abs_upgrade_value, count));
	}

	return isNaN(result) ? 0 : Math.round(result * 100) / 100;
}

Game.IsDemoMode = () => {
	return MAP_NAME == "ot3_demo";
};

function HasModifierByName(unit_ent_idx, name) {
	for (var i = 0; i < Entities.GetNumBuffs(unit_ent_idx); i++) {
		var buffName = Buffs.GetName(unit_ent_idx, Entities.GetBuff(unit_ent_idx, i));

		if (buffName == name) return true;
	}

	return false;
}

Entities.HasShard = function (unit) {
	return HasModifierByName(unit, "modifier_item_aghanims_shard");
};

function GetChildByPath(parent, ...child_path) {
	for (const id of child_path) {
		parent = parent.GetChild(id);
		if (!parent) return;
	}
	return parent;
}

Object.defineProperties(Object.prototype, {
	IsDOTAAbilityImage: {
		value: function () {
			return this.type === "DOTAAbilityImage";
		},
	},
	SetAbilityImage: {
		value: function (ability_entity_idx) {
			if (!this.IsDOTAAbilityImage()) return;

			const texture = Abilities.GetAbilityTextureName(ability_entity_idx || -1);
			if (texture) {
				this.SetImage("");
				this.style.backgroundSize = "100%";
				this.SetImage(`raw://resource/flash3/images/spellicons/${texture}.png`);

				let default_path = `url("s2r://panorama/images/spellicons/${texture}_png.vtex")`;

				this.style.backgroundImage = default_path;
			}
		},
	},
	SetAbilityImageToPlayer: {
		value: function (player_id, ability_name) {
			if (!this.IsDOTAAbilityImage()) return;

			this.abilityname = ability_name;

			const player_info = Game.GetPlayerInfo(player_id);
			if (!player_info) return;

			const hero_ent_idx = player_info.player_selected_hero_entity_index;
			if (!hero_ent_idx) return;

			this.SetAbilityImage(Entities.GetAbilityByName(hero_ent_idx, ability_name));
		},
	},
	SetAbilityImageToLocalHero: {
		value: function (ability_name) {
			if (!this.IsDOTAAbilityImage()) return;

			this.SetAbilityImageToPlayer(LOCAL_PLAYER_ID, ability_name);
		},
	},
});

function EscapeHTML(string) {
	return string.replace(
		/[&<>'"]/g,
		(tag) =>
			({
				"&": "&amp;",
				"<": "&lt;",
				">": "&gt;",
				"'": "&#39;",
				'"': "&quot;",
			}[tag] || tag),
	);
}
