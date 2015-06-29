-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "Mars3"
if (CLIENT) then
	SWEP.PrintName 		= "Mars3"
	SWEP.Slot 			= 3
	SWEP.ViewModelFOV       = 70
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

SWEP.ViewModel 			= "models/weapons/v_rif_tavor.mdl"
SWEP.WorldModel 			= "models/weapons/w_rif_tavor.mdl"

SWEP.Primary.Sound 		= "weapons/tavor/tavor-1.wav"
util.PrecacheSound(SWEP.Primary.Sound)
SWEP.Primary.Recoil 		= 0.3
SWEP.Primary.Damage 		= 17
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.015
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.RPM  			= 420
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector (-3.4468, -5.7548, 0.8798)
SWEP.IronSightsAng = Vector (0.2205, 0.1018, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Kind = WEAPON_RIFLE
SWEP.AmmoEnt = "item_ammo_revolver_mor"
SWEP.AutoSpawnable = true

SWEP.KGWeight = 21

SWEP.Primary.KickUp         = 0.4
SWEP.Primary.KickDown           = 0.3
SWEP.Primary.KickHorizontal         = 0.1

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = true}