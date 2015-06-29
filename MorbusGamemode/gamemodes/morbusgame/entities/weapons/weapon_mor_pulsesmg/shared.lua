-- Read the weapon_real_base if you really want to know what each action does
-- Original Author: Remscar
-- Creator of "weapon_mor_pulsesmg": Demonkush

if (SERVER) then
	AddCSLuaFile("shared.lua")

end
SWEP.PrintName 		= "U8 Gauss SMG"
if (CLIENT) then
	SWEP.PrintName 			= "U8 Gauss SMG"
	SWEP.Slot 				= 2
	SWEP.SlotPos 			= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip		= true

end
SWEP.HoldType 			= "ar2"
SWEP.EjectDelay			= 0.05

SWEP.Instructions 			= "Weapon"
SWEP.MuzzleAttachment		= "1"
SWEP.Base 					= "weapon_mor_base"

SWEP.Spawnable 				= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 				= "models/weapons/v_plasmagun.mdl"
SWEP.WorldModel 			= "models/weapons/w_plasmagun.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_AR2.NPC_Single")
util.PrecacheSound(SWEP.Primary.Sound)
SWEP.Primary.Recoil 		= 0.4
SWEP.Primary.Damage 		= 12
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 			= 0.005
SWEP.Primary.ClipSize 		= 40
SWEP.Primary.RPM 			= 450
SWEP.Primary.DefaultClip 	= 40
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 			= "Battery"

SWEP.Secondary.ClipSize 	= 1
SWEP.Secondary.DefaultClip 	= 1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector(3.5,-5,2.5)
SWEP.IronSightsAng 		= Vector(0,0,0)
SWEP.SightsPos 			= SWEP.IronSightsPos
SWEP.SightsAng 			= SWEP.IronSightsAng


SWEP.Primary.KickUp         		= 0.3
SWEP.Primary.KickDown           	= 0.1
SWEP.Primary.KickHorizontal         = 0.2


SWEP.Kind 				= WEAPON_LIGHT
SWEP.AutoSpawnable 		= true
SWEP.AmmoEnt 			= "item_ammo_battery_mor"
SWEP.NeverRandom    	= false

SWEP.KGWeight = 15

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)

    num_bullets         = num_bullets or 1
    aimcone             = aimcone or 0

    
    local bullet = {}
        bullet.Num      = num_bullets
        bullet.Src      = self.Owner:GetShootPos()          -- Source
        bullet.Dir      = self.Owner:GetAimVector()         -- Dir of bullet
        bullet.Spread   = Vector(aimcone, aimcone, 0)           -- Aim Cone
        bullet.Tracer   = 1                         -- Show a tracer on every x bullets
        bullet.TracerName = "TracerGauss"
        bullet.Force    = damage * 0.5                  -- Amount of force to give to phys objects
        bullet.Damage   = damage
        bullet.Callback = function(attacker, tracedata, dmginfo) 
        
                        return self:RicochetCallback(0, attacker, tracedata, dmginfo) 
                      end

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

        util.Effect( "GaussImpact", effect );

    end

    return true;

end