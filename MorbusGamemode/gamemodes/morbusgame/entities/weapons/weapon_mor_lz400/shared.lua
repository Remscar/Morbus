
if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "LZ400"
if (CLIENT) then
	SWEP.PrintName 		= "LZ400"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true

end
SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05
SWEP.MuzzleAttachment		= "1"


SWEP.Instructions 		= "Weapon"

SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel              = "models/weapons/v_kac_pdw1.mdl"   -- Weapon view model
SWEP.WorldModel             = "models/weapons/w_smg1.mdl"   -- Weapon world model
SWEP.ShowWorldModel         = false

SWEP.Primary.Sound 		= Sound("KAC_PDW.Single")


SWEP.Primary.Recoil 		= 0.5
SWEP.Primary.Damage 		= 14
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.035
SWEP.Primary.ClipSize 		= 20
SWEP.Primary.RPM 		= 700
SWEP.Primary.DefaultClip 	= 20
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"


SWEP.IronSightsPos = Vector(3.342, -2, 0.85)
SWEP.IronSightsAng = Vector(2.46, -0.025, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng 


SWEP.Primary.KickUp         = 0.25
SWEP.Primary.KickDown           = 0.25
SWEP.Primary.KickHorizontal         = 0.44

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_revolver_mor"
SWEP.AutoSpawnable = true

--SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "2", enabled = true}

SWEP.KGWeight = 22

SWEP.WElements = {
    ["eotech"] = { type = "Model", model = "models/wystan/attachments/eotech557sight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "pdw", pos = Vector(-5.213, -0.84, -4.763), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
    ["pdw"] = { type = "Model", model = "models/weapons/w_kac_pdw1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.441, 0.568, -0.313), angle = Angle(-176.933, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.VElements = {
    ["eotech"] = { type = "Model", model = "models/wystan/attachments/eotech557sight.mdl", bone = "DrawCall_0", rel = "", pos = Vector(-0.281, 10.85, -6.398), angle = Angle(0, 90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
    ["DrawCall_0009"] = { scale = Vector(1, 1, 1), pos = Vector(-0.154, 0, 0), angle = Angle(0, 0, 0) }
}