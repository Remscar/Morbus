include( "shared.lua" )

function ENT:Draw()
	render.SetMaterial( Material( "effects/blood_core" ) )
	render.DrawSprite( self:GetPos(), 45, 45, Color(185,55,25,255))
end