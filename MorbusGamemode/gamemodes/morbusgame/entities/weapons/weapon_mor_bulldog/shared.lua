-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")

end

if (CLIENT) then
	SWEP.PrintName 		= "Bulldog-HMG"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end
SWEP.PrintName 		= "Bulldog-HMG"

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

--SWEP.Primary.Sound 		= Sound("zx9.Single")  

SWEP.Primary.Recoil 		= 1.5
SWEP.Primary.Damage 		= 20
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.05
SWEP.Primary.ClipSize 		= 100
SWEP.Primary.RPM 		= 500
SWEP.Primary.DefaultClip 	= 100
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

SWEP.Primary.KickUp         = 0.5
SWEP.Primary.KickDown           = 0.5
SWEP.Primary.KickHorizontal         = 0.5

SWEP.Kind = WEAPON_RIFLE
SWEP.HoldKind = WEAPON_LIGHT
SWEP.AmmoEnt = "item_ammo_none_mor"
SWEP.AutoSpawnable  = true
SWEP.NeverRandom    = true

SWEP.KGWeight = 55

SWEP.Tracer = 1

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "2", enabled = true}

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_bach_m249para.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.622, 0.256, 0.063), angle = Angle(-9.181, -1.231, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

sound.Add({
    name =          "bulldog.shoot",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/demon/heavyrifle.wav"
})

SWEP.shootsound = Sound("bulldog.shoot")

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

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)

    num_bullets         = num_bullets or 1
    aimcone             = aimcone*1.5 or 0

    
    local bullet = {}
        bullet.Num      = num_bullets
        bullet.Src      = self.Owner:GetShootPos()          -- Source
        bullet.Dir      = self.Owner:GetAimVector()         -- Dir of bullet
        bullet.Spread   = Vector(aimcone, aimcone, 0)           -- Aim Cone
        bullet.Tracer   = 1                         -- Show a tracer on every x bullets
        bullet.TracerName = "TracerBulldog"
        bullet.Force    = damage * 0.5                  -- Amount of force to give to phys objects
        bullet.Damage   = damage
        bullet.Callback = function(attacker, tracedata, dmginfo) 
        
                        return self:RicochetCallback(0, attacker, tracedata, dmginfo) 
                      end

        self.Weapon:EmitSound( self.shootsound, 25, 25 )

    self.Owner:FireBullets(bullet)
    if CLIENT and !self.Owner:IsNPC() then
        --local anglo = Angle(math.Rand(-self.Primary.KickDown,-self.Primary.KickUp), 0, 0)
        local anglo = Angle(math.Rand(-self.Primary.KickDown,self.Primary.KickUp)*recoil, math.Rand(-self.Primary.KickHorizontal,self.Primary.KickHorizontal)*recoil, 0)
        self.Owner:ViewPunch(anglo)

        local eyeang = self.Owner:EyeAngles()
        eyeang.pitch = eyeang.pitch - anglo.pitch
        eyeang.yaw = eyeang.yaw - anglo.yaw
        self.Owner:SetEyeAngles(eyeang)
        
        -- local eyes = self.Owner:EyeAngles()
        -- eyes.pitch = eyes.pitch + anglo.pitch
        -- eyes.yaw = eyes.yaw + anglo.yaw
        -- self.Owner:SetEyeAngles(eyes)
    end

    if (CLIENT) then
        
    end

end

function SWEP:DoImpactEffect( tr, dmgtype )

    if( tr.HitSky ) then return true; end
    
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData();
        effect:SetOrigin( tr.HitPos );
        effect:SetNormal( tr.HitNormal );

        util.Effect( "BulldogImpact", effect );

    end

    return true;

end