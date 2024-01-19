local modifiers = {
	"modifier_invulnerable_custom",
	"modifier_event_proxy",
	"modifier_hidden_caster_dummy",
}

for _, modifier in pairs(modifiers) do
	LinkLuaModifier(modifier, "modifiers/" .. modifier, LUA_MODIFIER_MOTION_NONE)
end
