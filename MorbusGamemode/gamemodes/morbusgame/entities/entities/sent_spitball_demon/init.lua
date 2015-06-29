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
		util.SpriteTrail(self.Entity, 0, Color(115, 5, 255, 255), false, 25, 1, 0.3, 45, "trails/plasma.vmt")
    end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Created = CurTime()
end


function ENT:Think()
	ParticleEffect( "trail_demon", self:GetPos(), Angle(0, 0, 0), nil )
	self:NextThink( CurTime() + 0.1 )
	return true
end


function ENT:Explode()

	
	-- SFX
	ParticleEffect( "spit_blast_demon", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "alien/acid_hit.wav", 100, math.random(85,95) );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 115 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 8 )
		v:TakeDamageInfo( dmginfo )
		if v:IsPlayer() and !v:IsAlien() then
			v:Ignite(0.8)
		end
	end

end


function ENT:PhysicsCollide( data, phys )

	self:Explode()
	self:Remove()

end


function ENT:OnRemove()

end