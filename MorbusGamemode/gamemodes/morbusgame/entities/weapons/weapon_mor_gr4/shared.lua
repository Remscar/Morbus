



if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "GR-4"
if (CLIENT) then
	SWEP.PrintName 		= "GR-4"
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

SWEP.ViewModel              = "models/weapons/v_hk_g3_rif.mdl"  -- Weapon view model
SWEP.WorldModel             = "models/weapons/w_smg1.mdl"   -- Weapon world model
SWEP.ShowWorldModel         = false 

SWEP.Primary.Sound 		= Sound("hk_g3_weapon.Single")

SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 15
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.015
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM 		= 675
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"


SWEP.IronSightsPos = Vector(-2.419, -3.069, 1.398)
SWEP.IronSightsAng = Vector(-0.109, -0.281, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.4
SWEP.Primary.KickDown           = 0.4
SWEP.Primary.KickHorizontal         = 0.5

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_revolver_mor"
SWEP.AutoSpawnable = true

--SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "2", enabled = true}

SWEP.KGWeight = 21

SWEP.WElements = {
    ["g3"] = { type = "Model", model = "models/weapons/w_hk_g3_rif.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0, 0), angle = Angle(-176.93, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}