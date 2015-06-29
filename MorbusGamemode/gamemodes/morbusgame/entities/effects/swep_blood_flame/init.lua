function EFFECT:Init( data )
local StartPos 	= data:GetStart()
local HitPos 	= data:GetOrigin()
	if data:GetEntity():IsValid() then

		local FlameEmitter = ParticleEmitter( StartPos )
		for i = 0, 1 do
			if !FlameEmitter then return end

			local FlameParticle = FlameEmitter:Add( "effects/blood_core", StartPos )
			if ( FlameParticle ) then
				FlameParticle:SetVelocity( (( HitPos - StartPos ):GetNormal() * math.random( 2720, 2820 )) + ( VectorRand() * math.random( 95, 150 ) ) )
				FlameParticle:SetLifeTime( 0 )
				FlameParticle:SetDieTime( 0.75 )
				FlameParticle:SetStartAlpha( math.random( 92, 132 ) )
				FlameParticle:SetEndAlpha( 0 )
				FlameParticle:SetStartSize( math.random( 2, 4 ) )
				FlameParticle:SetEndSize( math.random( 65, 95 ) )
				FlameParticle:SetColor( 255, 5, 5, 255 )
				FlameParticle:SetRoll( math.Rand( -360, 360 ) )
				FlameParticle:SetRollDelta( math.Rand( -7.2, 7.2 ) )
				FlameParticle:SetAirResistance( math.random( 128, 256 ) )
				FlameParticle:SetCollide( true )
				FlameParticle:SetGravity( Vector (0, 0, 564 ) )
			end
		end
		FlameEmitter:Finish()
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end