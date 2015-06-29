include( "shared.lua" )

function ENT:Draw()
	--self:DrawModel()
	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
	render.DrawSprite( self:GetPos(), 50, 50, Color(255,155,25,255))
end