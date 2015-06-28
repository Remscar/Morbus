


if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "Vektor"
if (CLIENT) then
	SWEP.PrintName 		= "Vektor"
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

SWEP.ViewModel              = "models/weapons/v_kriss_svs.mdl"  -- Weapon view model
SWEP.WorldModel             = "models/weapons/w_smg1.mdl"   -- Weapon world model
SWEP.ShowWorldModel         = false

SWEP.Primary.Sound 		= Sound("kriss_vector.Single")
SWEP.Primary.Recoil			= 0.45
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.023
SWEP.Primary.ClipSize		= 40
SWEP.Primary.RPM 			= 600
SWEP.Primary.DefaultClip	= 40
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "SMG1"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(3.943, -0.129, 1.677)
SWEP.IronSightsAng = Vector(-1.922, 0.481, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.3
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.3


SWEP.Kind = WEAPON_LIGHT
SWEP.AutoSpawnable = true
SWEP.AmmoEnt = "item_ammo_smg1_mor"

SWEP.KGWeight = 15


SWEP.WElements = {
    ["vector"] = { type = "Model", model = "models/weapons/w_kriss_svs.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0, 0.686, 1.401), angle = Angle(-160.568, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}