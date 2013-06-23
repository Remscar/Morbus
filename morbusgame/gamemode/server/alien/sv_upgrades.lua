// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

function GetEvolutionPoints(ply)
   return ply.Evo_Points or 0
end

function GetTotalEvolutionPoints()
   return Total_Evolution_Points
end

local plymeta = FindMetaTable( "Player" )
if not plymeta then return end

function plymeta:GetEvoPoints()
	return GetEvolutionPoints(self)
end

function plymeta:SendEvoPoints()
	Send_EvolutionPoints(self)
end

function plymeta:SendUpgrades()
	Send_Upgrades(self)
end

function Send_EvolutionPoints(ply)
	umsg.Start("SendEvolution",ply)
	umsg.Long(GetEvolutionPoints(ply))
	umsg.End()
end

function Send_Upgrades(ply)
	Clear_Upgrades(ply)
	
	for k,v in pairs(ply.Upgrades) do
		umsg.Start("SendUpgrade",ply)
		umsg.Char(k)
		umsg.Char(v)
		umsg.End()
	end
	
end

function Send_Upgrade(ply,up)
	umsg.Start("SendUpgrade",ply)
	umsg.Char(up)
	umsg.Char(ply.Upgrades[up])
	umsg.End()
end


function Clear_Upgrades(ply)
	umsg.Start("ClearUpgrades",ply)
	umsg.End()
end

function Increase_Upgrade(ply,cmd,args)
	if !ValidEntity(ply) then return end
	if !ply:IsBrood() then return end
	if ply:GetEvoPoints() < 1 then ply:SendUpgrades() return end
	if !args[1] then ply:SendUpgrades() return end

	local up = UPGRADES[tonumber(args[1])]

	if (ply:GetTierPoints(up.Tree,up.Tier-1)>=UPGRADE_TIER_REQUIREMENT) || (up.Tier == 1) then
		if ((ply.Upgrades[tonumber(args[1])] or 0) < up.MaxLevel) then
			ply.Upgrades[tonumber(args[1])] = (ply.Upgrades[tonumber(args[1])] or 0) + 1
			Send_Upgrade(ply,tonumber(args[1]))
			SendMsg( ply, up.Title.." has been upgraded!")
			ply.Evo_Points = ply.Evo_Points - 1
			ply:SendEvoPoints()
		else
			SendMsg( ply, "You cannot level up that upgrade anymore!")
			ply:SendUpgrades()
		end
	else
		ply:SendUpgrades()
	end


end
concommand.Add("morbus_upgrade",Increase_Upgrade)

function Hack_Points(ply,cmd,args)
	local num = tonumber(args[1])
	if ply:IsSuperAdmin() then
		ply.Evo_Points = ply.Evo_Points + num
		ply:SendEvoPoints()
	end
end
concommand.Add("give_points",Hack_Points)
--RunConsoleCommand("alien_increase_level_upgrade",self.Upgrade)

function CalcUpgrade()
	return POINTS_PER_KILL + math.Round(#player.GetAll()*POINTS_PER_KILL2)
end