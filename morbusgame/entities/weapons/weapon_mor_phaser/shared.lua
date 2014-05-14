-- Read the weapon_real_base if you really want to know what each action does
-- Original Author: Remscar
-- Creator of "weapon_mor_phaser": Demonkush

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType 			= "pistol"
SWEP.PrintName 		  = "JV1-Phaser" -- Jarvis
if (CLIENT) then
	SWEP.PrintName 		= "JV1-Phaser"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter     = "b"
	SWEP.ViewModelFlip	= false

end

------------------------------------------------*/

SWEP.Base 				      = "weapon_mor_base"
SWEP.MuzzleAttachment		  = "1"
SWEP.Spawnable 			      = false
SWEP.AdminSpawnable 		  = false


SWEP.ViewModel 			     = "models/weapons/v_pistol.mdl"
SWEP.WorldModel 			 = "models/weapons/w_pistol.mdl"
SWEP.ShowWorldModel          = true

SWEP.Primary.Sound 		   = Sound("weapons/railgun/pulsar_shot1.wav")
SWEP.Primary.Recoil			= 0.4
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.ClipSize		= 10
SWEP.Primary.RPM			= 155
SWEP.Primary.DefaultClip	= 10
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		    = "Battery"

SWEP.Primary.KickUp                 = 0.4
SWEP.Primary.KickDown               = 0.2
SWEP.Primary.KickHorizontal         = 0.4

SWEP.IronSightsPos  = Vector(-5.8, -14, 4)
SWEP.IronSightsAng  = Vector(0, -1.6, 2)
SWEP.SightsPos      = SWEP.IronSightsPos
SWEP.SightsAng      = SWEP.IronSightsAng

SWEP.Kind           = WEAPON_PISTOL
SWEP.AmmoEnt        = "item_ammo_battery_mor"
SWEP.KGWeight       = 5
SWEP.AutoSpawnable  = true
SWEP.NeverRandom    = false

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}




function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)

    num_bullets         = num_bullets or 1
    aimcone             = aimcone or 0

    
    local bullet = {}
        bullet.Num      = num_bullets
        bullet.Src      = self.Owner:GetShootPos()          -- Source
        bullet.Dir      = self.Owner:GetAimVector()         -- Dir of bullet
        bullet.Spread   = Vector(aimcone, aimcone, 0)           -- Aim Cone
        bullet.Tracer   = 1                         -- Show a tracer on every x bullets
        bullet.TracerName = "TracerRailgun"
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

        local effect = EffectData();
            effect:SetOrigin( self.Owner:GetShootPos() );
            effect:SetEntity( self.Weapon );
            effect:SetAttachment( 1 );
        util.Effect( "PhaserMuzzle", effect );

end

function SWEP:DoImpactEffect( tr, dmgtype )

    if( tr.HitSky ) then return true; end
    
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData();
        effect:SetOrigin( tr.HitPos );
        effect:SetNormal( tr.HitNormal );

        util.Effect( "PhaserImpact", effect );

    end

    return true;

end

/*------------------------------------
    GetMuzzlePosition()
------------------------------------*/
local function GetMuzzlePosition( weapon, attachment )

    if( !IsValid( weapon ) ) then
        return vector_origin, Angle( 0, 0, 0 );
    end

    local origin = weapon:GetPos();
    local angle = weapon:GetAngles();
    
    // if we're not in a camera and we're being carried by the local player
    // use their view model instead.
    if( weapon:IsWeapon() && weapon:IsCarriedByLocalPlayer() ) then
    
        local owner = weapon:GetOwner();
        if( IsValid( owner ) && GetViewEntity() == owner ) then
        
            local viewmodel = owner:GetViewModel();
            if( IsValid( viewmodel ) ) then
                weapon = viewmodel;
            end
            
        end
    
    end

    // get the attachment
    local attachment = weapon:GetAttachment( attachment or 1 );
    if( !attachment ) then
        return origin, angle;
    end
    
    return attachment.Pos, attachment.Ang;

end

if( CLIENT ) then

    local GlowMaterial = CreateMaterial( "mb/glow", "UnlitGeneric", {
        [ "$basetexture" ]    = "sprites/light_glow01",
        [ "$additive" ]        = "1",
        [ "$vertexcolor" ]    = "1",
        [ "$vertexalpha" ]    = "1",
    } );
    
    local EFFECT = {};
    
    
    /*------------------------------------
        Init()
    ------------------------------------*/
    function EFFECT:Init( data )
    
        self.Weapon = data:GetEntity();
        
        self.Entity:SetRenderBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) );
        self.Entity:SetParent( self.Weapon );
        
        self.LifeTime = math.Rand( 0.25, 0.35 );
        self.DieTime = CurTime() + self.LifeTime;
        self.Size = math.Rand( 5, 15 );
        
        local pos, ang = GetMuzzlePosition( self.Weapon );
        
        // emit a burst of light
        local light = DynamicLight( self.Weapon:EntIndex() );
            light.Pos            = pos;
            light.Size            = 200;
            light.Decay            = 400;
            light.R                = 255;
            light.G                = 155;
            light.B                = 0;
            light.Brightness    = 2;
            light.DieTime        = CurTime() + 0.35;
    
    end
    
    
    /*------------------------------------
        Think()
    ------------------------------------*/
    function EFFECT:Think()
    
        return IsValid( self.Weapon ) && self.DieTime >= CurTime();
        
    end
    
    
    /*------------------------------------
        Render()
    ------------------------------------*/
    function EFFECT:Render()
    
        // howd this happen?
        if( !IsValid( self.Weapon ) ) then
            return;
        end
    
        local pos, ang = GetMuzzlePosition( self.Weapon );
        
        local percent = math.Clamp( ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 );
        local alpha = 255 * percent;
        
        render.SetMaterial( GlowMaterial );
        
        // draw it twice to double the brightness D:
        for i = 1, 2 do
            render.DrawSprite( pos, self.Size, self.Size, Color( 255, 155, 0, alpha ) );
            render.StartBeam( 2 );
                render.AddBeam( pos - ang:Forward() * 12, 16, 0, Color( 255, 155, 0, alpha ) );
                render.AddBeam( pos + ang:Forward() * 12, 16, 1, Color( 255, 155, 0, 0 ) );
            render.EndBeam();
        end
    
    end
    
    effects.Register( EFFECT, "PhaserMuzzle" );
    
end