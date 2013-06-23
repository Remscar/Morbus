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
			util.SpriteTrail(self.Entity, 0, Color(255, 155, 45, 255), false, 25, 0.5, 0.3, 45, "trails/plasma.vmt")
			

    		end

	if SERVER then
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
	if CLIENT then
	local vOffset = self:LocalToWorld( Vector(0, 0, self:OBBMins().z) )
	self.Emitter = ParticleEmitter( vOffset )
	end
	
	self.Created = CurTime()
end

function ENT:Think()
end

function ENT:Explode()

 
	
	local effectdata = EffectData()
	effectdata:SetNormal( Vector(0,0,1) )
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "YellowBlast", effectdata  )

	
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 45 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 25 )
			v:TakeDamageInfo( dmginfo )
		end
	end
	
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 105 )) do
		if v != self:GetOwner() then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker( self:GetOwner() )
			dmginfo:SetInflictor( self )
			dmginfo:SetDamage( 15 )
			v:TakeDamageInfo( dmginfo )
		end
	end
	





end


function ENT:PhysicsCollide( data, phys )
	self:Explode()
	self:Remove()

end

function ENT:OnRemove()

end