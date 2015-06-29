// 4 second impulse



local IMPULSE = {}

function IMPULSE.SECOND4()
	IMPULSE.LOCATIONS()
	for k,v in pairs(player.GetAll()) do
		IMPULSE.SWARM(k,v)
	end
end
hook.Add("Impulse_4Second","4Sec_Impulse",IMPULSE.SECOND4)


function IMPULSE.LOCATIONS()
	
	if !MISSION_LOCS then -- I dont want to run this every time
		if (GetRoundState() != ROUND_ACTIVE) then return end -- Call the first time the round is active
		MISSION_LOCS = {}

		local buffer = {} -- speed
		for i=1,4 do	
			MISSION_LOCS[i] = {}
			MISSION_LOCS[i] = ents.FindByClass(NEED_ENTS[i][1])
			buffer = ents.FindByClass(NEED_ENTS[i][2])
			table.Add(MISSION_LOCS[i],buffer)
			buffer = {}
		end
	else
		for i=1,4 do
			local ent = MISSION_LOCS[i][math.random( 1,table.Count(MISSION_LOCS[i]) )]
			local need_min, need_max = ent:WorldSpaceAABB()
			local need_pos = need_max - ((need_max - need_min) / 2)
			SetGlobalVector(NEED_ENTS[i][1], need_pos) --hurr durr
		end
	end

end


function IMPULSE.SWARM(k,v)
	if v:IsSwarm() && v:Team() == TEAM_GAME && v:Alive() then
		v:EmitSound(table.Random(Sounds.Swarm.Normal),400,100)
	end
end