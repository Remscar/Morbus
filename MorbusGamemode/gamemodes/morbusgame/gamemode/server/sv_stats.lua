// Stats sender
// Please dont mess with this file or fake stats

STATS = {}



STATS.Version = 5

STATS.URL = "http://www.remscar.com/morbus/stats.php"

/* Parameters
rln = Round Length
trt = Total Round Time
asn = Average Sanity
swl = Swarm Lives
nsw = Number of Swarms Alive
nbr = Number of Broods Alive
naa = Number of All Aliens
nha = Number of Humans Alive
nsp = Number of Spectators
npy = Number of Players
rwn = Round Winner
nrd = Number of RDMs
nbk = Number of Broods Killed
nsk = Number of Swarms Killed
nbi = Number of Brood Infects
nsi = number of Swarm Infects
*/



function STATS.Send()

	if #player.GetAll() < 6 then return end

	local tab = {}
	tab["rln"] = CurTime() - (STATS.RoundStart or CurTime())
	tab["trt"] = GetConVar("morbus_roundtime"):GetInt() * 60
	tab["asn"] = util.AverageSanity()
	tab["swl"] = Swarm_Respawns
	tab["nsw"] = #GetSwarmList()
	tab["nbr"] = #GetBroodList()
	tab["naa"] = #GetAlienList()
	tab["nha"] = #GetHumanList()
	tab["nsp"] = #GetSpectatorList()
	tab["npy"] = #player.GetAll()
	tab["rwn"] = GetGlobalInt("morbus_winner",WIN_NONE) //1=none 2=human 3=alien
	tab["nrd"] = Round_RDMs
	tab["nbk"] = Round_Brood_Kills
	tab["nsk"] = Round_Swarm_Kills
	tab["nbi"] = Round_Brood_Infects
	tab["nsi"] = Round_Swarm_Infects
	
	local url = STATS.URL.."?vrs="..tostring(STATS.Version)

	for k,v in pairs(tab) do
		url = url.."&"..k.."="..v
	end

	//MsgN(url)

	http.Fetch(url,STATS.Good, STATS.Bad)
end

function STATS.Good(html)
	MsgN(html)
	MsgN("Stats sent")
end

function STATS.Bad()
	MsgN("Stats failed")
end