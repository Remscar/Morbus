--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- Quarter second impulse
local IMPULSE = {}

function IMPULSE.QUARTER_SECOND()
	for k,v in pairs(player.GetAll()) do
		IMPULSE.INVISIBLE(k,v)
	end
end
hook.Add("Impulse_Quarter_Second","QSec_Impulse",IMPULSE.QUARTER_SECOND)

local function Send_Cloak(ply)
	umsg.Start("Send_Cloaking",ply)
	umsg.End()
end

function Cancel_Cloak(ply)
	umsg.Start("Cancel_Cloaking",ply)
	umsg.End()
end

function IMPULSE.INVISIBLE(k,v)
	if v:IsBrood() && v:Team() == TEAM_GAME && v:Alive() && ValidEntity(v) && v:GetNWBool("alienform",false) then
		if v.Upgrades[UPGRADE.INVISIBLE] then
			if v.Moving then
				v.Cloaked = 0
				v.CloakStart = 0
				v.Cloaking = false
				Cancel_Cloak(v)
				v:SetColor(Color(255,255,255,255))
				v:SetNoDraw(false)
			elseif v.Cloaked != 0 then
				if v.Cloaking then
					if v.Cloaked <= CurTime() then
						v:SetColor(Color(255,255,255,0))
						v:SetNoDraw(true)
						Send_Cloak(v)
						v.Cloaked = 0
					end
				end
			else
				if !v.Cloaking then
					v.Cloaked = CurTime() + (6-v.Upgrades[UPGRADE.INVISIBLE])
					v.CloakStart = CurTime()
					v.Cloaking = true
				end
			end
		end
	end
end
