/*-----------------------------
NETWORKING
------------------------------*/
// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
--require("datastream")

DEBUG_NET = false

concommand.Add("mor_debug",function() DEBUG_NET = !DEBUG_NET
MsgN(DEBUG_NET) end)

local function RecieveOOCChat(UM)
	local name,text
	realname = UM:ReadString()
	fakename = UM:ReadString()
	text = UM:ReadString()
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [OOCCHAT]") end

	chat.AddText(Color(255,130,0),"[OOC] (",Color(200,0,0),realname,Color(255,130,0),") ",Color(255,255,0),fakename,":",Color(255,255,255),text)
end
usermessage.Hook("SendOOCChat",RecieveOOCChat)

local function RecieveLocalChat(UM)
	local name,text
	name = UM:ReadString()
	text = UM:ReadString()
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [LOCALCHAT]") end

	chat.AddText(Color(0,200,200),"[LOCAL] ",Color(255,255,0),name,":",Color(255,255,255),text)
end
usermessage.Hook("SendLocalChat",RecieveLocalChat)

local function RecieveSpecChat(UM)
	local name,text
	name = UM:ReadString()
	text = UM:ReadString()
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [SPECCHAT]") end

	chat.AddText(Color(0,200,0),"[SPECTATOR] ",Color(255,255,0),name,":",Color(255,255,255),text)
end
usermessage.Hook("SendSpecChat",RecieveSpecChat)

local function RecieveRole(UM)
	local ply = LocalPlayer()
	local role = UM:ReadChar()

	if (not ply.SetRole) then return end

	ply:SetRole(role)
	CreateRoleHelp(role)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [ROLE]") end

	CL_GameMessage("You are a "..GetRoleName(role))
end
usermessage.Hook("Morbus_Role", RecieveRole)


local function RecieveSetPlayer(UM)
	local role = UM:ReadChar()
	local ply = UM:ReadEntity()
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [OTHERROLE]") end

	if (ValidEntity(ply)) then
		--if (ply:GetRole() != role) then CL_GameMessage(ply:GetFName()).." is now a "..GetRoleName(role)) end
		ply:SetRole(tonumber(role))
	end
end
usermessage.Hook("Morbus_SetPlayerRole", RecieveSetPlayer)


local function RecieveRoundState(UM)
	local round = GetRoundState()
	GAMEMODE.Round_State = UM:ReadChar()
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [ROUNDSTATE]") end
	
	if (round != GAMEMODE.Round_State) then
		if GAMEMODE.Round_State == ROUND_ACTIVE then
			Clear_Messages()
		end
		RoundStateChanged(round,GAMEMODE.Round_State)
	end


	Msg("Round State Recieved: ".. GAMEMODE.Round_State .."\n") --Debug
end
usermessage.Hook("Morbus_RoundState", RecieveRoundState)



local function RecieveWeight(UM)
	local ply = LocalPlayer()
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [WEIGHT]") end

	if ply.SetWeight then
		ply:SetWeight(UM:ReadLong())
	else
		ply.Weight = UM:ReadLong()
	end
end
usermessage.Hook("Morbus_PlayerWeight", RecieveWeight)


function GM:ClearClientState()
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [RESET]") end
	local client = LocalPlayer()
	if (not client.SetRole) then return end -- Code not loaded

	client:SetRole(ROLE_HUMAN)
	client:ResetPlayer()


	for _, p in pairs(player.GetAll()) do
		if IsValid(p) then
			p.sb_tag = nil
			p:SetRole(ROLE_HUMAN)
		end
	end

	

end
usermessage.Hook("Morbus_ClearClient", GM.ClearClientState)

function Get_MissionInfo(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [MISSION_INFO]") end
	Morbus.Mission = data:ReadChar()
	Morbus.Mission_End = data:ReadLong()
	Morbus.Mission_Doing = false
	Morbus.Mission_Complete = 0
	Morbus.Blinded = false
	--MsgN("Mission Info")
end
usermessage.Hook("Morbus_SendMissionInfo",Get_MissionInfo)

function Get_MissionInfo_Mini(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [MISSION_INFO_MINI]") end
	Morbus.Mission = data:ReadChar()
	Morbus.Mission_End = data:ReadLong()
	--MsgN("Mission Info")
end
usermessage.Hook("Morbus_SendMissionInfo_Mini",Get_MissionInfo_Mini)

function Get_MissionComplete(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [MISSION_COMPLETE]") end
	Morbus.Mission_Doing = true
	Morbus.Mission_Complete = CurTime() + TTC_MISSION
	Morbus.Blinded = true
	--MsgN("Mission Complete")
end
usermessage.Hook("Morbus_SendMissionComplete",Get_MissionComplete)

function ResetMission(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [MISSION_RESET]") end
	Morbus.Mission = 0
	Morbus.Mission_End = 0
	Morbus.Mission_Doing = false
	Morbus.Mission_Complete = 0
	Morbus.Blinded = false
	--MsgN("Mission Reset")
end
usermessage.Hook("Morbus_ResetMission",ResetMission)


function RecieveRoundHistory()
	MsgN("Recieving Round History")

	if pUpgradesMenu then
		pUpgradesMenu:Remove()
	end

	if pDescriptionBox then
		pDescriptionBox:Remove()
	end

	SetupRoundHistory()
	RoundHistory = net.ReadTable()
	OPEN_RHISTORY()

	file.Append("Morbus/logs/"..game.GetMap( ).."/".."round_log_"..tostring(os.date("%m-%d_%H%M"))..".txt","#### MORBUS ROUND LOG ####\n"..os.date().."\n")
	for k,v in pairs(Round_Log) do
		file.Append("Morbus/logs/"..game.GetMap( ).."/".."round_log_"..tostring(os.date("%m-%d_%H%M"))..".txt","["..v.
			Time.."] ["..v.Type.."] "..v.Text.."\n")
	end
	
	file.Append("Morbus/logs/"..game.GetMap( ).."/".."round_log_"..tostring(os.date("%m-%d_%H%M"))..".txt","#### PLAYER STEAM ID's ####\n")
	for k,v in pairs(player.GetAll()) do
		file.Append("Morbus/logs/"..game.GetMap( ).."/".."round_log_"..tostring(os.date("%m-%d_%H%M"))..".txt","["..v:GetFName(true).."] "..v:SteamID().."\n")
	end

end

net.Receive("RoundHistory",RecieveRoundHistory)

function Get_EvolutionPts(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [GET EVO POINTS]") end
	Morbus.Evo_Points = data:ReadLong()
end
usermessage.Hook("SendEvolution",Get_EvolutionPts)

function Get_Upgrade(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [GET UPGRADES]") end
	Morbus.Upgrades[data:ReadChar()] = data:ReadChar()
	--PrintTable(Morbus.Upgrades)
end
usermessage.Hook("SendUpgrade",Get_Upgrade)

function Clear_Upgrades(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [CLEAR UPGRADES]") end
	Morbus.Upgrades = {}
end
usermessage.Hook("ClearUpgrades",Clear_Upgrades)


function Get_Fear(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [FEAR]") end
	local ply = LocalPlayer()
	ply.Fear = CurTime() + 1.75
	ply.FearInt = data:ReadShort()
end
usermessage.Hook("Send_Fear",Get_Fear)

function Get_Transform(data)
	if DEBUG_NET then MsgN("MORBUS DEBUG UMSG [TRANSFORM]") end
	local bool = data:ReadBool()
	if bool == true then
		surface.PlaySound(Sound("buttons/button24.wav"))
	end
	Morbus.CanTransform = bool
end
usermessage.Hook("Send_Transform",Get_Transform)