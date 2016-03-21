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
		util.SpriteTrail(self.Entity, 0, Color(255, 85, 0, 255), false, 25, 1, 0.3, 45, "trails/plasma.vmt")

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Death = CurTime() + 5
	self.Created = CurTime()
end


function ENT:Think()
	ParticleEffect( "trail_fire", self:GetPos(), Angle(0, 0, 0), nil )

	if self.Death && self.Death < CurTime() then
		self:Explode()
		self:Remove()
	end

	self:NextThink( CurTime() + 0.1 )
	return true
end


function ENT:Explode()
	-- SFX
	ParticleEffect( "spit_blast_fire", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "weapons/demon/hit2.wav", 100, math.random(85,95) );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 135 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 8 )
		v:TakeDamageInfo( dmginfo )
	end
end


function ENT:PhysicsCollide( data, phys )
	self:Explode()
	self:Remove()
end
