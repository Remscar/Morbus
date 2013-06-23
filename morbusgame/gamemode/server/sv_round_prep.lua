/*----------------------------------------------------
PREPARE ROUND
----------------------------------------------------*/


function SpawnPlayers(dead)

	for k, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			RequestAllGlobals(ply)
			ply:SpawnForRound(dead)
		end
	end
end


local function SpawnEntities()
	local et = ents.MORBUS

	local import = et.CanImportEntities(game.GetMap())

	if import then
      et.ProcessImportScript(game.GetMap())
    else
      et.ReplaceEntities()
    end


	SpawnPlayers()
	MuteForRestart(false)
end



local function CleanUp()
	local et = ents.MORBUS
	MISSION_LOCS = nil
	game.CleanUpMap()

	et.SetReplaceChecking(not et.CanImportEntities(game.GetMap()))
	et.FixParentedPreCleanup()
	et.FixParentedPostCleanup()
    

	  for k,v in pairs(player.GetAll()) do
      if IsValid(v) then
        v:StripWeapons()
      	end
	  end
end




function PrepareRound()
	RunConsoleCommand("sv_tags","Morbus"..GM_VERSION_SHORT)

	if CheckForAbort() then return end

	MuteForRestart(true)
	CleanUp()

	GAMEMODE.Round_Winner = WIN_NONE

	SANITY.RoundBegin()

	if CheckForAbort() then return end

	if GetConVar("morbus_nightmare"):GetInt() == 1 then
		GAMEMODE.Nightmare = true
		SetGlobalInt("nightmare",1)
	else
		GAMEMODE.Nightmare = false
		SetGlobalInt("nightmare",0)
	end

	local ptime = GetConVar("morbus_round_prep"):GetInt()
	if GAMEMODE.FirstRound then
		ptime = ptime*2
		GAMEMODE.FirstRound = false
	end

	timer.Create("prep2begin", ptime, 1, BeginRound)

	GameMsg("Round begins in "..ptime)
	print("Round Starts in ".. ptime .."\n")
	SetRoundState(ROUND_PREP)
	SetRoundEnd(CurTime() + ptime)

	timer.Simple(0.01, SpawnEntities)

	ClearClient()

end
