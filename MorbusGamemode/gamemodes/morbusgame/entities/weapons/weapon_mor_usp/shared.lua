-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType 			= "pistol"
SWEP.PrintName 		= "USP-2"
if (CLIENT) then
	SWEP.PrintName 		= "USP-2"
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


SWEP.ViewModel 			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_USP.Single")
SWEP.Primary.Damage 		= 19
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.033
SWEP.Primary.ClipSize 		= 12
SWEP.Primary.RPM		= 475
SWEP.Primary.DefaultClip 	= 12
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "Pistol"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (4.45, -1, 2.3)
SWEP.IronSightsAng 		= Vector (1, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.6
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.4
SWEP.AutoSpawnable = true


SWEP.Kind = WEAPON_PISTOL
SWEP.AmmoEnt = "item_ammo_pistol_mor"
SWEP.KGWeight = 3
SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}