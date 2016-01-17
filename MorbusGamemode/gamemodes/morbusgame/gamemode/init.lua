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
CreateConVar("morbus_rounds", "6", FCVAR_NOTIFY)
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

hook.Remove("PreDrawHalos", "PropertiesHover")

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
	SetGlobalInt("alien_wins", 0)
	SetGlobalInt("human_wins", 0)
	SetGlobalFloat("morbus_round_time", GetConVar("morbus_roundtime"):GetInt())

	SetGlobalBool("morbus_rpnames_optional", GetConVar("morbus_rpnames_optional"):GetBool())
	WaitForPlayers()

	PrepMutators()

	MsgN("Morbus Server Loaded!\n")
end


concommand.Add( "SwarmBuyMod", function( ply, cmd, args )
	if !ply:IsSwarm() then
		ply:PrintMessage( HUD_PRINTTALK, "You aren't a Swarm Alien!" )
		return
	end

	-- Cost conditions, done here to prevent abuse
	local SwarmCost = 0
	local SWDonator = 0
	local AllowBuy	= 0
	if tonumber( args[1] ) == 0 then
		-- Normal Spit
		SwarmCost = 0
		SWDonator = 0

	elseif tonumber( args[1] ) == 1 then
		-- Chemical Bomb
		SwarmCost = 5
		SWDonator = 0

	elseif tonumber( args[1] ) == 2 then
		-- Nitro Core
		SwarmCost = 10
		SWDonator = 0

	elseif tonumber( args[1] ) == 3 then
		-- Shock Spit
		SwarmCost = 10
		SWDonator = 0

	elseif tonumber( args[1] ) == 4 then
		-- Shock Spit
		return

	elseif tonumber( args[1] ) == 5 then
		-- Swarm Haste
		SwarmCost = 5
		SWDonator = 0

	elseif tonumber( args[1] ) == 6 then
		-- Blood Siphon
		SwarmCost = 5
		SWDonator = 0

	elseif tonumber( args[1] ) == 7 then
		-- Unstable Bore
		SwarmCost = 5
		SWDonator = 0

	elseif tonumber( args[1] ) == 8 then
		--remote
		SwarmCost = 10
		SWDonator = 0


	elseif tonumber( args[1] ) == 9 then
		return

	elseif tonumber( args[1] ) == 10 then
		-- Leap
		SwarmCost = 5
		SWDonator = 0

	elseif tonumber( args[1] ) == 11 then
		-- Shock Spit
		return

	elseif tonumber( args[1] ) == 12 then
		-- Shock Spit
		SwarmCost = 10
		SWDonator = 0

	elseif tonumber( args[1] ) == 13 then
		-- Shock Spit
		return
	elseif tonumber( args[1] ) == 14 then
		-- Shock Spit
		return
	end

	if ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "owner" or ply:GetUserGroup() == "admin" or ply:GetUserGroup() == "developer" then
		AllowBuy = 1
		SwarmCost = 0
	end

	-- Fund test
	local HowMuch = ply:GetSwarmPoints()
	print( "1.player funds: " .. ply:GetSwarmPoints() )
	print( "2.upgrade cost: " .. SwarmCost )

	-- Reset mod
	if tonumber( args[1] ) == 0 then
		ply:SetSwarmMod( 0 )
		ply:PrintMessage( HUD_PRINTTALK, "[Swarm Shop] Modifier reset!" )
		return
	end

	-- Already have this mod
	if ply:GetSwarmMod() == tonumber( args[1] ) then
		ply:PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You already have this modifier!" )
		return 
	end

	-- Not enough points
	if HowMuch < SwarmCost then
		ply:PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You don't have enough Swarm Points!" )
		return
	end

	-- Successful purchase
	if HowMuch >= SwarmCost then
		-- Donator buy
		if AllowBuy then
			print( "Selected Mod: " .. args[1] )
			ply:SetSwarmMod( tonumber( args[1] ) )

			ply:PrintMessage( HUD_PRINTTALK, "[Swarm Shop] Admin purchased: " .. tostring( args[2] ) .. "." )

		-- Regular buy
		else

			ply:SetSwarmPoints( ply:GetSwarmPoints() - SwarmCost )

			print( "Selected Mod: " .. args[1] )
			ply:SetSwarmMod( tonumber( args[1] ) )

			ply:PrintMessage( HUD_PRINTTALK, "[Swarm Shop] Successfully purchased: " .. tostring( args[2] ) .. "." )
		end
	end

end)



timer.Create( "TagCheck", 1, 0, function()
	if not GetConVar( "sv_tags" ) then CreateConVar("sv_tags","") end
	if ( !string.find( GetConVar( "sv_tags" ):GetString(), "morbus"..tostring(GM_VERSION_SHORT) ) ) then
	RunConsoleCommand( "sv_tags", GetConVar( "sv_tags" ):GetString() .. ",morbus"..tostring(GM_VERSION_SHORT) )
	end
end )

------------------------------------------------

DEBUG_MORBUS = false
