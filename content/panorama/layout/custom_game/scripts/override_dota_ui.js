function RemoveOT3Background() {
	var otBG = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("OT3BG");
	if (otBG) {
		otBG.DeleteAsync(0.1);
	}
}

function OverrideDotaNeutralItemsShop() {
	const shop_grid_1 = FindDotaHudElement("GridNeutralsCategory");
	if (!shop_grid_1) return;

	shop_grid_1.style.overflow = "squish scroll";

	shop_grid_1
		.FindChildTraverse("TeamNeutralItemsTierList")
		.Children()
		.forEach((panel) => {
			panel.FindChild("TierItemsList").style.flowChildren = "right-wrap";
		});
}

function MovePlayerPerformanceContainer() {
	const playerPerformanceContainer = FindDotaHudElement("player_performance_container");
	if (!playerPerformanceContainer) return;
	playerPerformanceContainer.style.marginTop = "13px";
}
function MoveMorphlingBar() {
	const player_info = Game.GetPlayerInfo(Game.GetLocalPlayerID());

	if (!player_info.player_selected_hero) return void $.Schedule(1, MoveMorphlingBar);
	if (player_info.player_selected_hero != "npc_dota_hero_morphling") return;

	const bar = FindDotaHudElement("MorphProgress");
	bar.style.marginLeft = "73px";
}

function UpdateFightRecap() {
	const fight_recap = FindDotaHudElement("FightRecap");
	fight_recap.style.marginTop = `${MAP_NAME == "ot3_necropolis_ffa" ? 75 : 50}px`;
}

(function () {
	// OverrideDotaNeutralItemsShop();
	RemoveOT3Background();
	MovePlayerPerformanceContainer();
	MoveMorphlingBar();
	UpdateFightRecap();
})();
