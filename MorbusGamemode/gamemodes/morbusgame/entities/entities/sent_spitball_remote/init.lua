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
	self.Death = CurTime() + 10
	self.Created = CurTime()
	self.Exploded = 0
end


function ENT:Think()
	if self.Exploded == 1 then
		self:Explode()
		self:Remove()
	end
	if self.Death && self.Death < CurTime() then
		self:Explode()
		self:Remove()
	end
end


function ENT:Explode()

	
	-- SFX
	ParticleEffect( "spit_blast", self:GetPos(), Angle(0, 0, 0), nil )
	self.Entity:EmitSound( "alien/acid_hit.wav", 100, math.random(95,125) );

	-- Damage in sphere
	for _, v in ipairs(ents.FindInSphere( self:GetPos(), 105 )) do
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker( self:GetOwner() )
		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 11 )
		v:TakeDamageInfo( dmginfo )
	end

end

function ENT:PhysicsCollide( data, physobj )
  if IsValid(self:GetParent()) then return end
  if data.HitEntity then
    ent = data.HitEntity
    if ent:IsWorld() then
      self:SetMoveType(MOVETYPE_NONE)
      self:SetPos(data.HitPos - data.HitNormal * 1.2)
      flip = 1
      if data.HitNormal.y > 0 then
        flip = -1
      end
      self:SetAngles(Angle(0,data.HitNormal.y + data.HitNormal.x,-data.HitNormal.z * flip) * 90)
    elseif ent:IsPlayer() and !ent:IsWeapon() then
      self:SetPos(data.HitPos - data.HitNormal )
      flip = 1
      if data.HitNormal.y > 0 then
        flip = -1
      end
      self:SetAngles(Angle(0,data.HitNormal.y + data.HitNormal.x,-data.HitNormal.z * flip) * 90)
   	  self:SetSolid( SOLID_NONE )
      self:SetParent(ent)
    end
  end
end




function ENT:OnRemove()

end