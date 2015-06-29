


if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "SC-7"
if (CLIENT) then
	SWEP.PrintName 		= "SC-7"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end
SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05
SWEP.MuzzleAttachment		= "1"


SWEP.Instructions 		= "Weapon"

SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel				= "models/weapons/v_fnscarh.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false

SWEP.Primary.Sound 		= Sound("Wep_fnscarh.single")

SWEP.Primary.Recoil 		= 0.4
SWEP.Primary.Damage 		= 17
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.024
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM 		= 500
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(-2.652, -2.187, 0.35)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.3
SWEP.Primary.KickDown           = 0.3
SWEP.Primary.KickHorizontal         = 0.3

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_revolver_mor"
SWEP.AutoSpawnable = true

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = true}

SWEP.KGWeight = 25

SWEP.VElements = {
	["rect"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "gun_root", rel = "", pos = Vector(0, -0.461, 3.479), angle = Angle(0, 0, 90), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/wystan/attachments/eotech/rect", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["scar"] = { type = "Model", model = "models/weapons/w_fnscarh.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.625, 0.87, -0.26), angle = Angle(-174.971, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
