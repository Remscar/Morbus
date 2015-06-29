-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "R22"
if (CLIENT) then
	SWEP.PrintName 		= "R22"
	SWEP.Slot 			= 2
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end
	SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05

SWEP.Instructions 		= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_rif_zamas.mdl"
SWEP.WorldModel 			= "models/weapons/w_rif_zamas.mdl"

SWEP.Primary.Sound 		= Sound("r22.Single")

SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 13
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.04
SWEP.Primary.ClipSize 		= 40
SWEP.Primary.RPM 			= 660
SWEP.Primary.DefaultClip 	= 40
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "SMG1"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector (-3.2, -2, 1.7)
SWEP.IronSightsAng = Vector (-2, 0, 0)-- Vector (1.5872, -0.5628, -0.0036)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.4
SWEP.Primary.KickDown           = 0.4
SWEP.Primary.KickHorizontal         = 0.3

SWEP.Kind = WEAPON_LIGHT
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_mor"

SWEP.KGWeight = 16

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = true}

SWEP.VElements = {
    ["eotech"] = { type = "Model", model = "models/wystan/attachments/eotech557sight.mdl", bone = "a_br2", rel = "", pos = Vector(-0.36, 6, -9.4), angle = Angle(8, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
    ["DrawCall_0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}