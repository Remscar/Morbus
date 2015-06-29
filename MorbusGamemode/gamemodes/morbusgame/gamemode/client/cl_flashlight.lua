// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

function GM:RenderScreenspaceEffects()
	GAMEMODE:DrawLights()
end


function LIGHT.TurnOn(ply)
	if !ply then return end
	ply.Light = true
end

function LIGHT.TurnOff(ply)
	if !ply then return end
	ply.Light = false
end

function LIGHT.RecieveBattery(data)
	local bat = data:ReadChar()
	if !LocalPlayer() then return end
	LocalPlayer().Battery = bat
	LocalPlayer().NextBattery = LIGHT.ToTime(LIGHT.Regen(LIGHT.Precent(bat)))
end
usermessage.Hook("SendBattery",LIGHT.RecieveBattery)

function LIGHT.RecieveLight(data)
	local on = data:ReadBool()
	if on then
		LIGHT.TurnOn(LocalPlayer())
	else
		LIGHT.TurnOff(LocalPlayer())
	end
end
usermessage.Hook("SendLight",LIGHT.RecieveLight)

function LIGHT.RecieveNV(data)
	local on = data:ReadBool()
	LocalPlayer().NightVision = on
end
usermessage.Hook("SendNV",LIGHT.RecieveNV)


function LIGHT.Think(ply) --Actually called every 0.25 second
	if !ply || !IsValid(ply) then return end
	if !ply:Alive() || ply:IsSwarm() then return end
	if ply:Team() == TEAM_SPEC then return end
	if ply.Light then

		if ply.Battery > 0 then

			ply.Battery = ply.Battery - 1
			if ply.Battery < 0 then
				LIGHT.TurnOff(ply)
			end
		else
			LIGHT.TurnOff(ply)
		end
	else
		
		/*if ply.Battery < LIGHT_BATTERY then

			ply.Battery = (ply.NextBattery/4) + ply.Battery
			if ply.Battery > LIGHT_BATTERY then

				ply.Battery = LIGHT_BATTERY
			end
		end*/
		
		
	end
end
timer.Create("SecondQImpulse",1,0,function() LIGHT.Think(LocalPlayer()) end)


function LIGHT.Draw(ply)
	if !GetGlobalBool("mutator_nightmare",false) then
  		local tall = 16
  		local wide = 70
  		local border = 3
 	 	local by = 62
	  	draw.RoundedBox(2,ScrW()/2-wide/2,ScrH()-by,wide,tall,Color(0,0,0,230))
	  	draw.RoundedBox(2,ScrW()/2-wide/2+border,ScrH()-by+border,wide-border*2,tall-border*2,Color(120,120,120,230))
 	 	local ratio = math.Clamp(ply.Battery/LIGHT_BATTERY,0,1)
 	 	draw.RoundedBox(0,ScrW()/2-wide/2+border,ScrH()-by+border,(wide-border*2)*ratio,tall-border*2,Color(255,205,0,230))
 	 	draw.RoundedBox(0,ScrW()/2-wide/2+border,ScrH()-by+border,(wide-border*2)*ratio,tall-border*4,Color(255,180,0,230))
	end
end

LightMat = Material( "sprites/light_ignorez" )
BeamMat	= Material( "effects/lamp_beam" )

function GM:DrawLights()


	-- for k,v in pairs( team.GetPlayers( TEAM_GAME ) ) do
	
	-- 	if not v.PixVis then
		
	-- 		v.PixVis = util.GetPixelVisibleHandle()
		
	-- 	end
		
	-- 	if v:GetNWBool( "Flashlight", false ) and v != LocalPlayer() then

	-- 		local id = v:LookupAttachment( "anim_attachment_LH" )
	-- 		local att = v:GetAttachment( id )
			
	-- 		if att then

			
	-- 			local vis = util.PixelVisible( att.Pos, 32, v.PixVis )
				
	-- 			local norm = ( att.Ang + Angle(0,90,0) ):Forward()
	-- 			local vnorm = ( att.Pos - EyePos() ):GetNormal()
				
				
	-- 			local dot = vnorm:Dot( norm * -1 )

				
	-- 			if dot > 0 and vis > 0 then
					
	-- 				local dist = math.Clamp( att.Pos:Distance( EyePos() ), 50, 500 )
	-- 				local size = math.Clamp( dist * dot, 2, 40 )
					
	-- 				local alpha = math.Clamp( ( 500 - dist ) * dot, 0, 255 )
	-- 				local col = Color( 255, 255, 200, alpha )


					
	-- 				cam.Start3D( EyePos(), EyeAngles() )
					
	-- 					render.SetMaterial( LightMat )
						
	-- 					render.DrawSprite( att.Pos, size, size, col )
	-- 					render.DrawSprite( att.Pos, size * 0.25, size * 0.25, Color( 255, 255, 255, alpha ) )
						
	-- 				cam.End3D()
					
	-- 			end
				
	-- 		end
			
	-- 	end
	
	-- end

end