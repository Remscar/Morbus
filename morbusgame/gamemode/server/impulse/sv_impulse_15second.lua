// 15 second impulse


local IMPULSE = {}

function IMPULSE.SECOND15()
	for k,v in pairs(player.GetAll()) do
		IMPULSE.MISSION(k,v)
	end
end
hook.Add("Impulse_15Second","15Sec_Impulse",IMPULSE.SECOND15)


function IMPULSE.MISSION(k,v)
	if IsValid(v) then
		Send_MissionInfo_Mini(v)
	end
end