include( "shared.lua" )

function ENT:Draw()
	--self:DrawModel()
	render.SetMaterial( Material( "effects/blood_core" ) )
	render.DrawSprite( self:GetPos(), 45, 45, Color(25,155,0,255))
end
