--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

RTV_COUNT = 0
SMV = {}

SMV.RTVING = false
SMV.Maps = {
	"mor_breach_b4_re",
	"para_auriga_v2",
	"mor_skandalon_b5_re",
	"mor_spaceship_v9_re",
	"mor_isolation_b4_re",
	"mor_outpostnorth32_a4",
	"mor_installation_b2",
	"mor_alphastation_b2",
	"mor_chemical_labs_b3_re",
}
SMV.VoteTime = 30
SMV.Voting = false
SMV.Votes = {}
SMV.TVotes = {}

util.AddNetworkString("smv_start")
util.AddNetworkString("smv_end")
util.AddNetworkString("smv_vote")
util.AddNetworkString("smv_vote_status")
util.AddNetworkString("smv_winner")

function SMV.AddMapKey(key) //add maps that have {key} in their name
	local maps = file.Find("maps/"..key.."*.bsp","GAME")

	for k,v in pairs(maps) do
		v = string.sub(v,0,string.len(v)-4)
		if !table.KeyFromValue(SMV.Maps,v) then
			table.insert(SMV.Maps, v)
			MsgN("[SMV] Added "..v.." ["..key.."]")
		end
	end
end

function SMV.ExcludeMap(mapname)
	local key = table.KeyFromValue(SMV.Maps,mapname)

	if key then
		SMV.Maps[key] = nil
	end
	MsgN("[SMV] Removed "..mapname.." from vote list")
end

function SMV.CheckMaps()
	local toremove = {}

	for k,v in pairs(SMV.Maps) do
		if !file.Exists("maps/"..v..".bsp","GAME") then
			table.insert(toremove,k)
		end
	end
	for k,v in pairs(toremove) do
		MsgN("[SMV] Removed "..SMV.Maps[v].." from vote list (DID NOT EXIST)")
		SMV.Maps[v] = nil
	end
end
SMV.ExcludeMap(game.GetMap())
SMV.CheckMaps()

function NeededRTV()
	local need = math.floor(#player.GetAll()/2)

	return (need - RTV_COUNT)
end

function RTV(ply)
	if ply.RTV || ply.RTV == true then return end
	if (CAN_RTV > CurTime()) then return end
	if SMV.RTVING then return end

	ply.RTV = true
	RTV_COUNT = RTV_COUNT + 1

	SendAll(ply:GetFName(true).." has rocked the vote! "..NeededRTV().." more votes needed to change the map! Type /rtv to vote!")
	if (NeededRTV() < 1) then
		SendAll("Map changing!")
		timer.Simple(3, function() hook.Call("Morbus_MapChange") end)
	end
end

function ForceMap(ply)
	if !ply:IsAdmin() then return end

	SendAll(ply:Nick().." has forced a map change!")
	timer.Simple(3, function() hook.Call("Morbus_MapChange") end)
end

-- VOTING SYSTEM
function SMV.StartMapVote()
	MsgN("[SMV] Map voting started!")

	if SMV.RTVING == true then return end

	SMV.RTVING = true
	SMV.Voting = true
	GAMEMODE.STOP = true

	net.Start("smv_start")
	net.WriteTable(SMV.Maps)
	net.Broadcast()
	timer.Simple(SMV.VoteTime + 5, function() SMV.EndMapVote() end)
end
hook.Add("Morbus_MapChange", "SMV_MapHook",SMV.StartMapVote)

function SMV.EndMapVote()
	net.Start("smv_end")
	net.Broadcast()
	SMV.Voting = false

	local winner = SMV.GetWinner()

	if !winner then
		SMV.StartMapVote()
		return
	end
	net.Start("smv_winner")
	net.WriteString(winner)
	net.Broadcast()
	SendAll(winner.." is the next map!")
	timer.Simple(5, function() SMV.ChangeMap(winner) end)
end

function SMV.ChangeMap(mapname)
	RunConsoleCommand( "changelevel", mapname, gmod.GetGamemode().FolderName )
end

function SMV.GetWinner()
	local tab = {}
	local map = nil
	local sid = nil
	local votes = nil
	local num = 0
	local top = 0
	local winner = ""

	for k,v in pairs(SMV.Votes) do
		sid = k
		map = v[1]
		votes = v[2]

		if tab[map] then
			tab[map] = tab[map] + votes
		else
			tab[map] = votes
		end
		num = num + 1
		map = nil
		sid = nil
		votes = nil
	end
	if num < 1 then
		return table.Random(SMV.Maps)
	end
	for k,v in pairs(tab) do
		if v > top then
			top = v
			winner = k
		end
	end
	return winner
end

function SMV.SendVotes()
	local tab = {}
	local map = nil
	local sid = nil
	local votes = nil

	for k,v in pairs(SMV.Votes) do
		sid = k
		map = v[1]
		votes = v[2]

		if tab[map] then
			tab[map] = tab[map] + votes
		else
			tab[map] = votes
		end
		map = nil
		sid = nil
		votes = nil
	end
	SMV.TVotes = tab
	net.Start("smv_vote_status")
	net.WriteTable(tab)
	net.Broadcast()
end

function SMV.GetVote(len, ply)
	local map = net.ReadString()
	local sid = ply:SteamID()
	local votes = 1

	SMV.Votes[sid] = {map,votes}
	MsgN("Vote recieved "..sid.." ["..map.."] ["..votes.."]")
	SMV.SendVotes()
end
net.Receive("smv_vote",SMV.GetVote)
