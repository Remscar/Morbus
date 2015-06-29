gib_models = {

	"models/props_junk/watermelon01_chunk02a.mdl",
	"models/Gibs/HGIBS_scapula.mdl"
}

function EFFECT:Init(data)

	local pos = data:GetOrigin()
	local dir = data:GetNormal()

	local vNBounds,vBounds = Vector(-1,-1,-1), Vector(1,1,1)
	
	self.ent = ClientsideModel(table.Random(gib_models), RENDERGROUP_OPAQUE)
    self.ent:SetPos(pos + dir * 16)
    self.ent:PhysicsInitBox(vNBounds, vBounds)
    self.ent:SetCollisionBounds(vNBounds, vBounds)
    self.ent:SetModelScale(math.random(1,1.5),0)
    self.ent:SetMaterial("models/flesh")
    self.ent:GetPhysicsObject():SetMaterial("models/flesh")
    self.ent:GetPhysicsObject():ApplyForceCenter(VectorRand() * math.Rand(200, 400))
	
	self.LifeTime = CurTime() + math.Rand( 15, 25 )
	self.MaxLifeTime = CurTime() + math.Rand( 15, 25 )

	self.NextThink = CurTime() +  math.Rand( 0, 1 )
end

function EFFECT:Think()
	local Pos = self.ent:GetPos()
	local Phys = self.ent:GetPhysicsObject()

	local Vel = Phys:GetVelocity()

	if self.MaxLifeTime < CurTime() then return false end

		
		
	Vel:Normalize()
		
	local tr = util.TraceLine{start = Pos,endpos = Pos + Vel * 5,filter = self}
			
	if (!tr.Hit) then
			
		if (self.LifeTime && self.LifeTime < CurTime()) then
			
			self.ent:Remove()
			self:Remove()
			
			return false
		end

		if !self.LifeTime then
			self.LifeTime = CurTime() + 5
		end

		return true
	end
	
	util.Decal("Blood",tr.HitPos + tr.HitNormal,tr.HitPos - tr.HitNormal*10)
	
	local BloodEffect = EffectData()
	BloodEffect:SetOrigin(self.ent:GetPos())
	BloodEffect:SetNormal(self.ent:GetVelocity():GetNormal())
	util.Effect("bloodsplash",BloodEffect)
	
		


	return true
end

function EFFECT:Render()

	self.ent:DrawModel()
end