modifier_kill_leader = class({})

function modifier_kill_leader:IsPurgable() return false end
function modifier_kill_leader:IsHidden() return true end
function modifier_kill_leader:RemoveOnDeath() return false end


function modifier_kill_leader:GetEffectName()
	return "particles/leader/leader_overhead.vpcf"
end


function modifier_kill_leader:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_kill_leader:ShouldUseOverheadOffset() return true end
