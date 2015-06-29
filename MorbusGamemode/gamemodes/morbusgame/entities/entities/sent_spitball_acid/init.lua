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
		util.SpriteTrail(self.Entity, 0, Color(215, 255, 0, 255), false, 25, 1, 0.3, 45, "trails/plasma.vmt")
    end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end

	self.Sprayed = 0
	self.Created = CurTime()
end


function ENT:Think()
	if self.Sprayed == 1 then
		-- Damage in sphere
		for _, v in ipairs(ents.FindInSphere( self:GetPos(), 135 )) do
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 1 )
			v:TakeDamageInfo( dmginfo )
		end
	end
end


function ENT:Explode()

	if self.Sprayed == 1 then return end
	self.Sprayed = 1
	
	-- SFX
	ParticleEffect( "spit_blast_acid", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "ns_sounds/bilebombfire.wav", 100, 100 )

	timer.Simple(2, function()
		self:Remove()
	end)

end


function ENT:PhysicsCollide( data, physobj )

    	self:Explode()
    	self:SetMoveType( MOVETYPE_NONE )
    	self:SetSolid( SOLID_NONE )
end


function ENT:OnRemove()

end