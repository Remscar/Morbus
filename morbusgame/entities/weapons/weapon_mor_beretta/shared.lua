

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType 			= "pistol"
SWEP.PrintName 		= "Beretta11"
if (CLIENT) then
	SWEP.PrintName 		= "Beretta11"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
    SWEP.ViewModelFlip      = false
end

------------------------------------------------*/

SWEP.Base 				= "weapon_mor_base"
SWEP.MuzzleAttachment		= "1"
SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= false


SWEP.ViewModel              = "models/weapons/v_trh_92fs.mdl"
SWEP.WorldModel             = "models/weapons/w_trh_92fs.mdl"

SWEP.Primary.Sound 		= Sound("92FS.single")
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 17
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 15
SWEP.Primary.RPM            = 350
SWEP.Primary.DefaultClip	= 15
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "pistol"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.Primary.KickUp         = 0.2
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.2

SWEP.IronSightsPos = Vector(-3.961, 0, 0.56)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(-3.961, 0, 0.56)
SWEP.SightsAng = Vector(0, 0, 0)

SWEP.Kind = WEAPON_PISTOL
SWEP.AmmoEnt = "item_ammo_pistol_mor"
SWEP.KGWeight = 12
SWEP.AutoSpawnable = true

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}