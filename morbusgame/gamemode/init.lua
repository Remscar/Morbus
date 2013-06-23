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
LauScript (schu)
----------------------------------------------------*/



---------------------------------LOCALIZATION
local math = math
local table = table
local umsg = umsg
local player = player
local timer = timer
local pairs = pairs
local umsg = umsg
local usermessage = usermessage
local file = file
---------------------------------------------



-----------------------------------Includes
include("shared.lua")
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/shared/*.lua","LUA")) do include("shared/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/server/*.lua","LUA")) do include("server/" .. v) end
-------------------------------------------




---------------------------SEND CLIENT FILES
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/shared/*.lua","LUA")) do AddCSLuaFile("shared/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/*.lua","LUA")) do AddCSLuaFile("client/" .. v) end
for k, v in pairs(file.Find(FOLDER_NAME .. "/gamemode/client/vgui/*.lua","LUA")) do AddCSLuaFile("client/vgui/" .. v) end
---------------------------------------------


------------STORE HOOK
--include("store/init.lua")



--------------------------------SERVER CONVARS
CreateConVar("morbus_roundtime", "10", FCVAR_NOTIFY)
CreateConVar("morbus_evactime", "3", FCVAR_NOTIFY)
CreateConVar("morbus_rounds", "8", FCVAR_NOTIFY)
CreateConVar("morbus_round_prep", "20", FCVAR_NOTIFY)
CreateConVar("morbus_round_post", "20", FCVAR_NOTIFY)
CreateConVar("morbus_nightmare", "0", FCVAR_NOTIFY)
CreateConVar("morbus_mission_time_max", "220", FCVAR_NOTIFY)
CreateConVar("morbus_mission_time_min", "120", FCVAR_NOTIFY)
CreateConVar("morbus_mission_next_time_max", "80", FCVAR_NOTIFY)
CreateConVar("morbus_mission_next_time_min", "220", FCVAR_NOTIFY)
-----------------------------------------------

util.AddNetworkString("RoundLog")
util.AddNetworkString("RoundHistory")
util.AddNetworkString("ReceivedBody")
util.AddNetworkString("FoundBody")

--------------------------------INITIALIZE GAMEMODE
function GM:Initialize()
	MsgN("Morbus Server Loading...\n")
	SetGlobalInt("morbus_winner",0)


	RunConsoleCommand("mp_friendlyfire", "1")
    RunConsoleCommand("sv_alltalk", "0")
    RunConsoleCommand("sv_tags","Morbus"..GM_VERSION_SHORT)

	GAMEMODE.Round_State = ROUND_WAIT
	GAMEMODE.Round_Winner = WIN_NONE
	GAMEMODE.FirstRound = true
	GAMEMODE.Nightmare = false
	GAMEMODE.STOP = false
	Round_RDMs = 0
	Round_Brood_Infects = 0
	Round_Brood_Kills = 0
	Round_Swarm_Infects = 0
	Round_Swarm_Kills = 0
	SetGlobalInt("nightmare",0)
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

	WaitForPlayers()

	CAN_RTV = CurTime() + 120

	if GetConVar("morbus_nightmare"):GetInt() == 1 then
		GAMEMODE.Nightmare = true
		SetGlobalInt("nightmare",1)
	end

	MsgN("Morbus Server Loaded!\n")
end

function ChangeNightmare(ply)
	if ply:IsAdmin() then
		if !GAMEMODE.Nightmare then
			--SetGlobalInt("nightmare",1)
			SendAll("Nightmare mode is now on")
			RunConsoleCommand("morbus_nightmare","1")
		else
			--SetGlobalInt("nightmare",0)
			SendAll("Nightmare mode is now off")
			RunConsoleCommand("morbus_nightmare","0")
		end
	end
end

------------------------------------------------



GMNextThink = 0
function GM:Think()
	if GMNextThink <= CurTime() then
		CheckAlien() -- Found in sv_brood.lua
		CheckMission() -- sv_missions.lua
		CheckMovement() -- below
		GMNextThink = CurTime() + 0.08
	end
end

function CheckMovement()
	for k,v in pairs(player.GetAll()) do
		if v:KeyDown(IN_FORWARD) || v:KeyDown(IN_BACK) || v:KeyDown(IN_JUMP) || v:KeyDown(IN_LEFT) || v:KeyDown(IN_RIGHT) || v:KeyDown(IN_ATTACK) || (v.OldPos != v:GetPos()) then
			v.Moving = true
			v.Moved = true -- for motion sensor thingy
			v.OldPos = v:GetPos()
			if v:GetNWBool("alienform") then Cancel_Cloak(v) end
		elseif v:OnGround() then
			v.Moving = false
			v.OldPos = v:GetPos()
		end
	end
end

function SendAll( msg )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( 3, msg )
	end
end

function SendMsg( ply, msg)
	ply:PrintMessage(3,msg)
end

function WhoIsPlayer(name)
	if !name then return end
	local match = nil
	for k,v in pairs(player.GetAll()) do
		if (v:GetFName() == name) then
			return match
		end
	end
	if !match then return false end
end



DEBUG_MORBUS = false
