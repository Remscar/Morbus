/*------------------------------ 
Beta Night Vision
-------------------------------*/

function NightVision()
	local dlight = DynamicLight( LocalPlayer():EntIndex() )
	local clr = Color(255,165,50,255)
	if (LocalPlayer().Cloaked) && LocalPlayer():IsBrood() then
		clr = Color(50,50,255,255)
	end
	if (LocalPlayer():IsSpec()) then
		clr = Color(200,200,200,255)
	end
	if ( dlight ) then
			dlight.Pos = LocalPlayer():GetShootPos()
			dlight.r = clr.r
			dlight.g = clr.g
			dlight.b = clr.b
			dlight.Brightness = 1
			dlight.Size = 1300
			dlight.Decay = 1300
			dlight.DieTime = CurTime() + 1
	end
end
