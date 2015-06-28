
AddCSLuaFile()

SWEP.PrintName 		= "Scar M8"
if (CLIENT) then
	SWEP.PrintName 		= "Scar M8"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "k"
    SWEP.ViewModelFlip = true

end


SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models

SWEP.EjectDelay			= 0.53


SWEP.HoldType 		= "shotgun"

SWEP.Instructions 		= ""

SWEP.Base 				= "weapon_mor_base_pump"

SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= false

SWEP.ViewModel              = "models/weapons/v_spas12_shot.mdl"    -- Weapon view model
SWEP.WorldModel             = "models/weapons/w_shotgun.mdl"    -- Weapon world model
SWEP.ShowWorldModel         = false

SWEP.Primary.Sound 		= Sound("weapons/spas/spas-1.wav")   
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 7
SWEP.Primary.NumShots		= 12
SWEP.Primary.Cone			= 0.115
SWEP.Primary.ClipSize		= 8
SWEP.Primary.RPM            = 45
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "Buckshot"
SWEP.DestroyDoor = 1

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"


SWEP.IronSightsPos = Vector(2.657, .394, 1.659)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.8
SWEP.Primary.KickDown           = 0.4
SWEP.Primary.KickHorizontal         = 0.5

SWEP.Gun = "weapon_mor_scarm8"

SWEP.Kind = WEAPON_RIFLE
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_buckshot_mor"
SWEP.KGWeight = 26
SWEP.AutoSpawnable = true
SWEP.StoredAmmo = 0

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.3
SWEP.ShellTime		= 0.5
SWEP.InsertingShell	=		false

SWEP.WElements = {
    ["shotty"] = { type = "Model", model = "models/weapons/w_spas12_shot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.631, 0.804, -1.048), angle = Angle(-173.793, -180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}