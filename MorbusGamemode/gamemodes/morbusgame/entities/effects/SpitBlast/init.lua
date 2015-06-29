function EFFECT:Init(ed)

	local vOrig = ed:GetOrigin()
	
	local pe = ParticleEmitter(vOrig)
	
	for i= 1, math.random(25, 45) do

		local part = pe:Add("effects/blood_core", vOrig)

		if (part) then

			part:SetColor(0, 185, 0, math.random(150, 255))
			part:SetVelocity(VectorRand():GetNormal() * math.random(10, 75))
			part:SetRoll(math.Rand(0, 360))
			part:SetRollDelta(math.Rand(-15, 15))
			part:SetDieTime(0.5)
			part:SetLifeTime(0)
            		part:SetGravity( Vector( 0, 0, -85 ) );
			part:SetStartSize(math.random(5,8))
			part:SetEndSize(0)
            		part:SetCollide( false );
			part:SetEndAlpha(0)

		end

	end	
	
	for i= 1, math.random(5, 10) do

		local part = pe:Add("effects/blood_core", vOrig)

		if (part) then

			part:SetColor(0, 155, 0, math.random(150, 255))
			part:SetVelocity(VectorRand():GetNormal() * math.random(40, 85))
			part:SetRoll(math.Rand(0, 360))
			part:SetRollDelta(math.Rand(-15, 15))
			part:SetDieTime(0.8)
			part:SetLifeTime(0)
            		part:SetGravity( Vector( 0, 0, 0 ) );
			part:SetStartSize(math.random(15,18))
			part:SetEndSize(0)
            		part:SetCollide( false );
			part:SetEndAlpha(0)

		end

	end	
	
	for i= 1, math.random(15, 25) do

		local part = pe:Add("effects/blood_core", vOrig)

		if (part) then

			part:SetColor(0, 185, 0, math.random(150, 255))
			part:SetVelocity(VectorRand():GetNormal() * math.random(25, 85))
			part:SetRoll(math.Rand(0, 360))
			part:SetRollDelta(math.Rand(-2, 2))
			part:SetDieTime(0.8)
			part:SetLifeTime(0)
            		part:SetGravity( Vector( 0, 0, -85 ) );
			part:SetStartSize(math.random(10, 15))
			part:SetEndSize(0)
            		part:SetCollide( true );
            		part:SetBounce( 0 );
			part:SetEndAlpha(0)

		end

	end	
	
	for i= 1, math.random(10, 15) do

		local part = pe:Add("particle/particle_smokegrenade", vOrig)

		if (part) then

			part:SetColor(255, 185, 14, math.random(150, 255))
			part:SetVelocity(VectorRand():GetNormal() * math.random(5, 35))
			part:SetRoll(math.Rand(0, 360))
			part:SetRollDelta(math.Rand(-1, 1))
			part:SetDieTime(1)
			part:SetLifeTime(0)
            		part:SetGravity( Vector( 0, 0, 0 ) );
			part:SetStartSize(math.random(5, 15))
			part:SetEndSize(2)
            		part:SetCollide( false );
			part:SetEndAlpha(0)

		end

	end	
	
	for i= 1, math.random(2, 5) do

		local part = pe:Add("effects/blood_core", vOrig)

		if (part) then

			part:SetColor(255, 105, 15, math.random(150, 255))
			part:SetVelocity(VectorRand():GetNormal() * math.random(15, 135))
			part:SetRoll(math.Rand(0, 360))
			part:SetRollDelta(math.Rand(-1, 1))
			part:SetDieTime(0.1)
			part:SetLifeTime(0)
            		part:SetGravity( Vector( 0, 0, 0 ) );
			part:SetStartSize(math.random(45, 55))
			part:SetEndSize(12)
            		part:SetCollide( false );
			part:SetEndAlpha(0)

		end
		
	end	
				for i = 1,10 do
				
				if (part) then
					local part = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), vOffset + vPos )
					part:SetVelocity( Vector(0,0,0) )
					part:SetGravity( Vector( math.Rand(-100,100), math.Rand(-100,100),math.Rand(0,100) ) )
					part:SetDieTime( 0.05 )
					part:SetStartAlpha( 255 )
					part:SetStartSize( math.Rand(75,155))
					part:SetEndSize( 10 )
					part:SetRoll( math.Rand(-180,180) )
					part:SetRollDelta( math.Rand(-0.2,0.2) )
					part:SetColor(255, 255, 255 )
					part:SetAirResistance( 10 )
					part:SetCollide( true )
		end

	end
	
	
	pe:Finish()
	
	local effectdata = EffectData()
		effectdata:SetOrigin( vOrig )
		
		sound.Play("alien/acid_hit.wav", vOrig, 100, math.random(95,125))

				    

end

function EFFECT:Think()

	return false
	
end

function EFFECT:Render()
end