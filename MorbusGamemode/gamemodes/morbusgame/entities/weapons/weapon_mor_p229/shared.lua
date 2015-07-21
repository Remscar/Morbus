-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType 			= "pistol"
	SWEP.PrintName 		= "P229"
if (CLIENT) then
	SWEP.PrintName 		= "P229"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true

end

------------------------------------------------*/

SWEP.Base 				= "weapon_mor_base"
SWEP.MuzzleAttachment		= "1"
SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= false

SWEP.ViewModel 			= "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_P228.Single")
SWEP.Primary.Recoil 		= 0.325
SWEP.Primary.Damage 		= 16
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.02
SWEP.Primary.ClipSize 		= 15
SWEP.Primary.RPM 			= 440
SWEP.Primary.DefaultClip 	= 15
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "Pistol"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (4.7638, -1.0164, 2.9577)
SWEP.IronSightsAng 		= Vector (-0.6277, 0.0315, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Kind = WEAPON_PISTOL
SWEP.AmmoEnt = "item_ammo_pistol_mor"
SWEP.KGWeight = 4
SWEP.AutoSpawnable = true

SWEP.Primary.KickUp         = 0.2
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.4

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}