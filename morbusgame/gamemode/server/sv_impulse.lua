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
/*----------------------------------------------------------
IMPULSES
These things run every few seconds or what not
I hook them on timers just cause i can
----------------------------------------------------------*/


/*=======================================================
IMPULSE HOOKS
========================================================*/

IMPULSE = {}


function IMPULSE.SECOND()

	IMPULSE.BONUSLIVES()
	
	for k,v in pairs(player.GetAll()) do
		IMPULSE.ALIEN(k,v)
		IMPULSE.LIGHT(k,v)
		if GetRoundState()==ROUND_ACTIVE then
			IMPULSE.NEED(k,v)
			IMPULSE.GENERAL(k,v)
		end
		IMPULSE.SPECTATOR(k,v)
		
		
	end
end

function IMPULSE.QUARTER_SECOND()
	for k,v in pairs(player.GetAll()) do
		IMPULSE.INVISIBLE(k,v)
	end
end

function IMPULSE.SECOND4()
	IMPULSE.LOCATIONS()
	for k,v in pairs(player.GetAll()) do
		IMPULSE.SWARM(k,v)
	end
	
	
end

function IMPULSE.SECOND15()
	for k,v in pairs(player.GetAll()) do
		IMPULSE.MISSION(k,v)
	end
	
end


hook.Add("Impulse_Second","Sec_Impulse",IMPULSE.SECOND)
hook.Add("Impulse_4Second","4Sec_Impulse",IMPULSE.SECOND4)
hook.Add("Impulse_15Second","15Sec_Impulse",IMPULSE.SECOND15)
hook.Add("Impulse_Quarter_Second","QSec_Impulse",IMPULSE.QUARTER_SECOND)

timer.Create("SecondImpulse",1,0,function() hook.Call("Impulse_Second") end)
timer.Create("Second4Impulse",4,0,function() hook.Call("Impulse_4Second") end)
timer.Create("Second15Impulse",15,0,function() hook.Call("Impulse_15Second") end)
timer.Create("QuarterSecondImpulse",0.25,0,function() hook.Call("Impulse_Quarter_Second") end)

function IMPULSE.BONUSLIVES()
	local tend = GetGlobalFloat("morbus_round_end",nil)
	if tend and ((tend-90) < CurTime()) and GetRoundState() == ROUND_ACTIVE then
		Swarm_Respawns =  Swarm_Respawns + 1
		SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns)
	end

end

function IMPULSE.MISSION(k,v)
	if IsValid(v) then
		Send_MissionInfo_Mini(v)
	end
end


/*=======================================================
IMPULSES
========================================================*/
local function Send_Cloak(ply)
	umsg.Start("Send_Cloaking",ply)
	umsg.End()
end

function Cancel_Cloak(ply)
	umsg.Start("Cancel_Cloaking",ply)
	umsg.End()
end

function IMPULSE.SPECTATOR(k,ply)
	if ply:IsSpec() then
		if (ply:Alive()) then
			ply:Kill()
		end
		if !(GetRoundState() == ROUND_ACTIVE || GetRoundState() == ROUND_EVAC) then return end
		if (Swarm_Respawns > 0 || GetRoundState() == ROUND_EVAC) && (ply.WantsSpec != true) && (ply.TempSpec != true) then
			MsgN(ply)
			NewAlien(ply,ROLE_SWARM)
	    end
	end
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
						
						-- local alpha = (v.Cloaked - CurTime())
						-- local talpha = (alpha+0.25)/(6-v.Upgrades[UPGRADE.INVISIBLE])
						-- /* talpha gets smaller as time goes on */
						-- talpha = 255*talpha
						-- if alpha >= 0 then
						-- 	v:SetColor(Color(255,255,255,talpha))
						-- 	v:SetNoDraw(false)
						-- else
						-- 	v:SetColor(Color(255,255,255,0))
						-- 	v:SetNoDraw(true)
						-- 	Send_Cloak(v)
						-- 	v.Cloaked = 0
						-- end
					end
				else
					-- If they are completley cloaked or not cloaked
					if v.Cloaking then
						-- if they are cloaked
					else
						v.Cloaked = CurTime() + (6-v.Upgrades[UPGRADE.INVISIBLE])
						v.CloakStart = CurTime()
						v.Cloaking = true
						
					end

				end
			end
		end
end


function IMPULSE.LIGHT(k,v)
		if v:Alive() && v:Team() == TEAM_GAME && !v:IsSwarm() then
			LIGHT.Think(v)
		end
end
		

function IMPULSE.ALIEN(k,v) --s
		if v:IsBrood() && v:Team() == TEAM_GAME && v:Alive() && ValidEntity(v) then
			if ValidEntity(v:GetActiveWeapon()) && v:GetActiveWeapon():GetClass() == "weapon_mor_brood" then
				-- In alien form
				if v.Upgrades[UPGRADE.BREATH] then
					--v:EmitSound(table.Random(Sounds.Brood.Breath),80,100)
				else
					v:EmitSound(table.Random(Sounds.Brood.Breath),200,100) -- Breathing sound
				end
				local hpmax = 100
				if v.Upgrades[UPGRADE.HEALTH] then
					hpmax = hpmax + v.Upgrades[UPGRADE.HEALTH] * UPGRADE.HEALTH_AMOUNT
				end
				if v:Health() <= hpmax then

					local amt = 0

					if v.Upgrades[UPGRADE.REGEN] then
						amt = amt + (v.Upgrades[UPGRADE.REGEN] * UPGRADE.REGEN_AMOUNT)
					end
					
					v:SetHealth(math.Clamp(v:Health() + amt,0,hpmax))
				else
					v:SetHealth(hpmax)
				end
			else
				-- Not in alien form

			end
		elseif v:IsSwarm() && v:Alive() then
			v:SetSpeed()
			
			--Swarm Alien
			if v:Health() < 100 then
				v:SetHealth(v:Health() + 3)
			else
				v:SetHealth(100)
			end

		end

end


function IMPULSE.LOCATIONS()
	
	if !MISSION_LOCS then -- I dont want to run this every time
		if (GetRoundState() != ROUND_ACTIVE) then return end -- Call the first time the round is active
		MISSION_LOCS = {}

		local buffer = {} -- speed
		for i=1,4 do	
			MISSION_LOCS[i] = {}
			MISSION_LOCS[i] = ents.FindByClass(NEED_ENTS[i][1])
			buffer = ents.FindByClass(NEED_ENTS[i][2])
			table.Add(MISSION_LOCS[i],buffer)
			buffer = {}
		end
	else
		for i=1,4 do
			local ent = MISSION_LOCS[i][math.random( 1,table.Count(MISSION_LOCS[i]) )]
			local need_min, need_max = ent:WorldSpaceAABB()
			local need_pos = need_max - ((need_max - need_min) / 2)
			SetGlobalVector(NEED_ENTS[i][1], need_pos) --hurr durr
		end
	end

end


function IMPULSE.SWARM(k,v)
		if v:IsSwarm() && v:Team() == TEAM_GAME && v:Alive() then
			v:EmitSound(table.Random(Sounds.Alien.Normal),400,100)
		end
end


function IMPULSE.NEED(k,v) --s
	--if GetRoundState()!=ROUND_ACTIVE then return end
		if v:Alive() && v:Team() == TEAM_GAME && !(v:IsAlien()) then
			if (v.Mission_End < CurTime()) && (v.Mission != MISSION_NONE) && (v.Mission_Doing == false) then
				v:SetHealth(v:Health()-1)

				if v:Health() < 1 then
					v:Kill()
				end

			end

		end
end


function IMPULSE.GENERAL(k,v)
	
		if v:Alive() && v:Team() == TEAM_GAME && ValidEntity(v) && !v:GetNWBool("alienform",false) then
			local w = v.Weight
			v:CalcWeight()
			if w != v.Weight then
				v:SendWeight()
			end
		end
end