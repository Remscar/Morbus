/*----------------------------------------------------
MORBUS DEVELOPED BY REMSCAR
Credits====
Production: Remscar
Code Snippets:
-BadKingUrgrain (Round system and some framework stuff)
-Gmod4Ever (Upgrade Menu)
Original Idea:
-IcklyLevel
-Movie: The Thing
Thanks to:
Gmod4Ever
M4RK
Sonoran Warrior
Demonkush
017
LauScript (schu)
----------------------------------------------------*/



// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team



-----------------------------------Includes
include("shared.lua")
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/shared/*.lua","LUA")) do include("shared/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/*.lua","LUA")) do include("server/" .. v) end

for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/alien/*.lua","LUA")) do include("server/alien/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/player/*.lua","LUA")) do include("server/player/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/round/*.lua","LUA")) do include("server/round/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/impulse/*.lua","LUA")) do include("server/impulse/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/mutators/*.lua","LUA")) do include("server/mutators/" .. v) end
-------------------------------------------




---------------------------SEND CLIENT FILES
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/shared/*.lua","LUA")) do AddCSLuaFile("shared/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/*.lua","LUA")) do AddCSLuaFile("client/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/vgui/*.lua","LUA")) do AddCSLuaFile("client/vgui/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/sb/*.lua","LUA")) do AddCSLuaFile("client/sb/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/fx/*.lua","LUA")) do AddCSLuaFile("client/fx/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/hud/*.lua","LUA")) do AddCSLuaFile("client/hud/" .. v) end
---------------------------------------------


------------STORE HOOK
--include("store/init.lua")



--------------------------------SERVER CONVARS
CreateConVar("morbus_roundtime", "10", FCVAR_NOTIFY)
CreateConVar("morbus_evactime", "3", FCVAR_NOTIFY)
CreateConVar("morbus_rounds", "8", FCVAR_NOTIFY)
CreateConVar("morbus_round_prep", "20", FCVAR_NOTIFY)
CreateConVar("morbus_round_post", "20", FCVAR_NOTIFY)
CreateConVar("morbus_mission_time_max", "220", FCVAR_NOTIFY)
CreateConVar("morbus_mission_time_min", "120", FCVAR_NOTIFY)
CreateConVar("morbus_mission_next_time_max", "80", FCVAR_NOTIFY)
CreateConVar("morbus_mission_next_time_min", "220", FCVAR_NOTIFY)


CreateConVar("morbus_rpnames_optional", "0", FCVAR_NOTIFY)
-----------------------------------------------

util.AddNetworkString("RoundLog")
util.AddNetworkString("RoundHistory")
util.AddNetworkString("ReceivedBody")
util.AddNetworkString("FoundBody")
-- util.AddNetworkString("OOCChat")
-- util.AddNetworkString("LocalChat")
-- util.AddNetworkString("SpecChat")
-- util.AddNetworkString("SelfRole")
-- util.AddNetworkString("PlayerRole")
-- util.AddNetworkString("RoundState")
-- util.AddNetworkString("Weight")
-- util.AddNetworkString("ClearClient")
-- util.AddNetworkString("MissionInfo")
-- util.AddNetworkString("MissionUpdate")
-- util.AddNetworkString("MissionComplete")
-- util.AddNetworkString("MissionReset")
-- util.AddNetworkString("UpgradePoints")
-- util.AddNetworkString("UpgradeData")
-- util.AddNetworkString("ClearUpgrades")
-- util.AddNetworkString("AlienChat")

--------------------------------INITIALIZE GAMEMODE
function GM:Initialize()
	MsgN("Morbus Server Loading...\n")
	SetGlobalInt("morbus_winner",0)


	RunConsoleCommand("mp_friendlyfire", "1")
    RunConsoleCommand("sv_alltalk", "0")
    RunConsoleCommand("sv_tags","Morbus"..GM_VERSION_SHORT)
    RunConsoleCommand("mp_show_voice_icons", "0")

	GAMEMODE.Round_State = ROUND_WAIT
	GAMEMODE.Round_Winner = WIN_NONE
	GAMEMODE.FirstRound = true
	GAMEMODE.STOP = false
	Round_RDMs = 0
	Round_Brood_Infects = 0
	Round_Brood_Kills = 0
	Round_Swarm_Infects = 0
	Round_Swarm_Kills = 0
	RoundHistory = {}
	Round_Log = {}
	Round_IDs = {}
	Total_Evolution_Points = 0
	Swarm_Respawns = 0
	Evacuation_Map = false
	Human_Evacuated = false

	SetGlobalFloat("morbus_round_end", -1)
	SetGlobalInt("morbus_swarm_spawns", 0)
	SetGlobalInt("morbus_rounds_left", GetConVar("morbus_rounds"):GetInt())
	SetGlobalFloat("morbus_round_time", GetConVar("morbus_roundtime"):GetInt())

	SetGlobalBool("morbus_rpnames_optional", GetConVar("morbus_rpnames_optional"):GetBool())
	WaitForPlayers()

	CAN_RTV = CurTime() + 120

	PrepMutators()

	MsgN("Morbus Server Loaded!\n")
end



timer.Create( "TagCheck", 1, 0, function()
	if not GetConVar( "sv_tags" ) then CreateConVar("sv_tags","") end
	if ( !string.find( GetConVar( "sv_tags" ):GetString(), "morbus"..tostring(GM_VERSION_SHORT) ) ) then
	RunConsoleCommand( "sv_tags", GetConVar( "sv_tags" ):GetString() .. ",morbus"..tostring(GM_VERSION_SHORT) )
	end
end )

------------------------------------------------

DEBUG_MORBUS = false
