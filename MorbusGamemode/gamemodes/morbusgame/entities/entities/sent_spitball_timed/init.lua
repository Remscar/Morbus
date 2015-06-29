AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
function ENT:Initialize()
	self:SetModel("models/weapons/w_eq_fraggrenade.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetColor(Color( 255, 255, 0, 0 ))
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetGravity(0.2)
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )

	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	
	
	if SERVER then
		util.SpriteTrail(self.Entity, 0, Color(25, 155, 0, 255), false, 25, 1, 0.3, 45, "trails/plasma.vmt")
    end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
		end
	end

	self.Created = CurTime()
end


function ENT:Think()
	ParticleEffect( "spit_timed_pulse", self:GetPos(), Angle(0, 0, 0), nil )
end


function ENT:Explode()

	
	-- SFX
	ParticleEffect( "spit_blast_enhanced", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "alien/acid_hit.wav", 100, math.random(95,125) );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 155 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 5 )
		v:TakeDamageInfo( dmginfo )
	end

end


local BounceSnd = Sound( "alien.Impact2" )
function ENT:PhysicsCollide( data, phys )
if data.Speed > 5 then
	self:EmitSound( BounceSnd )
end
local impulse = (-data.Speed * data.HitNormal * .6 + (data.OurOldVelocity * -.8))*0.2
phys:ApplyForceCenter( impulse )
	
if self.Exploded == true then return end
	self.Exploded = true
	timer.Simple(1, function()
	if !self.Entity:IsValid() then return end
		self:Explode()
		self:Remove()
	end)

end


function ENT:Touch( hitEnt )

	if ( hitEnt:IsValid() and hitEnt:IsPlayer() ) then
	self.Exploded = true
		self:Explode()
		self:Remove()
	end
end