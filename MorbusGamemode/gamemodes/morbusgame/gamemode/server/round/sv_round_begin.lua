/*----------------------------------------------------
BEGIN ROUND
----------------------------------------------------*/

function SetupRoundHistory()
	RoundHistory = {}
	RoundHistory["Infect"] = {}
	RoundHistory["Kill"] = {}
	RoundHistory["First"] = {}

	Total_Evolution_Points = STARTING_EVOLUTION --hur

	ResetLog()
end


function BeginRound()
	print("Round starting!\n")

	SetupRoundHistory()

	GAMEMODE:SyncGlobals()

	if CheckForAbort() then return end

	local endtime = CurTime() + (GetConVar("morbus_roundtime"):GetInt() * 60)
	STATS.RoundStart = CurTime()

	SetRoundEnd(endtime)

	if CheckForAbort() then return end

	SpawnPlayers(true)

	if CheckForAbort() then return end

	SelectRoles()

	ents.MORBUS.RemoveRagdolls(true)
	Swarm_Respawns = STARTING_SWARM_SPAWNS

	SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
	
	StartWinChecks()

	SetRoundState(ROUND_ACTIVE)
	GameMsg("The round has begun. Extraction inbound.")

	CheckMutators()
	StartMutators()
	
	print("ROUND_ACTIVE\n")

	Round_RDMs = 0
	Round_Infects = 0
	Round_Kills = 0

	GAMEMODE:UpdatePlayerLoadouts()

	local evac_area = ents.FindByClass("mor_evac_area")
	if #evac_area > 0 then
		Evacuation_Map = true
		Human_Evacuated = false
	end

	STATS.InitialHumans = #GetHumanList()
	STATS.ResurgenceCount = 0


	print("Round started!\n")
end