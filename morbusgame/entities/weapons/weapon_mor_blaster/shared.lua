-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.HoldType 			= "pistol"
SWEP.PrintName 		= "Blaster"
if (CLIENT) then
	SWEP.PrintName 		= "Blaster"
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"
	SWEP.ViewModelFlip	= true

end

------------------------------------------------*/

SWEP.Base 				= "weapon_mor_base"
SWEP.MuzzleAttachment		= "1"
SWEP.Spawnable 			= false
SWEP.AdminSpawnable 		= false


SWEP.ViewModel 			= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_deagle.mdl"
SWEP.ShowWorldModel         = true

SWEP.Primary.Sound 		= Sound("weapons/blaster/blaster_fire1.wav")
SWEP.Primary.Recoil			= 0.8
SWEP.Primary.Damage			= 18
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 8
SWEP.Primary.RPM			= 90
SWEP.Primary.DefaultClip	= 8
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "Battery"

SWEP.Primary.KickUp         = 0.4
SWEP.Primary.KickDown           = 0.2
SWEP.Primary.KickHorizontal         = 0.4

SWEP.IronSightsPos = Vector(5.1, -2.2, 2.6)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = SWEP.IronSightsPos
SWEP.SightsAng = SWEP.IronSightsAng

SWEP.Kind = WEAPON_PISTOL
SWEP.AmmoEnt = "item_ammo_battery_mor"
SWEP.KGWeight = 7
SWEP.NeverRandom = true

SWEP.GunHud = {height = 2, width = 4, attachmentpoint = "1", enabled = false}




function SWEP:ShootBullet()
	local tr = self.Owner:GetEyeTrace()
	   local ent = ents.Create( "sent_blasterbolt" )

	local aim = self.Owner:GetAimVector()
	local side = aim:Cross(Vector(0,0,1))
	local up = side:Cross(aim)
	if SERVER then
 	ent:SetPos(self.Owner:GetShootPos() +  aim * 24 + side * 8 + up * -15)
	ent:SetOwner( self.Owner )
	ent:SetAngles(self.Owner:EyeAngles())
	ent.RocketOwner = self.Owner
	ent:Spawn()
 
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter( self.Owner:GetAimVector() + 	self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 4000)
	phys:SetVelocity( phys:GetVelocity() + self.Owner:GetVelocity() )
	phys:EnableGravity(false)

	end
	self.Owner:RemoveAmmo( 0, self.Primary.Ammo )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
	
	
	local effect = EffectData();
	        effect:SetOrigin( self.Owner:GetShootPos() );
	        effect:SetEntity( self.Weapon );
	        effect:SetAttachment( 1 );
    util.Effect( "RedMuzzle", effect );
		
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

    local GlowMaterial = CreateMaterial( "arcadiumsoft/glow", "UnlitGeneric", {
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
    
        // how'd this happen?
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
    
    effects.Register( EFFECT, "RedMuzzle" );
    
end