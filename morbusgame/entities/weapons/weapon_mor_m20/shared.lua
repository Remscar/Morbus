-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")

end

if (CLIENT) then
	SWEP.PrintName 		= "M20"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end
	SWEP.PrintName 		= "M20"
SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05

SWEP.Instructions 		= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_rif_xamas.mdl"
SWEP.WorldModel 			= "models/weapons/w_rif_xamas.mdl"

SWEP.Primary.Sound 		= Sound("m20.Single")
SWEP.Primary.Recoil 		= 0.375
SWEP.Primary.Damage 		= 18
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.024
SWEP.Primary.ClipSize 		= 32
SWEP.Primary.RPM 		= 450
SWEP.Primary.DefaultClip 	= 32
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector (-3.0756, -5.0378, 1.0971)
SWEP.IronSightsAng = Vector (0.0882, 0.1032, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.25
SWEP.Primary.KickDown           = 0.25
SWEP.Primary.KickHorizontal         = 0.2

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_revolver_mor"
SWEP.AutoSpawnable = true

SWEP.KGWeight = 24

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = true}