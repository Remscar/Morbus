-- I think the class is the most ironic part
if (SERVER) then
   AddCSLuaFile("shared.lua")
end

if (CLIENT) then
   SWEP.Slot         = 3
   SWEP.ViewModelFOV       = 70
   SWEP.PrintName = "Medkit"
   SWEP.Author = "Remscar"
   SWEP.Slot = 4
   SWEP.SlotPos = 1
   SWEP.Description = "Heals shit"

end


SWEP.Spawnable = false      -- Change to false to make Admin only.
SWEP.AdminSpawnable = false

SWEP.ViewModel = "models/weapons/v_healthkit.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.HoldType        = "normal"


SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize  = 150
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic  = true
SWEP.Primary.Delay = 0.08
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.16
SWEP.Secondary.Ammo = "none"

SWEP.AllowDrop = true
SWEP.Kind = WEAPON_MISC
SWEP.KGWeight = 10
SWEP.AutoSpawnable = true
SWEP.StoredAmmo = 0

function SWEP:Initialize()
   self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
   

   trace = {}
   trace.start = self.Owner:GetShootPos()
   trace.endpos = trace.start + (self.Owner:GetAimVector() * 85)
   trace.mins = Vector(1,1,1) * -5
   trace.maxs = Vector(1,1,1) * 5
   trace.filter = { self.Owner, self.Weapon }

    tr = util.TraceHull(trace)

   if (tr.HitNonWorld) and SERVER then
      local enthit = tr.Entity
      if enthit:IsPlayer() and !enthit:GetNWBool("alienform",false) and enthit:Health() < 100 then
         enthit:SetHealth(enthit:Health() + 1)
         self.Owner:EmitSound("hl1/fvox/boop.wav", 120, enthit:Health()+10)
         self:TakePrimaryAmmo(1)
      end
   end
   if SERVER then
     if self.Weapon:Clip1() < 1 then self.Owner:StripWeapon("weapon_mor_medkit") end
   end
end
function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)

   if self.Owner:Health() < 100 and SERVER then
      self:TakePrimaryAmmo(1)
      self.Owner:SetHealth(self.Owner:Health() + 1)
      self.Owner:EmitSound("hl1/fvox/boop.wav", 120, self.Owner:Health()+10)
   end
   if SERVER then
     if self.Weapon:Clip1() < 1 then self.Owner:StripWeapon("weapon_mor_medkit") end
   end
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