-- Read the weapon_real_base if you really want to know what each action does
-- Original Author: Remscar
-- Creator of "weapon_mor_teslar": Demonkush

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType 			= "ar2"
SWEP.PrintName 		= "Teslar-YN2"
if (CLIENT) then
	SWEP.PrintName 		= "Teslar-YN2"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= false

end

------------------------------------------------*/

SWEP.Base 				          = "weapon_mor_base"
SWEP.MuzzleAttachment		      = "1"
SWEP.Spawnable 			          = false
SWEP.AdminSpawnable 		      = false


SWEP.ViewModel 			  = "models/weapons/vw_ut3_shock.mdl"
SWEP.WorldModel 			= "models/weapons/vw_ut3_shock.mdl"
SWEP.ShowWorldModel         = true

SWEP.Primary.Sound 		   = Sound("weapons/railgun/teslar_shot1.wav")
SWEP.Primary.Recoil			= 1
SWEP.Primary.Damage			= 80
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.01
SWEP.Primary.ClipSize		= 4
SWEP.Primary.RPM			= 25
SWEP.Primary.DefaultClip	= 4
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "Battery"

SWEP.Primary.KickUp         = 2
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 1

SWEP.IronSightsPos = Vector(-10.8, -6, 2)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Kind = WEAPON_RIFLE
SWEP.HoldKind = WEAPON_LIGHT
SWEP.AmmoEnt = "item_ammo_battery_mor"
SWEP.KGWeight = 30
SWEP.AutoSpawnable      = true
SWEP.NeverRandom = false

SWEP.GunHud = {height = 4, width = 6, attachmentpoint = "1", enabled = true}

function SWEP:ShootBullet(damage, recoil, num_bullets, aimcone)

    num_bullets         = num_bullets or 1
    aimcone             = aimcone or 0


    
    local bullet = {}
        bullet.Num      = num_bullets
        bullet.Src      = self.Owner:GetShootPos()          -- Source
        bullet.Dir      = self.Owner:GetAimVector()         -- Dir of bullet
        bullet.Spread   = Vector(aimcone, aimcone, 0)           -- Aim Cone
        bullet.Tracer   = 1                         -- Show a tracer on every x bullets
        bullet.TracerName = "TracerTeslar"
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
    util.Effect( "TeslarMuzzle", effect );

        if SERVER then

        local tracedata = {}
        tracedata.start = self.Owner:GetShootPos()
        tracedata.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 20000
        tracedata.filter = self.Owner
        local tr = util.TraceLine( tracedata )
            if tr.Hit then
                self.HitPos = tr.HitPos

        self.tes = ents.Create( "point_tesla" ) -- extra electric effect
        self.tes:SetPos( tr.HitPos )
        self.tes:SetKeyValue( "m_SoundName", "" )
        self.tes:SetKeyValue( "texture", "sprites/bluelight1.spr" )
        self.tes:SetKeyValue( "m_Color", "155 65 255" )
        self.tes:SetKeyValue( "m_flRadius", "155" )
        self.tes:SetKeyValue( "beamcount_min", "2" )
        self.tes:SetKeyValue( "beamcount_max", "3" )
        self.tes:SetKeyValue( "thick_min", "8" )
        self.tes:SetKeyValue( "thick_max", "16" )
        self.tes:SetKeyValue( "lifetime_min", "0.3" )
        self.tes:SetKeyValue( "lifetime_max", "0.5" )
        self.tes:SetKeyValue( "interval_min", "0.1" )
        self.tes:SetKeyValue( "interval_max", "0.3" )
        self.tes:Spawn()
        self.tes:Fire( "DoSpark", "", 0 )
        self.tes:Fire( "DoSpark", "", 0 )
        self.tes:Fire( "DoSpark", "", 0.1 )
        self.tes:Fire( "DoSpark", "", 0.1 )
        self.tes:Fire( "DoSpark", "", 0.2 )
        self.tes:Fire( "kill", "", 0.3 )
        end
    end
end

function SWEP:DoImpactEffect( tr, dmgtype )

    if( tr.HitSky ) then return true; end
    
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData();
        effect:SetOrigin( tr.HitPos );
        effect:SetNormal( tr.HitNormal );

        util.Effect( "TeslarImpact", effect );

    end

    return true;

end

function SWEP:Reload()

    if self.Silenced then
        self.Weapon:DefaultReload(ACT_VM_RELOAD_SILENCED) 
    else
        self.Weapon:DefaultReload(ACT_VM_RELOAD) 
    end
    
    if !self.Owner:IsNPC() then
        self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration() end
    if SERVER and self.Weapon != nil then
    if ( self.Weapon:Clip1() < self.Primary.ClipSize ) and !self.Owner:IsNPC() then
    -- When the current clip < full clip and the rest of your ammo > 0, then
        self.Owner:SetFOV( 0, 0.3 )
        -- Zoom = 0
        self:SetIronsights(false)
        -- Set the ironsight to false
        self.Weapon:SetNetworkedBool("Reloading", true)
        
        --improper fix to the teslar reload exploit that works
        --simply forces you wait to 2.5s before firing the weapon
        self.Weapon:SetNextPrimaryFire(CurTime() + 2.5)
    end
    local waitdammit = (self.Owner:GetViewModel():SequenceDuration())
    timer.Simple(waitdammit + .1, 
        function() 
        if self.Weapon == nil then return end
        if self.Owner == nil then return end
        self.Weapon:SetNetworkedBool("Reloading", false)
        if self.Owner:KeyDown(IN_ATTACK2) and self.Weapon:GetClass() == self.Gun then 
            if CLIENT then return end
            if self.Scoped == false then
                self.Owner:SetFOV( 0, 0.3 )
                self.IronSightsPos = self.SightsPos                 -- Bring it up
                self.IronSightsAng = self.SightsAng                 -- Bring it up
                self:SetIronsights(true, self.Owner)
                self.DrawCrosshair = false
            else return end
        else return end
        end)
    end
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
            light.Size            = 512;
            light.Decay            = 800;
            light.R                = 115;
            light.G                = 65;
            light.B                = 255;
            light.Brightness    = 2;
            light.DieTime        = CurTime() + 0.15;
    
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
            render.DrawSprite( pos, self.Size, self.Size, Color( 115, 65, 255, alpha ) );
            render.StartBeam( 2 );
                render.AddBeam( pos - ang:Forward() * 12, 16, 0, Color( 115, 65, 255, alpha ) );
                render.AddBeam( pos + ang:Forward() * 12, 16, 1, Color( 115, 65, 255, 0 ) );
            render.EndBeam();
        end
    
    end
    
    effects.Register( EFFECT, "TeslarMuzzle" );
    
end
