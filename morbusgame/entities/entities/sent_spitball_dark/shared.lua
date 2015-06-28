ENT.Type = "anim"

ENT.PrintName		= "Plasbolt"
ENT.Author			= "Demonkush"

function ENT:Initialize()
	self:SetModel( "models/weapons/W_missile.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetColor(Color(0,0,0,0))

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

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


-- THIS IS FOR NETWORK SYNCRONIZATION OF COOK TIMES --
-- You get/set the current value with ENTITY:Get/SetDuration()
function ENT:SetupDataTables()
	self:DTVar( "Float", 0, "Duration" )
end

function ENT:PhysicsCollide( data, phys )
	self:Explode()
	self:Remove()
end
