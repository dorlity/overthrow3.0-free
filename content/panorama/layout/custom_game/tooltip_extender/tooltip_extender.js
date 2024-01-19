let ability_tooltip, default_scepter, default_shard, aghs_tooltips;
const HUD = {
	CONTEXT: $.GetContextPanel(),
	TEMP_CONTAINER: $("#TE_TempContainer"),
};
const custom_game_name = "Overthrow 3.0";

let AGHS_CONTAINERS = {
	Scepter: undefined,
	Shard: undefined,
};
let DEFAULT_ABILITY_HINTS = {
	Default: undefined,
	Scepter: undefined,
	Shard: undefined,
};

let last_ability_name, last_selected_portrait;
let cached_ability_name = "none";
let initialized = false;

function UpdateTooltip(event_name, panel, ability_name, force_local_hero, ...event_args) {
	let current_selected_portrait = Players.GetLocalPlayerPortraitUnit();
	if (force_local_hero) current_selected_portrait = Players.GetPlayerSelectedHero(LOCAL_PLAYER_ID);

	if (panel.te_lock) {
		panel.te_lock = false;
		return;
	}

	let is_has_hint = false;
	for (const [type, extender] of Object.entries(DEFAULT_ABILITY_HINTS)) {
		const hint_loc_key = `${ability_name}_CustomHint${type == "Default" ? "" : `_${type}`}`;
		let hint_loc = $.Localize(hint_loc_key);

		if (type == "Default" && hint_loc_key == hint_loc) {
			extender.visible = false;
			continue;
		}

		is_has_hint = true;

		if (type == "Scepter" || type == "Shard") {
			if (last_ability_name != ability_name || last_selected_portrait != current_selected_portrait) {
				extender.RemoveAndDeleteChildren();

				$.Schedule(0, () => {
					let default_container = type == "Scepter" ? default_scepter : default_shard;

					extender.SetHasClass(`Hidden`, default_container.BHasClass(`Hidden`));
					extender.SetHasClass(`NoUpgrade`, default_container.BHasClass(`NoUpgrade`));
					extender.SetHasClass(
						`Inline${type}Description`,
						default_container.BHasClass(`Inline${type}Description`),
					);

					for (const p of default_container.Children()) p.SetParent(extender);

					CreateDynamicAghHints(type, extender);

					panel.te_lock = true;
					last_ability_name = ability_name;
					last_selected_portrait = current_selected_portrait;
					$.DispatchEvent(event_name, ...event_args);
				});
			}
		} else extender.visible = true;

		hint_loc = GameUI.ReplaceDOTAAbilitySpecialValues(ability_name, hint_loc);

		extender.SetDialogVariable("te_custom_hint", hint_loc);
	}
	if (!is_has_hint) {
		last_ability_name = ability_name;
		last_selected_portrait = current_selected_portrait;
	}
}

function InitStaticTooltipExtender() {
	const tooltip_manager = FindDotaHudElement("Tooltips");
	if (!tooltip_manager) return;

	ability_tooltip = tooltip_manager.FindChildTraverse("DOTAAbilityTooltip");
	default_scepter = tooltip_manager.FindChildTraverse("ScepterUpgradeDescription");
	default_shard = tooltip_manager.FindChildTraverse("ShardUpgradeDescription");
	if (!ability_tooltip || !default_scepter || !default_shard) return;

	const ability_details = ability_tooltip.FindChildTraverse("AbilityDetails");
	const core_details = ability_details.FindChildTraverse("AbilityCoreDetails");

	const extra_info = core_details.FindChildTraverse("AbilityExtraDescription");
	if (!extra_info) return;

	const create_custom_agh_container = (type, default_container) => {
		const ex_container = core_details.FindChild(`CustomAghsDescription_${type}`);
		if (ex_container) ex_container.DeleteAsync(0);

		const container = $.CreatePanel("DOTAAghsDescription", core_details, `CustomAghsDescription_${type}`);
		core_details.MoveChildAfter(container, default_container);
		DEFAULT_ABILITY_HINTS[type] = container;
		default_container.visible = false;
	};
	create_custom_agh_container("Scepter", default_scepter);
	create_custom_agh_container("Shard", default_shard);

	const default_hint = $.CreatePanel("Panel", HUD.TEMP_CONTAINER, `TE_Static_Default`);
	default_hint.BLoadLayoutSnippet("TEB_AbilityHint");
	default_hint.SetDialogVariable("custom_game_name", custom_game_name);
	default_hint.SetDialogVariableLocString("te_header", `custom_ability_hint_Default`);

	const ex_default_hint = core_details.FindChildTraverse(`TE_Static_Default`);
	if (ex_default_hint) ex_default_hint.DeleteAsync(0);
	default_hint.SetParent(core_details);
	core_details.MoveChildAfter(default_hint, extra_info);

	DEFAULT_ABILITY_HINTS.Default = default_hint;

	initialized = true;
}

function CreateDynamicAghHints(type, container) {
	let b_has_upgrade = false;
	for (const tooltip_item of container.Children()) {
		if (!tooltip_item.BHasClass("InsetContainer")) continue;

		const ability_image = tooltip_item.FindChildTraverse("ScepterAbilityImage");
		const ability_name = ability_image.abilityname;

		const hint_loc_key = `${ability_name}_CustomHint_${type.toLowerCase()}`;
		let hint_loc = $.Localize(hint_loc_key);

		if (hint_loc_key != hint_loc && !hint_loc.startsWith("#")) {
			const focus_container = GetChildByPath(tooltip_item, 0, 1);
			const sort_child = focus_container.GetChild(1);

			const ex_te_scepter = focus_container.FindChildTraverse(`TE_${type}_${ability_name}`);
			if (ex_te_scepter) continue;

			b_has_upgrade = true;

			let te_scepter = $.CreatePanel("Panel", HUD.TEMP_CONTAINER, `TE_${type}_${ability_name}`);
			te_scepter.BLoadLayoutSnippet("TEB_AbilityHint");
			te_scepter.SetParent(focus_container);
			te_scepter.AddClass("AghHint");

			focus_container.MoveChildAfter(te_scepter, sort_child);
			te_scepter.SetDialogVariable("custom_game_name", custom_game_name);

			hint_loc = GameUI.ReplaceDOTAAbilitySpecialValues(ability_name, hint_loc);

			te_scepter.SetDialogVariable("te_custom_hint", hint_loc);
			te_scepter.SetDialogVariableLocString("te_header", `custom_ability_hint_${type}`);
		}
	}
	return b_has_upgrade;
}

function InitAghsTooltips() {
	aghs_tooltips = FindDotaHudElement("DOTAHUDAghsStatusTooltip");
	if (!aghs_tooltips) return void $.Schedule(0.5, InitAghsTooltips);

	const scepter_container = aghs_tooltips.FindChildTraverse("AghsScepterContainer");
	const shard_container = aghs_tooltips.FindChildTraverse("AghsShardContainer");

	if (!scepter_container || !shard_container) return void $.Schedule(0.5, InitAghsTooltips);

	AGHS_CONTAINERS.Scepter = scepter_container;
	AGHS_CONTAINERS.Shard = shard_container;
}

function OnAghsTooltip(panel, hero_id) {
	if (!AGHS_CONTAINERS.Scepter || !AGHS_CONTAINERS.Shard)
		return void $.Schedule(0.1, OnAghsTooltip.bind(undefined, panel, hero_id));
	if (panel.te_lock) {
		panel.te_lock = false;
		return;
	}

	$.Schedule(0, () => {
		aghs_tooltips.ClearPropertyFromCode("margin");
		aghs_tooltips.ClearPropertyFromCode("position");
		const scepter_upgarde = CreateDynamicAghHints("Scepter", AGHS_CONTAINERS.Scepter);
		const shard_upgrade = CreateDynamicAghHints("Shard", AGHS_CONTAINERS.Shard);

		panel.te_lock = true;
		$.DispatchEvent("DOTAHUDShowAghsStatusTooltip", panel, hero_id);
		$.Schedule(0, () => {
			if (!scepter_upgarde && !shard_upgrade) return;
			const pos = aghs_tooltips.GetPositionWithinWindow();
			const bottom_space = Game.GetScreenHeight() - aghs_tooltips.actuallayoutheight - pos.y;
			const extra_space = 100 - bottom_space;
			if (extra_space > 0) aghs_tooltips.style.marginTop = `-${extra_space}px`;
		});
	});
}

function OnAbilityTooltip(event_name, panel, ability_name, force_local_hero, ...event_args) {
	if (!initialized) {
		InitStaticTooltipExtender();
		return void $.Schedule(0.01, () =>
			OnAbilityTooltip(event_name, panel, ability_name, force_local_hero, ...event_args),
		);
	}

	UpdateTooltip(event_name, panel, ability_name, force_local_hero, ...event_args);
}

//P0 = panel idx
//P1 = ability_name idx
function RegisterDefaultTooltip(event_name, points, force_local_hero) {
	$.RegisterForUnhandledEvent(event_name, (...args) => {
		const panel = args[points[0]];
		const ability_name = args[points[1]];

		OnAbilityTooltip(event_name, panel, ability_name, force_local_hero, ...args);
	});
}

(function () {
	last_selected_portrait = Players.GetLocalPlayerPortraitUnit();
	InitAghsTooltips();
	HUD.TEMP_CONTAINER.RemoveAndDeleteChildren();
	RegisterDefaultTooltip("DOTAShowAbilityTooltip", [0, 1]);
	RegisterDefaultTooltip("DOTAShowAbilityTooltipForEntityIndex", [0, 1]);
	RegisterDefaultTooltip("DOTAShowAbilityShopItemTooltip", [0, 1], true);
	RegisterDefaultTooltip("DOTAShowDroppedItemTooltip", [0, 3], true);
	$.RegisterForUnhandledEvent("DOTAHUDShowAghsStatusTooltip", OnAghsTooltip);
})();
