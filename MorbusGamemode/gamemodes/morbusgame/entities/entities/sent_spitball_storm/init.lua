AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
function ENT:Initialize()
	self:SetModel( "models/weapons/W_missile_launch.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 0, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(155, 215, 255, 255), false, 15, 1, 0.2, 25, "trails/plasma.vmt")

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Created = CurTime()
end


function ENT:Think()
	self.tes = ents.Create( "point_tesla" ) -- extra electric effect
        self.tes:SetPos( self:GetPos() )
        self.tes:SetKeyValue( "m_SoundName", "" )
        self.tes:SetKeyValue( "texture", "sprites/bluelight1.spr" )
        self.tes:SetKeyValue( "m_Color", "255 255 255" )
        self.tes:SetKeyValue( "m_flRadius", "55" )
        self.tes:SetKeyValue( "beamcount_min", "1" )
        self.tes:SetKeyValue( "beamcount_max", "1" )
        self.tes:SetKeyValue( "thick_min", "2" )
        self.tes:SetKeyValue( "thick_max", "4" )
        self.tes:SetKeyValue( "lifetime_min", "0.1" )
        self.tes:SetKeyValue( "lifetime_max", "0.2" )
        self.tes:SetKeyValue( "interval_min", "0.1" )
        self.tes:SetKeyValue( "interval_max", "0.3" )
        self.tes:Spawn()
        self.tes:Fire( "DoSpark", "", 0 )
        self.tes:Fire( "kill", "", 0.1 )
	self:NextThink( CurTime() + 0.1 )
	return true
end


function ENT:Explode()
	-- SFX
	ParticleEffect( "spit_blast_storm2", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "weapons/demon/hit3.wav", 100, math.random(85,95) );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 115 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 7 )
		v:TakeDamageInfo( dmginfo )
	end

    	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 45 )) do
	        local dmginfo = DamageInfo()
	        dmginfo:SetAttacker( self:GetOwner() )
	        dmginfo:SetInflictor( self )
	        dmginfo:SetDamage( 4 )
	        v:TakeDamageInfo( dmginfo )
    	end

        self.tes = ents.Create( "point_tesla" ) -- extra electric effect
        self.tes:SetPos( self:GetPos() )
        self.tes:SetKeyValue( "m_SoundName", "" )
        self.tes:SetKeyValue( "texture", "sprites/bluelight1.spr" )
        self.tes:SetKeyValue( "m_Color", "255 255 255" )
        self.tes:SetKeyValue( "m_flRadius", "155" )
        self.tes:SetKeyValue( "beamcount_min", "2" )
        self.tes:SetKeyValue( "beamcount_max", "3" )
        self.tes:SetKeyValue( "thick_min", "8" )
        self.tes:SetKeyValue( "thick_max", "16" )
        self.tes:SetKeyValue( "lifetime_min", "0.1" )
        self.tes:SetKeyValue( "lifetime_max", "0.3" )
        self.tes:SetKeyValue( "interval_min", "0.1" )
        self.tes:SetKeyValue( "interval_max", "0.3" )
        self.tes:Spawn()
        self.tes:Fire( "DoSpark", "", 0 )
     	self.tes:Fire( "DoSpark", "", 0.1 )
        self.tes:Fire( "DoSpark", "", 0.1 )
        self.tes:Fire( "DoSpark", "", 0.2 )
        self.tes:Fire( "kill", "", 0.3 )
end


function ENT:PhysicsCollide( data, phys )
	self:Explode()
	self:Remove()
end
