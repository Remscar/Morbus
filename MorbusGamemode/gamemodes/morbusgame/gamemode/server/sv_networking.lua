
// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team



function SendRoundState(state, ply)

	if ply then
		umsg.Start("Morbus_RoundState", ply)
	else
		umsg.Start("Morbus_RoundState")
	end

	umsg.Char(state)
	umsg.End()
end



function SendPlayerWeight(weight, ply)

	if ValidEntity(ply) then
		umsg.Start("Morbus_PlayerWeight", ply)
		umsg.Long(weight)
		umsg.End()
	else
		print("Error sending player weight, null player")
	end

end


function Send_Transform(ply,bool)
	umsg.Start("Send_Transform",ply)
	umsg.Bool(bool)
	umsg.End()
end



function SendPlayerRole(role, ply)

	if ValidEntity(ply) then
		umsg.Start("Morbus_Role", ply)
		umsg.Char(role)
		umsg.End()
	else
		print("Error sending a player their role, null player")
	end

end



function SendOtherPlayerRole(role, pl, ply)
	ply:RemovePlayer(pl)
	if ValidEntity(pl) then id = pl end

	umsg.Start("Morbus_SetPlayerRole", ply)
	umsg.Char(role)
	umsg.Entity(id)
	umsg.End()

end



function ClearClient(ply)
	if ply then
		umsg.Start("Morbus_ClearClient", ply)
	else
		umsg.Start("Morbus_ClearClient")
	end
	umsg.End()
end



function Send_MissionInfo(ply)
	if ValidEntity(ply) then 

		umsg.Start("Morbus_SendMissionInfo",ply)
		umsg.Char(ply.Mission) -- what mission
		umsg.Long(ply.Mission_End) -- when it ends
		umsg.End()
	end
end

function Send_MissionInfo_Mini(ply)
	if ValidEntity(ply) then 

		umsg.Start("Morbus_SendMissionInfo_Mini",ply)
		umsg.Char(ply.Mission) -- what mission
		umsg.Long(ply.Mission_End) -- when it ends
		umsg.End()
	end
end

function Send_MissionComplete(ply)
	if ValidEntity(ply) then 

		umsg.Start("Morbus_SendMissionComplete",ply) -- mouth full
		umsg.End()
	end
end

function ResetMission(ply)
	if ValidEntity(ply) then 
		umsg.Start("Morbus_ResetMission",ply)
		umsg.End()
	end
end

function Send_RoundHistory()
	SendLog()
	net.Start("RoundHistory")
	net.WriteTable(RoundHistory)
	net.Broadcast()
	--datastream.StreamToClients(player.GetAll(),"RoundHistory",RoundHistory)
end



/*----------------------------------------------------
SNYC
----------------------------------------------------*/
function GM:SyncGlobals()
	SetGlobalFloat("morbus_round_time", GetConVar("morbus_roundtime"):GetInt())
end

function SetRoundEnd(endtime)
	SetGlobalFloat("morbus_round_end", endtime)
	STATS.RoundEnd = endtime
end






