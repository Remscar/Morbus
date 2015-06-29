include( "shared.lua" )

function ENT:Draw()
	render.SetMaterial( Material( "effects/blood_core" ) )
	render.DrawSprite( self:GetPos(), 45, 45, Color(255,55,0,255))
end

