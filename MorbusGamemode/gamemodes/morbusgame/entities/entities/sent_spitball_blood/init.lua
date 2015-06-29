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
		util.SpriteTrail(self.Entity, 0, Color(195, 25, 25, 255), false, 25, 1, 0.3, 45, "trails/plasma.vmt")
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

end


function ENT:Explode()


	
	-- SFX
	ParticleEffect( "spit_blast_blood", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "alien/acid_hit.wav", 100, math.random(95,125) );

	-- Damage in sphere
	local you = self:GetOwner()
	local heal = 20
	local healok = 0
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 105 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 10 )
		v:TakeDamageInfo( dmginfo )
		if v:IsPlayer() and v:IsAlien() then return end
			self.healok = 1
	end

	if self.healok == 1 then
		if you:Health() == 100 then return end
			if you:Health() + heal > 99 then
				you:SetHealth( 100 )
			elseif you:Health() + heal <= 99 then
				you:SetHealth( you:Health() + heal )
			end
	end

	self.healok = 0

end


function ENT:PhysicsCollide( data, phys )

	self:Explode()
	self:Remove()

end


function ENT:OnRemove()

end