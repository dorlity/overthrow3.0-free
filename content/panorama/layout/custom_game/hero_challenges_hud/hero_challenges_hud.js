const HUD = {
	CONTEXT: $.GetContextPanel(),
};

function MoveKillCamHUD() {
	const kill_cam_hud = FindDotaHudElement("KillCam");
	if (!kill_cam_hud) return void $.Schedule(1, MoveKillCamHUD);

	kill_cam_hud.style.marginTop = "230px";
	kill_cam_hud.style.backgroundColor = "transparent";
}

function OverrideCombatEvents() {
	const combat = FindDotaHudElement("combat_events");
	if (!combat) return void $.Schedule(1, OverrideCombatEvents);

	const default_margin_top = 395;
	const default_height = 385;
	const reduce = 90;

	combat.style.height = `${default_height - reduce}px`;
	combat.style.marginTop = `${default_margin_top + reduce}px`;
}

function CreateChallenges(data) {
	const b_has_challenge = !!data.active_challenge.id;
	HUD.CONTEXT.SetHasClass("BHasCustomHeroChallenge", b_has_challenge);

	if (!b_has_challenge) return;

	const challenge = data.active_challenge;

	MoveKillCamHUD();
	OverrideCombatEvents();
	HUD.CONTEXT.SwitchClass("custom_hero_challenge", `CustomChallengeDiff_${challenge.difficulty}`);
	SetChallengeProgress(challenge);
}
function SetChallengeProgress(challenge) {
	const is_completed = challenge.completed;
	HUD.CONTEXT.SetDialogVariable(
		"value",
		`<span class='${is_completed ? "ChallengeValue" : "ChallengeProgress"}'>${
			is_completed ? challenge.target : Math.floor(challenge.progress)
		}</span> / ${challenge.target}`,
	);
	HUD.CONTEXT.SetDialogVariable(
		"challenge_desc",
		$.Localize(`hero_challenges_${GetChallengeTypeName(challenge.challenge_type)}`, HUD.CONTEXT),
	);
	HUD.CONTEXT.SetHasClass("BChallengeCompleted", challenge.completed);
	if (is_completed) HUD.CONTEXT.AddClass("BMinimizeCustomChallenges");
}

function UpdateChallenge(data) {
	if (data.active_challenge && data.active_challenge.id) SetChallengeProgress(data.active_challenge);
}

function ToggleMinimizeChallenge() {
	HUD.CONTEXT.ToggleClass("BMinimizeCustomChallenges");
}

(function () {
	HUD.CONTEXT.SwitchClass("map_name", MAP_NAME);

	const frame = GameEvents.NewProtectedFrame(HUD.CONTEXT);
	frame.SubscribeProtected("HeroChallenges:set_challenges", CreateChallenges);
	frame.SubscribeProtected("HeroChallenges:update_progress", UpdateChallenge);

	GameEvents.SendToServerEnsured("HeroChallenges:get_challenges", {});
})();
