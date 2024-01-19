-- naming it PrecacheManager because plain `Precache` is a reserved function name for addon_game_mode entity
PrecacheManager = {}


PrecacheManager.particles = {
	"particles/leader/leader_overhead.vpcf",
	"particles/orb_common_christmas.vpcf",
	"particles/orb_rare_christmas.vpcf",
	"particles/orb_christmas.vpcf",
	"particles/orb_spree/orb_spree_shockwave.vpcf",
	"particles/epic_pathfinder.vpcf",

	"particles/econ/courier/courier_ti10/courier_flying_rad_ti10_cloud.vpcf"
}


PrecacheManager.soundevents = {
	"soundevents/soundevents_custom.vsndevts",
	"soundevents/custom_soundboard_soundevents.vsndevts",
	"soundevents/game_sounds_hero_demo.vsndevts",
}


function PrecacheManager:PrecacheWebInventory(context)
	if not ITEM_DEFINITIONS then print("[Precache Manager] no definitions on precache run!") return end
	for item_name, data in pairs(ITEM_DEFINITIONS or {}) do
		if data.particles then
			for _, particle_data in pairs(data.particles) do
				print("[Precache Manager] precaching particle", particle_data.path)
				PrecacheResource("particle", particle_data.path, context)
			end
		end
		if data.particle_variants then
			for _, particle_data in pairs(data.particle_variants) do
				print("[Precache Manager] precaching particle variant", particle_data.path)
				PrecacheResource("particle", particle_data.path, context)
			end
		end
		if data.blink_particles then
			if data.blink_particles.start_name then
				PrecacheResource("particle", data.blink_particles.start_name, context)
			end
			if data.blink_particles.end_name then
				PrecacheResource("particle", data.blink_particles.end_name, context)
			end
		end
	end
end


function PrecacheManager:Run(context)
	PrecacheManager:PrecacheWebInventory(context)

	for _, particle in pairs(PrecacheManager.particles) do
		print("[Precache] particle", particle)
		PrecacheResource("particle", particle, context)
	end

	for _, sound in pairs(PrecacheManager.soundevents) do
		print("[Precache] sound file", sound)
		PrecacheResource("soundfile", sound, context)
	end

	PrecacheUnitByNameSync("npc_dota_hero_target_dummy", context)
end
