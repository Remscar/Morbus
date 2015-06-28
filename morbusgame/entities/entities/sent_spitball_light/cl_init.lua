include( "shared.lua" )

function ENT:Draw()
	render.SetMaterial( Material( "Sprites/light_glow02_add" ) )
	render.DrawSprite( self:GetPos(), 45, 45, Color(255,215,155,255))
end

/*function ENT:Think()
	self:NextThink( 0 )
		local emitter = self.Emitter
		if !emitter then return end

		local vPos = Vector( 1, 1, 0 )
		local R = math.Rand( 0.8, 1 )
		local vOffset = self:LocalToWorld( Vector(-5, 0, self:OBBMins().z+5) )

		emitter:SetPos( vOffset )
		
			
			local smoke = emitter:Add( "effects/blood_core", vOffset + vPos )
			smoke:SetVelocity( VectorRand() * math.Rand(-25,25) )
			smoke:SetGravity( Vector( math.Rand(-200,200), math.Rand(-100,100), math.Rand(45,100) ) )
			smoke:SetDieTime( math.Rand(0.5,0.7) )
			smoke:SetStartAlpha( 100 ) 
			smoke:SetStartSize( math.Rand( 15,25) )
			smoke:SetEndSize( math.Rand( 1,3 ) )
			smoke:SetRoll( math.Rand(-180,180) )
			smoke:SetRollDelta( math.Rand(-0.2,0.2) )
			smoke:SetColor( 0, 155, 0 )
			smoke:SetAirResistance( 10 )
			smoke:SetCollide( true )



		for i = 1,10 do
			local smoke = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), vOffset + vPos )
			smoke:SetVelocity( Vector(0,0,0) )
			smoke:SetGravity( Vector( math.Rand(-100,100), math.Rand(-100,100),math.Rand(0,100) ) )
			smoke:SetDieTime( 0.02 )
			smoke:SetStartAlpha( 255 )
			smoke:SetStartSize( math.Rand(5,7))
			smoke:SetEndSize( 2 )
			smoke:SetRoll( math.Rand(-180,180) )
			smoke:SetRollDelta( math.Rand(-0.2,0.2) )
			smoke:SetColor( 255, 255, 255 )
			smoke:SetAirResistance( 10 )
			smoke:SetCollide( true )
		end
		self.Emitter:Finish()
	
	return true
end