function EFFECT:Init( data )
sound.Play( "ambient/fire/ignite.wav" , self:GetPos(), 54, math.random( 82, 112 ))

local FlameEmitter = ParticleEmitter( data:GetOrigin() )
	for i = 0, 1 do
		if !FlameEmitter then return end
		local FlameParticle = FlameEmitter:Add( "effects/blood_core", data:GetOrigin() )

		if ( FlameParticle ) then
			FlameParticle:SetVelocity( VectorRand() * 55 )
			FlameParticle:SetLifeTime( 0 )
			FlameParticle:SetDieTime( 1.2 )
			FlameParticle:SetStartAlpha( 210 )
			FlameParticle:SetEndAlpha( 0 )
			FlameParticle:SetStartSize( 0 )
			FlameParticle:SetEndSize( 96 )
			FlameParticle:SetColor( 255, 5, 5, 255 )
			FlameParticle:SetRoll (math.Rand( -210, 210 ) )
			FlameParticle:SetRollDelta( math.Rand( -2.2, 2.2 ) )
			FlameParticle:SetAirResistance( 50 )
			FlameParticle:SetGravity( Vector( 0, 0, 115 ) )
		end
	end
	FlameEmitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end