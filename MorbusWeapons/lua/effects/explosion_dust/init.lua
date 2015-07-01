

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

if GetConVarNumber( "sh_fx_explosiveeffects" ) == 0 then
return end
	
	local Pos = data:GetOrigin()
	local Norm = data:GetNormal()
	local Scale = data:GetScale()
	
	local SurfaceColor = render.GetSurfaceColor( Pos+Norm, Pos-Norm*100 ) * 255

	
	local Dist = LocalPlayer():GetPos():Distance( Pos )

	local FleckSize = math.Clamp( Dist * 0.01, 8, 64 )
		
	local emitter = ParticleEmitter( Pos + Norm * 32 )
	
	
	emitter:SetNearClip( 0, 128 )
	
		for i=1, 50 do
			local ColorRand = math.Rand(50,150)
		
			local particle = emitter:Add( "effects/dust", Pos + Norm * 1 )
				particle:SetVelocity( VectorRand() * 1000 )
				particle:SetDieTime( math.Rand(3, 6) )
				particle:SetStartAlpha( math.Rand ( 100, 255 ) )
				particle:SetStartSize( math.Rand( 25, 50 ) )
				particle:SetEndSize( math.Rand( 100, 200 ) )
				particle:SetRoll( math.Rand ( 180, -180 ) )
				particle:SetColor(Color(ColorRand, ColorRand, ColorRand ))
				particle:SetGravity( Vector( 0, 0, math.Rand( -150, -60 ) ) )
				particle:SetAirResistance( 400 )
				particle:SetCollide(true)
		
		end
		
		for i=0, 10 do
		
			local particle = emitter:Add( "effects/fire_embers1", Pos + Norm * 0 )
			
				particle:SetVelocity( Norm * 500 + VectorRand() * 500 )
				particle:SetDieTime( math.Rand(0.05, 0.1) )
				particle:SetStartAlpha( math.Rand ( 200, 200 ))
				particle:SetStartSize( math.Rand( 20, 30 ) )
				particle:SetEndSize( 300 )
				particle:SetRoll( math.Rand ( 180, -180) )
				particle:SetColor(Color( 200, 150, 150 ))
				particle:SetGravity( Vector( 0, 0, math.Rand( -20, -50 ) ) )
				particle:SetAirResistance( 500 )
				particle:SetCollide(true)
				
		end
		
	emitter:Finish()
	
	-----------------------LOW--------------------------
		
for i=0, 10 do
		
			local particle = emitter:Add( "particle/particle_smokegrenade", Pos + Norm * 1 )
				particle:SetVelocity( Norm * math.Rand( 500, 800 ) + VectorRand() * 200 )
				particle:SetDieTime( math.Rand(1, 3) )
				particle:SetStartAlpha( math.Rand( 10, 50 ) )
				particle:SetStartSize( math.Rand( 10, 20 ) )
				particle:SetEndSize( math.Rand( 300, 400 ) )
				particle:SetRoll( math.Rand ( -180, -180 ) )
				particle:SetColor(Color( 100, 100, 100 ))
				particle:SetGravity( Vector( 0, 0, math.Rand( -150, -60 ) ) )
				particle:SetAirResistance( 200 )
		
		end

		for i=0, 5 do
		
			local particle = emitter:Add( "particle/particle_smokegrenade", Pos + Norm * 0 )
			
				particle:SetVelocity( Norm * 700 + VectorRand() * 500 )
				particle:SetDieTime( math.Rand(5, 10) )
				particle:SetStartAlpha( math.Rand ( 20, 50 ))
				particle:SetStartSize( math.Rand( 20,30 ) )
				particle:SetEndSize( 500 )
				particle:SetRoll( math.Rand ( 180, -180) )
				particle:SetColor(Color( 100, 100, 100 ))
				particle:SetGravity( Vector( 0, 0, math.Rand( -20, -50 ) ) )
				particle:SetAirResistance( 200 )
				
		end
		
		for i=0, 5 do
		
			local particle = emitter:Add( "effects/fire_embers1", Pos + Norm * 0 )
			
				particle:SetVelocity( Norm * 500 + VectorRand() * 500 )
				particle:SetDieTime( math.Rand(0.1, 0.5) )
				particle:SetStartAlpha( math.Rand ( 200, 200 ))
				particle:SetStartSize( math.Rand( 20, 30 ) )
				particle:SetEndSize( 155 )
				particle:SetRoll( math.Rand ( 180, -180) )
				particle:SetColor(Color( 200, 200, 200 ))
				particle:SetGravity( Vector( 0, 0, math.Rand( -20, -50 ) ) )
				particle:SetAirResistance( 500 )
				
		end
		
	emitter:Finish()
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()	
end



