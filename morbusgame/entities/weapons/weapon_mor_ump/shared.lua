-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "UMP"
if (CLIENT) then
	SWEP.PrintName 		= "UMP"
	SWEP.Slot 			= 2
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true

end
	SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05

SWEP.Instructions 		= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel 			= "models/weapons/w_smg_ump45.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_UMP45.Single")
util.PrecacheSound(SWEP.Primary.Sound)
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 15
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.04
SWEP.Primary.ClipSize 		= 25
SWEP.Primary.RPM 			= 500
SWEP.Primary.DefaultClip 	= 25
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector(7.31,-2,3.285)
SWEP.IronSightsAng 		= Vector(-1.4,.245,2)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng


SWEP.Primary.KickUp         = 0.4
SWEP.Primary.KickDown           = 0.1
SWEP.Primary.KickHorizontal         = 0.3


SWEP.Kind = WEAPON_LIGHT
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_mor"

SWEP.KGWeight = 13