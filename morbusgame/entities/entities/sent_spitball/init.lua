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
	if CLIENT then
	local vOffset = self:LocalToWorld( Vector(0, 0, self:OBBMins().z) )
	self.Emitter = ParticleEmitter( vOffset )
	end
	
	self.Created = CurTime()
end

function ENT:Think()
end

function ENT:Explode()

	local MDMG = 20
	local NERF = 10

	local mult = math.Clamp(#player.GetAll(),3,20)
    mult = (mult-3)/17
    mult = 1-mult
    mult = NERF*mult -- how much lower?
    local dmg = MDMG - NERF
    dmg = dmg + mult
    dmg = math.Round(dmg)
	
	local effectdata = EffectData()
	effectdata:SetNormal( Vector(0,0,1) )
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "SpitBlast", effectdata  )

	
	
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 105 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.Round(dmg*0.75) )
		v:TakeDamageInfo( dmginfo )
	end
	





end


function ENT:PhysicsCollide( data, phys )
	self:Explode()
	self:Remove()

end

function ENT:OnRemove()

end