if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if ( CLIENT ) then
	language.Add ("ent_frag_grenade", "Frag Grenade") --wtf
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Frag Grenade"
	SWEP.Slot				= 4
	SWEP.SlotPos			= 0
end


SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.HoldType			= "grenade"

SWEP.ViewModel 					= "models/weapons/v_eq_fraggrenade.mdl"
SWEP.WorldModel 				= "models/weapons/w_eq_fraggrenade.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay		= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AllowDrop = true
SWEP.Kind = WEAPON_MISC
SWEP.KGWeight = 8
SWEP.AutoSpawnable = true
SWEP.StoredAmmo = 0

function SWEP:Think()
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if SERVER then
		self.Owner:DrawWorldModel(false)
		self.Owner:DrawWorldModel(false)

		local ent = ents.Create("ent_frag")
		ent:SetOwner(self.Owner) 
		ent:SetParent(self.Owner)
		ent:SetPos(self.Owner:GetPos())
		ent:SetColor(self.Owner:GetColor())
		ent:SetMaterial(self.Owner:GetMaterial())
		ent:Spawn()
	end

	
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
	self.Weapon:SendWeaponAnim( ACT_VM_THROW ) 		// View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	if SERVER then
		local ent = ents.Create("ent_frag_grenade")
		
		ent.GrenadeOwner = self.Owner
		ent:SetPos(self.Owner:GetShootPos())
		ent:SetAngles(Angle(1,0,0))
		ent:Spawn()
				
		local phys = ent:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * 1000)
		phys:AddAngleVelocity(Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50)))
	end
	self:EmitSound( "vo/npc/male01/watchout.wav", 100, math.random( 95, 105 ) );
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if self.Weapon:Clip1() < 1 && SERVER then
		local worldmodel = ents.FindInSphere(self.Owner:GetPos(),0.6)
		for k, v in pairs(worldmodel) do 
			if v:GetClass() == "ent_frag" and v:GetOwner() == self.Owner then
				v:Remove()
				end
		end
		self.Owner:StripWeapon("weapon_frag") 
		self.Owner:SelectWeapon("weapon_mor_crowbar")
	end

end
function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
	self.Weapon:SendWeaponAnim( ACT_VM_THROW ) 		// View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	if SERVER then
		local ent = ents.Create("ent_frag_grenade")
		
		ent.GrenadeOwner = self.Owner
		ent:SetPos(self.Owner:GetShootPos())
		ent:SetAngles(Angle(1,0,0))
		ent:Spawn()
				
		local phys = ent:GetPhysicsObject()
		phys:SetVelocity(self.Owner:GetAimVector() * 30)
		phys:AddAngleVelocity(Vector(0,0,0))
	end
	self:EmitSound( "vo/npc/male01/watchout.wav", 100, math.random( 95, 105 ) );
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if self.Weapon:Clip1() < 1 && SERVER then
		local worldmodel = ents.FindInSphere(self.Owner:GetPos(),0.6)
		for k, v in pairs(worldmodel) do 
			if v:GetClass() == "ent_frag" and v:GetOwner() == self.Owner then
				v:Remove()
				end
		end
		self.Owner:StripWeapon("weapon_frag") 
		self.Owner:SelectWeapon("weapon_mor_crowbar")
	end

end

function SWEP:Holster()
	if !self.Owner then return end
	if !IsValid(self.Owner) then return end
	local worldmodel = ents.FindInSphere(self.Owner:GetPos(),0.6)
	for k, v in pairs(worldmodel) do 
		if v:GetClass() == "ent_frag" and v:GetOwner() == self.Owner then
			v:Remove()
			end
	end

	return true

end


function SWEP:Ammo1()
   return ValidEntity(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) or false
end


function SWEP:PreDrop()
   if SERVER and ValidEntity(self.Owner) and self.Primary.Ammo != "none" then
      local ammo = self:Ammo1()

      -- Do not drop ammo if we have another gun that uses this type
      for _, w in pairs(self.Owner:GetWeapons()) do
         if ValidEntity(w) and w != self and w:GetPrimaryAmmoType() == self:GetPrimaryAmmoType() then
            ammo = 0
         end
      end
      
      self.StoredAmmo = ammo

      if ammo > 0 then
         self.Owner:RemoveAmmo(ammo, self.Primary.Ammo)
      end

      

   end
   local worldmodel = ents.FindInSphere(self.Owner:GetPos(),0.6)
   for k, v in pairs(worldmodel) do 
		if v:GetClass() == "ent_frag" and v:GetOwner() == self.Owner then
			v:Remove()
		end
	end
end

function SWEP:DampenDrop()
   local phys = self:GetPhysicsObject()
   if IsValid(phys) then
      phys:SetVelocityInstantaneous(Vector(0,0,-75) + phys:GetVelocity() * 0.001)
      phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
   end
end


function SWEP:Equip(newowner)
   if SERVER then
      if self:IsOnFire() then
         self:Extinguish()
      end
   end

   if SERVER and ValidEntity(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo != "none" then
      local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
      local given = math.min(self.StoredAmmo, (self.Primary.ClipSize*3) - ammo)

      newowner:GiveAmmo( given, self.Primary.Ammo)
      self.StoredAmmo = 0
   end
end

function SWEP:IsEquipment()
   return WEPS.IsEquipment(self)
end