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
		util.SpriteTrail(self.Entity, 0, Color(25, 155, 0, 255), false, 25, 1, 0.3, 45, "trails/plasma.vmt")
    end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Created = CurTime()
	self.Remotes = 0
end


function ENT:Think()

end


function ENT:Explode()

	-- SFX
	ParticleEffect( "spit_blast", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "alien/acid_hit.wav", 100, math.random(95,125) )


	if SERVER then
		for i = 1, 1 do
			local parasite = ents.Create( "monster_hlfd_infection_h3" )
			parasite:SetPos( self:GetPos() + Vector( 0, 0, 5 ) )
			parasite:SetOwner( self:GetOwner() )
			parasite:Spawn()
		end
	end
	
end


function ENT:PhysicsCollide( data, phys )

	self:Explode()
	self:Remove()

end


function ENT:OnRemove()

end