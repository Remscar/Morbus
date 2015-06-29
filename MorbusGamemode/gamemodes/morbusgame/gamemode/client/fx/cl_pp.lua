// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team



function ScreenEffects()

	local ply = LocalPlayer()

	if ply:IsGame() && !ply:GetNWBool("alienform",false) then
      DrawDistortion()
   	end

	if !Morbus.Blinded then	
		PostProcess()
    else
    	Blind()
    end
    
   	if !ply.Fear then return end

	if ply.Fear > CurTime() then
	  local f1 = (ply.Fear - CurTime())
	  local f2 = ply.FearInt or 2

	  if ply.Fear-1 > CurTime() then
	     local colorMod = {}
	     colorMod["$pp_colour_addr"] = 0
	     colorMod["$pp_colour_addg"] = 0
	     colorMod["$pp_colour_addb"] = 0
	     colorMod["$pp_colour_brightness"] = 0
	     colorMod["$pp_colour_contrast"] = 0.1
	     colorMod["$pp_colour_colour"] = 1
	     colorMod["$pp_colour_mulr"] = 0
	     colorMod["$pp_colour_mulg"] = 0
	     colorMod["$pp_colour_mulb"] = 0

	     DrawColorModify(colorMod)
	  end


	  DrawMotionBlur( 0.1, f1*f2, 0.05)

	end

	

end
hook.Add("RenderScreenspaceEffects","Stuff",ScreenEffects)

function GetCloak(data)
	local cloaktime = data:ReadFloat()
	local ply = LocalPlayer()
	if !ValidEntity(ply) then return end
	ply.Cloaked = true
end
usermessage.Hook("Send_Cloaking",GetCloak)

function CancelCloak(data)
	local ply = LocalPlayer()
	if !ValidEntity(ply) then return end
	ply.Cloaked = false
end
usermessage.Hook("Cancel_Cloaking",CancelCloak)


function PostProcess()
	if !LocalPlayer():Alive() then return end
	if LocalPlayer():IsSwarm() then return end
	local ply = LocalPlayer()
	local amt = 0


	local colorMod = {}
	colorMod["$pp_colour_addr"] = 0
	colorMod["$pp_colour_addg"] = 0
	colorMod["$pp_colour_addb"] = 0
	colorMod["$pp_colour_brightness"] = 0
	colorMod["$pp_colour_contrast"] = 1
	colorMod["$pp_colour_colour"] = math.Clamp((0.95 * (LocalPlayer():Health() / 100)),0.6,1)
	colorMod["$pp_colour_mulr"] = 0
	colorMod["$pp_colour_mulg"] = 0
	colorMod["$pp_colour_mulb"] = 0
	
	DrawColorModify(colorMod)
	DrawBloom(0, 0.5, 2, 2, 1, 1, 1 - (LocalPlayer():Health() / 30), 1 - (LocalPlayer():Health() / 30), 1 - (LocalPlayer():Health() / 30))
end



function Blind()
	local ColorModify = {}
	ColorModify[ "$pp_colour_addr" ] 		= 0
	ColorModify[ "$pp_colour_addg" ] 		= 0
	ColorModify[ "$pp_colour_addb" ] 		= 0
	ColorModify[ "$pp_colour_brightness" ] 	= 0
	ColorModify[ "$pp_colour_contrast" ] 	= 0
	ColorModify[ "$pp_colour_colour" ] 		= 0
	ColorModify[ "$pp_colour_mulr" ] 		= 0
	ColorModify[ "$pp_colour_mulg" ] 		= 0
	ColorModify[ "$pp_colour_mulb" ] 		= 0
	DrawColorModify( ColorModify )
end