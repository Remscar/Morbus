/*------------------------------------
 Morbus 2
 Zachary Nawar - zachary.nawar.org
 ------------------------------------*/

if SERVER then
 AddCSLuaFile("shared.lua")
end

SWEP.PrintName = "Default Melee Weapon Name"
SWEP.Base = "weapon_mor_base"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.SwingSound = "Weapon_Crowbar.Single"
SWEP.SwingVolume = 70
SWEP.HitSound = "Weapon_Crowbar.Melee_Hit"
SWEP.HitVolume = 140
SWEP.HoldType = "melee"

SWEP.AttackDelay = 0.7
SWEP.AttackRange = 75
SWEP.AttackDamage = 20

SWEP.CanRearAttack = false
SWEP.RearRange = 30
SWEP.RearBonus = 2.5



function SWEP:Initialize()
  self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    return true
end

function SWEP:PrimaryAttack()
  self.Weapon:SetNextPrimaryFire(CurTime() + self.AttackDelay)

  self.Owner:LagCompensation(true)
  local largeTrace = {}
  largeTrace.start = self.Owner:GetShootPos()
  largeTrace.endpos = largeTrace.start + (self.Owner:GetAimVector() * self.AttackRange)
  largeTrace.filter = self.Owner
  largeTrace.mins = Vector(1,1,0.5) * -13
  largeTrace.maxs = Vector(1,1,0.5) * 13
  largeTrace.mask = CONTENTS_MONSTER + CONTENTS_HITBOX
  largeTrace = util.TraceHull(largeTrace)

  local smallTrace = {}
  smallTrace.start = self.Owner:GetShootPos()
  smallTrace.endpos = smallTrace.start + (self.Owner:GetAimVector() * self.AttackRange)
  smallTrace.filter = self.Owner
  smallTrace.mins = Vector(1,1,0.5) * -11
  smallTrace.maxs = Vector(1,1,0.5) * 11
  smallTrace = util.TraceHull(smallTrace)

  if smallTrace.Fraction * 1.3 < largeTrace.Fraction then

      if SERVER then self.Owner:EmitSound(self.SwingSound, self.SwingVolume) end

      largeTrace = {}
      largeTrace.start = self.Owner:GetShootPos()
      largeTrace.endpos = largeTrace.start + (self.Owner:GetAimVector() * self.AttackRange)
      largeTrace.filter = self.Owner
      largeTrace = util.TraceLine(largeTrace)

      if largeTrace.Fraction < 1 && largeTrace.HitNonWorld && largeTrace.Entity && !largeTrace.Entity:IsPlayer() then
          if SERVER then
            local dmg = self.AttackDamage * 2
            largeTrace.Entity:TakeDamage( dmg, self.Owner, self.Weapon )
          end
          self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
      else
          self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
      end

      self.Owner:SetAnimation( PLAYER_ATTACK1 )
      self.HolsterTime = CurTime() + 1.5
      return 
  end

  if SERVER then self.Owner:EmitSound(self.SwingSound, self.SwingVolume) end

  if largeTrace.Fraction < 1 && largeTrace.HitNonWorld && largeTrace.Entity:IsPlayer()  then
      if SERVER then
          local a1,a2 = largeTrace.Entity:GetAngles().y, self.Owner:GetAngles().y
          local diff = a1-a2

          local dmg = self.AttackDamage


          if self.CanRearAttack and diff <= self.RearRange and diff >= -self.RearRange then
            dmg = dmg * self.RearBonus
          end

          local ent = largeTrace.Entity

          ent:TakeDamage( dmg, self.Owner, self.Weapon )
          
          self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
          self.Owner:EmitSound(self.HitSound, self.HitVolume)
      end
      self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
  else
      self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
  end
  self.Owner:SetAnimation( PLAYER_ATTACK1 )
  self.Owner:LagCompensation(false)

  self.HolsterTime = CurTime() + 1

end

function SWEP:Reload()
    return false
end

function SWEP:Think()
    return false
end

function SWEP:SecondaryAttack()
    return false
end