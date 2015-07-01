/*----------------------------------------------------
END ROUND
----------------------------------------------------*/


function EndRound(type)

	print("Round Ending \n")

	RevealAll()

	if type == WIN_HUMAN then
		GameMsg("Humans have won")
		print("Humans have won")
	elseif type == WIN_ALIEN then
		GameMsg("Aliens have won")
		print("Aliens have won")
	end
	SetGlobalInt("morbus_winner",type)

	SANITY.RoundEnd()

	pcall(STATS.Send)
	

	SetRoundState(ROUND_POST)
	
	EndMutators()

	local ptime = GetConVar("morbus_round_post"):GetInt()
	timer.Create("end2prep", ptime, 1, PrepareRound)

	StopWinChecks()

	local rounds_left = math.max(0,GetGlobalInt("morbus_rounds_left",10)-1)
	SetGlobalInt("morbus_rounds_left", rounds_left)
	SetRoundEnd(CurTime() + ptime)

	if rounds_left < 1 then
		SendAll("Map is changing!")
		timer.Simple(12,function() hook.Call("Morbus_MapChange") end)
	else
		SendAll(rounds_left.." rounds until map change!")
	end

	--So mission timer doesn't go negative
	for k,v in pairs(player.GetAll()) do
		v:End_ClearMission() --There now stop bitching
		if !v.WantsSpec then
			v:SetTeam(TEAM_GAME)
		end
	end


	Send_RoundHistory()

end