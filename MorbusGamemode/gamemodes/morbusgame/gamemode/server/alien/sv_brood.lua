// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
function CheckAlien()

	local tab = GetBroodList()

	for k,v in pairs(tab) do
		if ValidEntity(v) then
			if ValidEntity(v:GetActiveWeapon()) then

				if (!v:GetNWBool("alienform",false) && v:GetActiveWeapon():GetClass() == "weapon_mor_brood") then
					v:SetNWBool("alienform",true)
					Brood_Turn_Alien(v)
				elseif (v:GetNWBool("alienform",false) && v:GetActiveWeapon():GetClass() != "weapon_mor_brood") then
					v:SetNWBool("alienform",false)
					Brood_Turn_Human(v)
				end
			end

			if (v.NextTransform < CurTime()) && (v.CanTransform == false) then
				v.CanTransform = true
				Send_Transform(v,true)
			end
		end
	end

end


function Brood_Turn_Alien(ply)
	LIGHT.TurnOff(ply)
	ply:SetModel(Models.Brood)
	ply:EmitSound(Sounds.Brood.Transform, 300, 100 )

	if ply.Upgrades[UPGRADE.SPRINT] then
		GAMEMODE:SetPlayerSpeed(ply,BROOD_SPEED,BROOD_SPRINT + (ply.Upgrades[UPGRADE.SPRINT] * UPGRADE.SPRINT_AMOUNT))
	else
		GAMEMODE:SetPlayerSpeed(ply,BROOD_SPEED,BROOD_SPRINT)
	end


	if ply.Upgrades[UPGRADE.JUMP] then
		ply:SetJumpPower(DEFAULT_JUMP + (ply.Upgrades[UPGRADE.JUMP]*UPGRADE.JUMP_AMOUNT))
	else
		ply:SetJumpPower(DEFAULT_JUMP)
	end

	if ply.Upgrades[UPGRADE.HEALTH] then
		local h = ply:Health()
		local hm = 100 + ply.Upgrades[UPGRADE.HEALTH] * UPGRADE.HEALTH_AMOUNT
		ply:SetHealth((h/100)*hm)
	end

	if ply.Upgrades[UPGRADE.SCREAM] then
		local humans = GetHumanList()
		local p1 = ply:GetShootPos()
		local p2
		local dist = 600
		for k,v in pairs(humans) do
			p2 = v:GetShootPos()
			p2 = p1:Distance(p2) -- 3 R's
			if (p2 < dist) then
				p2 = math.Clamp(2-((p2*1.5)/dist),0,2)
				Send_Fear(v,p2)
			end
			p2 = nil
		end
	end


	for i=1,5 do
		for b=1,4 do
			local effectdata = EffectData()
			effectdata:SetOrigin(ply:GetPos() + Vector(0,0,i*10) )
			effectdata:SetNormal(ply:GetVelocity():GetNormal())
			util.Effect("bloodstream",effectdata)
		end
	end

	for i=2,3 do
		

		local gib_effect = EffectData()
		gib_effect:SetOrigin(ply:GetPos() + Vector(0,0,50))
		gib_effect:SetNormal(ply:GetVelocity():GetNormal())
		util.Effect("goremod_gib",gib_effect)
	end

	ply.CanTransform = false
	ply:SetNoDraw(false)
	ply:SetColor(Color(255,255,255,255))
	Send_Transform(ply,false)
	Cancel_Cloak(ply)
	ply.NextTransform = CurTime() + TRANSFORM_TIME




end

function Send_Fear(ply,int)
	umsg.Start("Send_Fear",ply)
	umsg.Short(int)
	umsg.End()
end


function Brood_Turn_Human(ply)
	LIGHT.TurnOff(ply)
	ply:SetModel(ply.WantedModel)
	GAMEMODE:SetPlayerSpeed(ply,HUMAN_SPEED,HUMAN_SPEED) 
	ply:SetJumpPower(DEFAULT_JUMP)
	ply:CalcWeight()
	ply:SetColor(Color(255,255,255,255))
	ply:SetNoDraw(false)
	Cancel_Cloak(ply)

	if ply.Upgrades[UPGRADE.HEALTH] then
		local h = ply:Health()
		local hm = 100 + (ply.Upgrades[UPGRADE.HEALTH] * UPGRADE.HEALTH_AMOUNT)
		local hm = h/hm
		ply:SetHealth(100*hm)
	end

end


