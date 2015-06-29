SWEP.PrintName = "Crowbar"

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
 SWEP.PrintName      = "Crowbar"
if (CLIENT) then
    SWEP.PrintName      = "Crowbar"
    SWEP.ViewModelFOV       = 70
    SWEP.ViewModelFlip      = false
    SWEP.DrawCrosshair  = true
    SWEP.Slot           = 1
    SWEP.SlotPos        = 1
    SWEP.IconLetter         = "y"

end
SWEP.Base               = "weapon_mor_melee"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawWeaponInfoBox=false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.SwingSound = "Weapon_Crowbar.Single"
SWEP.HitSound = "Weapon_Crowbar.Melee_Hit"
util.PrecacheSound(SWEP.SwingSound)
util.PrecacheSound(SWEP.HitSound)

SWEP.HoldType="melee"

SWEP.AllowDrop = false
SWEP.Kind = WEAPON_MELEE

SWEP.Delay=0.6
SWEP.Range=75
SWEP.Damage=20
SWEP.AutoSpawnable = false

function SWEP:Deploy()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay*2)
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    return true
end