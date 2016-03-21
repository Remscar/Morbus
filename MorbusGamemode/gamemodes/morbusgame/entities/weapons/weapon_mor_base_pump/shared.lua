-- CAN THE SHOTGUN DESTROY DOORS WITH THE BUCKSHOT ROUNDS? 1 = YES, 0 = NO
SWEP.DestroyDoor = 1

AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName 		= "Scar M8"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "k"

end


SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models

SWEP.EjectDelay			= 0.53
/*-------------------------------------------------------*/

local DoorSound = Sound("physics/wood/wood_box_impact_hard3.wav")
local ShotgunReloading
ShotgunReloading = false
SWEP.HoldType 		= "shotgun"

SWEP.Instructions 		= ""

SWEP.Base 				= "weapon_mor_base"

SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= false

SWEP.ViewModel 			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel 			= "models/weapons/w_shot_m3super90.mdl"

SWEP.Primary.Sound 			= Sound("")				// Sound of the gun
SWEP.Primary.RPM				= 0					// This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 0					// Size of a clip
SWEP.Primary.DefaultClip			= 0					// Default number of bullets in a clip
SWEP.Primary.KickUp			= 0					// Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0					// Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 0					// Maximum side recoil (koolaid)
SWEP.Primary.Automatic			= true					// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"					// What kind of ammo
SWEP.Primary.Reloading			= false	

SWEP.Secondary.ClipSize			= 0					// Size of a clip
SWEP.Secondary.DefaultClip			= 0					// Default number of bullets in a clip
SWEP.Secondary.Automatic			= false					// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.IronFOV			= 0					// How much you 'zoom' in. Less is more! 

SWEP.data 				= {}					-- The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.5
SWEP.ShellTime		= 0.35
SWEP.InsertingShell	=		false

SWEP.NextReload	=	0

SWEP.IronSightsPos 		= Vector (5.7431, -1.6786, 3.3682)
SWEP.IronSightsAng 		= Vector (0.0634, -0.0235, 0)

SWEP.Kind = WEAPON_HEAVY
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_buckshot_mor"
SWEP.KGWeight = 10
SWEP.AutoSpawnable = false
SWEP.StoredAmmo = 0






/*---------------------------------------------------------
Deploy
---------------------------------------------------------*/
function SWEP:Deploy()

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	if self.Weapon:GetNextPrimaryFire() < CurTime() + .25 then
		self.Weapon:SetNextPrimaryFire(CurTime() + .25)
	end
	
	self.Weapon:SetNextSecondaryFire(CurTime() + .25)
	self.ActionDelay = (CurTime() + .25)

	self.ShotgunReloading = false
	self.Weapon:SetNWBool( "reloading", false)

	if (SERVER) then
		self:SetIronsights(false)
	end
	
	self.NextReload = CurTime() + 1

	return true
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	if ( self.Reloadaftershoot > CurTime() ) then return end

	if (self.Weapon:GetNWBool("reloading", false)) or self.ShotgunReloading then return end

	if (self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0) then
			self.ShotgunReloading = true
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		timer.Simple(0.3, function()
			self.ShotgunReloading = false
			self.Weapon:SetNWBool("reloading", true)
			self.Weapon:SetNWInt("reloadtimer", CurTime() + 1)
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		end)
	end

	self.Owner:SetFOV( 0, 0.15 )
	-- Zoom = 0

	self:SetIronsights(false)
	-- Set the ironsight to false
end

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function SWEP:Think()

	if self.Weapon:Clip1() > self.Primary.ClipSize then
		self.Weapon:SetClip1(self.Primary.ClipSize)
	end

	if self.Weapon:GetNWBool( "reloading") == true then
	
		if self.Weapon:GetNWInt( "reloadtimer") < CurTime() then
			--if self.unavailable then return end

			self:ShotgunReload()
		end
	end

	self:IronSight()

	if self.Owner:KeyPressed(IN_ATTACK) and (self.Weapon:GetNWBool("reloading", true)) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:SetNWBool( "reloading", false)
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
	end
end

function SWEP:ShotgunReload()

	if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0 ) then
		self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		self.Weapon:SetNWBool( "reloading", false)
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
	else
	
	self.Weapon:SetNWInt( "reloadtimer", CurTime() + 1 )
	self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
	self.Weapon:SetClip1(  self.Weapon:Clip1() + 1 )

	print( self.Weapon:Clip1() )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)

		if ( self.Weapon:Clip1() >= self.Primary.ClipSize || self.Owner:GetAmmoCount( self.Primary.Ammo ) <= 0) then
			self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 1.5)
		else
			self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		end

		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)

	end

end
