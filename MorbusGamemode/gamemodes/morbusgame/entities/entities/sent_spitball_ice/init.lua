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
		util.SpriteTrail(self.Entity, 0, Color(15, 155, 255, 255), false, 25, 1, 0.3, 45, "trails/plasma.vmt")
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
	ParticleEffect( "trail_ice", self:GetPos(), Angle(0, 0, 0), nil )
	self:NextThink( CurTime() + 0.1 )
	return true
end


function ENT:Explode()

	
	-- SFX
	ParticleEffect( "energy_blast_cy", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "weapons/demon/hit1.wav", 100, math.random(125,155) );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 105 )) do
		local dmginfo = DamageInfo()
		if v:IsPlayer() then
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 6 )
		v:TakeDamageInfo( dmginfo )
		if v:IsPlayer() and v:IsAlien() then return end
			v:Freeze( true )
			v:SetColor( Color( 0,155,255,255 ) )
				timer.Simple(1, function()
					if !v:IsValid() then return end
					v:Freeze( false )
					v:SetColor( Color( 255,255,255,255 ) )
				end)
		end
	end

end


function ENT:PhysicsCollide( data, phys )

	self:Explode()
	self:Remove()

end


function ENT:OnRemove()

end