const CONTEXT = $.GetContextPanel();

(() => {
	const menu = FindDotaHudElement("ButtonBar");
	menu.style.flowChildren = `right-wrap`;
	menu.style.width = `${120 * CONTEXT.actualuiscale_y + 40}px`;

	menu.Children().forEach((button) => {
		button.style.margin = "0 5px";
		button.style.verticalAlign = "top";
	});

	CONTEXT.Children().forEach((button) => {
		const exist_button = menu.FindChild(button.id);
		if (exist_button) exist_button.DeleteAsync(0);
		button.SetParent(menu);
	});
	FindDotaHudElement("quickstats").style.marginTop = `${82}px`;
	FindDotaHudElement("spectator_quickstats").style.marginTop = `${77}px`;
})();
