include( "shared.lua" )

function ENT:Draw()
	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
	render.DrawSprite( self:GetPos(), 45, 45, Color(195,215,255,255))
end
