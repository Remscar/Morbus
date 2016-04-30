/*---------------------------------------------------------
The base class for glowsticks!
---------------------------------------------------------*/
if (SERVER) then
	AddCSLuaFile("shared.lua")
end

if ( CLIENT ) then
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "Glow Sticks"
	SWEP.Slot				= WEAPON_GLOWSTICK - 1
	SWEP.SlotPos			= 0
end

SWEP.EntName 	= "ent_glowstick"
SWEP.FlyEntName = "ent_glowstick_fly"

SWEP.ViewModel			= "models/glowstick/v_glowstick.mdl"
SWEP.WorldModel			= "models/glowstick/stick.mdl"

SWEP.PrimaryAttackVector 		= Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))
SWEP.SecondaryAttackVector 		= Vector(0,0,0)
SWEP.DropOnSpot					= 30

--these two values have overrides in the gravity stick class
SWEP.PropelForwardSpeed		= 600
SWEP.UseGravity				= true
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.HoldType			= "normal"

SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay		= 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.AllowDrop = true
SWEP.Kind = WEAPON_GLOWSTICK
SWEP.KGWeight = 8
SWEP.AutoSpawnable = true
SWEP.StoredAmmo = 0

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	self:BeforeAttack()	
	self:DuringAttack(self.FlyEntName, self.PrimaryAttackVector, self.PropelForwardSpeed )
	self:AfterAttack(self.EntName, self.WepName, self.Owner)
end

function SWEP:SecondaryAttack()
	self:BeforeAttack()
	self:DuringAttack(self.FlyEntName, self.SecondaryAttackVector, self.DropOnSpot )
	self:AfterAttack(self.EntName, self.WepName, self.Owner)
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	
	if SERVER then
		self.Owner:DrawWorldModel(false)

		local ent = ents.Create(self.EntName)
		ent:SetOwner(self.Owner) 
		ent:SetParent(self.Owner)
		ent:SetPos(self.Owner:GetPos())
		ent:SetColor(self.Owner:GetColor())
		ent:SetMaterial(self.Owner:GetMaterial())
		ent:Spawn()
	end
end

function RemoveGlowStick(name, owner)
	local worldmodel = ents.FindInSphere(owner:GetPos(),0.6)
	for k, v in pairs(worldmodel) do 
		if v:GetClass() == name and v:GetOwner() == owner then
			v:Remove()
		end
	end
end

function SWEP:Holster()
	if !self.Owner then return end
	if !IsValid(self.Owner) then return end	
	
	RemoveGlowStick(self.EntName, self.Owner)	
	return true
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
	
	RemoveGlowStick(self.EntName, self.Owner)
end

function SWEP:BeforeAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
	self.Weapon:SendWeaponAnim( ACT_VM_THROW ) 		// View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:DuringAttack(name, vec, speed)
	if SERVER then
		local ent = ents.Create(name)
				
		ent:SetPos(self.Owner:GetShootPos())
		ent:SetAngles(Angle(1,0,0))
		ent:Spawn()
				
		local phys = ent:GetPhysicsObject()		
		phys:SetVelocity(self.Owner:GetAimVector() * speed)
		phys:AddAngleVelocity(vec)
		
        phys:EnableGravity( self.UseGravity )
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:AfterAttack(entName, wepName, owner)
	if self.Weapon:Clip1() < 1 && SERVER then
		RemoveGlowStick(entName, owner)
		self.Owner:StripWeapon(wepName) 
	end
end

function SWEP:Ammo1()
   return ValidEntity(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) or false
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

		if ValidEntity(newowner) and self.StoredAmmo > 0 and self.Primary.Ammo != "none" then
			local ammo = newowner:GetAmmoCount(self.Primary.Ammo)
			local given = math.min(self.StoredAmmo, (self.Primary.ClipSize*3) - ammo)

			newowner:GiveAmmo( given, self.Primary.Ammo)
			self.StoredAmmo = 0
	   end
   end
end

function SWEP:IsEquipment()
   return WEPS.IsEquipment(self)
end
