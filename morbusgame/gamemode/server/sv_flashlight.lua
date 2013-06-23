// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
/*-------------------------
JEsus a whole file!
-------------------------*/

function GM:PlayerSwitchFlashlight(ply, on)
   if !ValidEntity(ply) then return false end
   if ply:Team() == TEAM_SPEC || ply:IsSwarm() then
   	ply.NightVision = !ply.NightVision
   	LIGHT.SendNightVision(ply)
   	return false
   end
   if !ply:IsSwarm() && ply:IsGame() && ply:Alive() && !ply:GetNWBool("alienform",false) && !GetGlobalBool("mutator_nightmare", false) then
      if !ply.Light && (ply.Battery > 1) then
         --ply:AddEffects(EF_DIMLIGHT)
         ply:EmitSound( "items/flashlight1.wav", 50, 110 )
         LIGHT.TurnOn(ply)
      else
         --ply:RemoveEffects(EF_DIMLIGHT)
         LIGHT.TurnOff(ply)
         ply:EmitSound( "items/flashlight1.wav", 50, 90 )
      end
   else
   	if !on then
   		LIGHT.TurnOff(ply)
   		ply:SetNWBool( "Flashlight", false )
   		ply:RemoveEffects(EF_DIMLIGHT)
   	end
   end
   return false
end

function LIGHT.TurnOn(ply)
	ply.Light = true
	ply:AddEffects(EF_DIMLIGHT)
	LIGHT.SendStatus(ply)
	LIGHT.SendBattery(ply)
	ply.FakeLight = true
	ply.Battery = ply.Battery - 1

	local c = Color( 255, 255, 200 ) 
	local b = 1
	local size = 60
	local len = 600
	  
	-- ply.FlashlightEnt = ents.Create( "sent_flashlight" )
	-- ply.FlashlightEnt:CreateLight( c, b, size, len )
	-- ply.FlashlightEnt:SetOwner( ply )
	-- ply.FlashlightEnt:SetPos( ply:GetShootPos())
	-- ply.FlashlightEnt:SetAngles( ply:GetAimVector():Angle() )
	-- ply.FlashlightEnt:Spawn()
	  
	
	ply:SetNWBool( "Flashlight", true )
end

function LIGHT.TurnOff(ply)
	ply.Light = false
	ply:RemoveEffects(EF_DIMLIGHT)
	LIGHT.SendStatus(ply)
	LIGHT.SendBattery(ply)
	ply.FakeLight = false

	if IsValid( ply.FlashlightEnt ) then
      //ply.FlashlightEnt:Remove()
    end
    
end

function LIGHT.FakeOff(ply)
	ply.FakeLight = false
	ply:RemoveEffects(EF_DIMLIGHT)
end

function LIGHT.FakeOn(ply)
	ply.FakeLight = true
	ply:AddEffects(EF_DIMLIGHT)
end

function LIGHT.SendStatus(ply)
	umsg.Start("SendLight",ply)
	umsg.Bool(ply.Light)
	umsg.End()
end

function LIGHT.SendBattery(ply)
	umsg.Start("SendBattery",ply)
	umsg.Long(ply.Battery)
	umsg.End()
end

function LIGHT.SendNightVision(ply)
	umsg.Start("SendNV",ply)
	umsg.Bool(ply.NightVision)
	umsg.End()
end

function LIGHT.Think(ply) --Actually called every 1 second
	if ply.Light then

		if ply.Battery > 0 then

			ply.Battery = ply.Battery - 1

			if ply.Battery < 2 then
				if ply.FakeLight then
					--LIGHT.FakeOff(ply)
				else
					--LIGHT.FakeOn(ply)
				end
			end

			if ply.Battery <= 0 then
				ply.Battery = 0
				LIGHT.TurnOff(ply)
			end
		else
			ply.Battery = 0
			LIGHT.TurnOff(ply)
		end
	else

		if ply.Battery && ply.Battery < LIGHT_BATTERY then

			ply.Battery = LIGHT.ToTime(LIGHT.Regen(LIGHT.Precent(ply.Battery))) + ply.Battery

			if ply.Battery > LIGHT_BATTERY then

				ply.Battery = LIGHT_BATTERY
			end
			LIGHT.SendBattery(ply)
		end
	end
end