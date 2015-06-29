// View distortion, i decided i didn't like fucking with colors
// "models/props_lab/Tank_Glass001" 0.04
// "models/shadertest/shader3" 0.01

local mat_alien = Material( "models/props_lab/Tank_Glass001" )
local alien_refract = 0

local mat_insane = Material( "models/shadertest/shader1" )
local insane_refract = 0.01

local mat_insane2 = Material( "models/props_lab/Tank_Glass001" )
local insane_refract2 = 0.05

function DrawDistortion()
	local ply = LocalPlayer()


	if ply:GetBaseSanity() < 700 && ply:IsGame() && !ply:IsSwarm() && !ply:GetNWBool("alienform",false) then
		local mult = 0.3
		if ply:GetBaseSanity() < 500 then
			mult = 1
		end
		local mat_Overlay = mat_insane
		local refractamount = insane_refract * mult

		render.UpdateScreenEffectTexture()

		mat_Overlay:SetFloat("$envmap",			0)
		mat_Overlay:SetFloat("$envmaptint",		0)
		mat_Overlay:SetFloat("$refractamount",	refractamount)
		mat_Overlay:SetInt("$ignorez",		1)

		render.SetMaterial( mat_Overlay )
		render.DrawScreenQuad()

		if ply:GetBaseSanity() < 500 then

			local mat_Overlay = mat_insane2
			local refractamount = insane_refract2 * mult

			render.UpdateScreenEffectTexture()

			mat_Overlay:SetFloat("$envmap",			0)
			mat_Overlay:SetFloat("$envmaptint",		0)
			mat_Overlay:SetFloat("$refractamount",	refractamount)
			mat_Overlay:SetInt("$ignorez",		1)

			render.SetMaterial( mat_Overlay )
			render.DrawScreenQuad()
		end


		local colorMod = {}
	    colorMod["$pp_colour_addr"] = -0.05 * mult
	    colorMod["$pp_colour_addg"] = 0
	    colorMod["$pp_colour_addb"] = 0
	    colorMod["$pp_colour_brightness"] = 0
	    colorMod["$pp_colour_contrast"] = 1
	    colorMod["$pp_colour_colour"] = 1
	    colorMod["$pp_colour_mulr"] = 0.1 * mult
	    colorMod["$pp_colour_mulg"] = 0
	    colorMod["$pp_colour_mulb"] = 0

	     DrawColorModify(colorMod)
		return
	end
end

function DrawDistortionAlien()
	local ply = LocalPlayer()

	if GetConVar("morbus_hide_distortion"):GetBool() then return end

	if ply:GetNWBool("alienform",false) || ply:IsSwarm() then// && !GetConVar("morbus_hide_distortion"):GetBool() then
		local mat_Overlay = mat_alien
		local refractamount = alien_refract

		render.UpdateScreenEffectTexture()

		mat_Overlay:SetFloat("$envmap",			0)
		mat_Overlay:SetFloat("$envmaptint",		0)
		mat_Overlay:SetFloat("$refractamount",	refractamount)
		mat_Overlay:SetInt("$ignorez",		1)

		render.SetMaterial( mat_Overlay )
		render.DrawScreenQuad()
		return
	end
	-- if ply:IsSwarm() && ply:IsGame() then

	-- 	local colorMod = {}
	--     colorMod["$pp_colour_addr"] = 0.05
	--     colorMod["$pp_colour_addg"] = 0
	--     colorMod["$pp_colour_addb"] = 0
	--     colorMod["$pp_colour_brightness"] = 0
	--     colorMod["$pp_colour_contrast"] = 1
	--     colorMod["$pp_colour_colour"] = 1
	--     colorMod["$pp_colour_mulr"] = 0.2
	--     colorMod["$pp_colour_mulg"] = 0
	--     colorMod["$pp_colour_mulb"] = 0

	--      DrawColorModify(colorMod)
	-- end
end