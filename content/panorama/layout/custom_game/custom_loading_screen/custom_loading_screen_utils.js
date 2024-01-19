const FindDotaHudElementInLS = (id) => dotaLoadingScreen.FindChildTraverse(id);
const dotaLoadingScreen = (() => {
	let panel = $.GetContextPanel();
	while (panel) {
		if (panel.id === "LoadingScreen") return panel;
		panel = panel.GetParent();
	}
})();

Math.clamp = function (num, min, max) {
	return this.min(this.max(num, min), max);
};
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
