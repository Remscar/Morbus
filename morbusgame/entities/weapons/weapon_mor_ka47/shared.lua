-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")

end

if (CLIENT) then
	SWEP.PrintName 		= "KA47"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end
SWEP.PrintName 		= "KA47"

SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05

SWEP.Instructions 		= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_rif_lamas.mdl"
SWEP.WorldModel 			= "models/weapons/w_irifle.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.Primary.Sound 		= Sound("m20.Single")

SWEP.Primary.Recoil 		= 0.44
SWEP.Primary.Damage 		= 19
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.038
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM 		= 500
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector (-4.7349, -7.416, 1.0654)
SWEP.IronSightsAng = Vector (0.1052, 0.0443, -1.1341)
SWEP.SightsPos = Vector (-4.7349, -7.416, 1.0654)
SWEP.SightsAng = Vector (0.1052, 0.0443, -1.1341)

SWEP.Primary.KickUp         = 0.42
SWEP.Primary.KickDown           = 0.42
SWEP.Primary.KickHorizontal         = 0.3

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_revolver_mor"
SWEP.AutoSpawnable = true

SWEP.KGWeight = 24

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = true}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_rif_lamas.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 5, 2), angle = Angle(-10, 0, 220), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}