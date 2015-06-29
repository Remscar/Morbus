// 15 second impulse


local IMPULSE = {}

function IMPULSE.SECOND20()
	if GetRoundState() == ROUND_ACTIVE then
		IMPULSE.SWARM_LIVES()
	end
end
hook.Add("Impulse_20second","20Sec_Impulse",IMPULSE.SECOND20)


function IMPULSE.SWARM_LIVES()
	Swarm_Respawns = Swarm_Respawns + 1
end