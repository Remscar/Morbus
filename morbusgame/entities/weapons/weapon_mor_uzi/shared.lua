

if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "Uzi"
if (CLIENT) then
	SWEP.PrintName 		= "Uzi"
	SWEP.Slot 			= 2
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end
SWEP.HoldType 		= "pistol"
SWEP.EjectDelay			= 0.05
SWEP.MuzzleAttachment		= "1"
SWEP.Instructions 		= "Weapon"

SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel				= "models/weapons/v_imi_uzi01.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false

SWEP.Primary.Sound 		= Sound("Weapon_uzi.single")
SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 12
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.04
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM 		= 760
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "Pistol"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(-2.951, -2.629, 1.633)
SWEP.IronSightsAng = Vector(0.109, -0.772, 1.725)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.5
SWEP.Primary.KickDown           = 0.3
SWEP.Primary.KickHorizontal         = 0.5

SWEP.Kind = WEAPON_LIGHT
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_pistol_mor"

SWEP.KGWeight = 12
SWEP.WElements = {
	["uzi"] = { type = "Model", model = "models/weapons/w_imi_uzi01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4.284, 0.757, 2.49), angle = Angle(-180, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

