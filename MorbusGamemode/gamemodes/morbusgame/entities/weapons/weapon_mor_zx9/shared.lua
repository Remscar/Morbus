-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")

end

if (CLIENT) then
	SWEP.PrintName 		= "ZX9"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end
SWEP.PrintName 		= "ZX9"

SWEP.HoldType 		= "ar2"
SWEP.EjectDelay			= 0.05

SWEP.Instructions 		= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel = "models/weapons/v_bach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.Primary.Sound 		= Sound("zx9.Single")  

SWEP.Primary.Recoil 		= 0.7
SWEP.Primary.Damage 		= 14
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.04
SWEP.Primary.ClipSize 		= 200
SWEP.Primary.RPM 		= 800
SWEP.Primary.DefaultClip 	= 200
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "AlyxGun"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos = Vector(-4.572, -4.115, 2.24)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Primary.KickUp         = 0.2
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.2

SWEP.Kind = WEAPON_RIFLE
SWEP.HoldKind = WEAPON_LIGHT
SWEP.AmmoEnt = "item_ammo_none_mor"
SWEP.AutoSpawnable = true
SWEP.NeverRandom = true

SWEP.KGWeight = 40

SWEP.Tracer = 1

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "2", enabled = true}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_bach_m249para.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.622, 0.256, 0.063), angle = Angle(-9.181, -1.231, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

end

/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

	self:SetWeaponHoldType(self.HoldType)

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	-- Set the deploy animation when deploying

	self.Reloadaftershoot = CurTime() + 1
	-- Can't shoot while deploying

	self.Weapon:SetNWBool( "IsLaserOn", true )

	self:SetIronsights(false)
	-- Set the ironsight mod to false

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	-- Set the next primary fire to 1 second after deploying

	self.Owner:EmitSound( "weapons/Bianachi/mach_parts2.wav" ) ;

end