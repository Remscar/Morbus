SWEP.PrintName = "Alien"

if (SERVER) then
	AddCSLuaFile("shared.lua")
end
SWEP.PrintName      = "Swarm Alien"

if (CLIENT) then
	SWEP.PrintName 		= "Alien"
    SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
    SWEP.DrawCrosshair  = true 
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "y"

end
SWEP.Base 				= "weapon_mor_melee"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawWeaponInfoBox=false

SWEP.ViewModel = "models/Zed/weapons/v_Banshee.mdl"
SWEP.WorldModel = "models/weapons/w_fists.mdl"

SWEP.AllowDrop = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

sound.Add({
    name =          "swarm.swing",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "npc/vort/claw_swing2.wav"
})

sound.Add({
    name =          "swarm.hit",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "pinky/hit_01.wav"
})

sound.Add({
    name =          "swarm.spit",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "alien/acid_spit.wav"
})

SWEP.SwingSound = Sound("swarm.swing")
SWEP.HitSound = Sound("swarm.hit")
SWEP.SpitSound = Sound("swarm.spit")




SWEP.Delay=0.65
SWEP.Range=75
SWEP.Damage=11
SWEP.MaxNerf = 6
SWEP.Kind = WEAPON_ROLE
SWEP.AutoSpawnable = false

SWEP.HoldType = "melee"

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)

    self.Owner:LagCompensation(true)
    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + (self.Owner:GetAimVector()*self.Range)
    trace.filter = self.Owner
    trace.mins = Vector(1,1,1) * -14
    trace.maxs = Vector(1,1,1) * 14
    trace.mask = CONTENTS_MONSTER + CONTENTS_HITBOX + CONTENTS_DEBRIS
    trace = util.TraceHull(trace)

    local trace2 = {}
    trace2.start = self.Owner:GetShootPos()
    trace2.endpos = trace2.start + (self.Owner:GetAimVector()*self.Range)
    trace2.filter = self.Owner
    trace2.mins = Vector(1,1,1) * -12
    trace2.maxs = Vector(1,1,1) * 12
    trace2 = util.TraceHull(trace2)

    if trace2.Fraction*1.3 < trace.Fraction then
        if SERVER then self.Owner:EmitSound(self.SwingSound,200,100) end
        trace = {}
        trace.start = self.Owner:GetShootPos()
        trace.endpos = trace.start + (self.Owner:GetAimVector()*self.Range)
        trace.filter = self.Owner
        trace = util.TraceLine(trace)
        if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity && !trace.Entity:IsPlayer() then
            if SERVER then
                trace.Entity:TakeDamage( self.Damage*2, self.Owner, self.Weapon )
                self.Owner:EmitSound(self.HitSound,200,100)
            end
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        else
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        end
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        return 
    end


    if SERVER then self.Owner:EmitSound(self.SwingSound) end

    if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity:IsPlayer()  then
        if SERVER then
            local a1,a2 = trace.Entity:GetAngles().y, self.Owner:GetAngles().y
            local diff = a1-a2


            local mult = math.Clamp(#player.GetAll(),3,17)
            mult = (mult-3)/14
            mult = 1-mult
            mult = self.MaxNerf*mult -- how much lower?
            local dmg = self.Damage - self.MaxNerf
            dmg = dmg + mult
            dmg = dmg*2
            dmg = math.Round(dmg)



            if (diff <= 60 && diff >= -60) then
                trace.Entity:TakeDamage( dmg, self.Owner, self.Weapon ) --Surprise buttsex   
            else
                trace.Entity:TakeDamage( dmg, self.Owner, self.Weapon )
            end
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            self.Owner:EmitSound(self.HitSound,200,100)
        end
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    else

        if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity && !trace.Entity:IsPlayer() then
            if trace.Entity:GetClass() == "prop_ragdoll" then

                //if SERVER then
                -- timer.Simple(0.01, function()
                --     for i=1,4 do
                --         local effectdata = EffectData()
                --         effectdata:SetOrigin( trace.Entity:GetPos() + Vector(0,0,5) )
                --         effectdata:SetNormal( trace.Entity:GetVelocity():GetNormal() )
                --         util.Effect( "bloodsplash", effectdata )
                --         local effectdata2 = EffectData()
                --         effectdata2:SetOrigin( trace.Entity:GetPos() + Vector(0,0,5) )
                --         effectdata2:SetNormal( Vector(0,0,0.1) )
                --         util.Effect( "bloodstream", effectdata )
                --         local effectdata3 = EffectData()
                --         effectdata3:SetOrigin( trace.Entity:GetPos() + Vector(0,0,5) )
                --         effectdata3:SetNormal( Vector(0,0,0) )
                --         util.Effect( "goremod_gib", effectdata )
                --     end
                -- end)
                -- trace.Entity:Remove()
                //end
                self.Owner:EmitSound(self.HitSound,200,100)
            end
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        else
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        end
    end
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Owner:LagCompensation(false)

end

function SWEP:SecondaryAttack()
    self.Weapon:SetNextSecondaryFire(CurTime() + 3)
    
	local tr = self.Owner:GetEyeTrace()

	   local ent = ents.Create( "sent_spitball" )
		local aim = self.Owner:GetAimVector()
		local side = aim:Cross(Vector(0,0,1))
		local up = side:Cross(aim)
	if SERVER then
 	ent:SetPos(self.Owner:GetShootPos() +  aim * 24 + side * 8 + up * -15)
	ent:SetOwner( self.Owner )
	ent:SetAngles(self.Owner:EyeAngles())
	ent.RocketOwner = self.Owner
	ent:Spawn()
    self.Owner:EmitSound(self.SpitSound,200,100)
 
	local phys = ent:GetPhysicsObject()
	phys:ApplyForceCenter( self.Owner:GetAimVector() + 	self.Owner:GetForward(Vector(math.random(-255,255), math.random(-255,255), 0)) * 2100)
	phys:SetVelocity( phys:GetVelocity() + self.Owner:GetVelocity() )
	phys:EnableGravity(true)

	end
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if ( self.Owner:IsNPC() ) then return end
	
	
	local effect = EffectData();
	        effect:SetOrigin( self.Owner:GetShootPos() );
	        effect:SetEntity( self.Weapon );
	        effect:SetAttachment( 1 );
    util.Effect( "SpitMuzzle", effect );
		
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
        self.Size = math.Rand( 16, 24 );
        
        local pos, ang = GetMuzzlePosition( self.Weapon );
        local emitter = ParticleEmitter( pos );
        for i = 1, 10 do
        
            local particle = emitter:Add( "effects/blood_core", pos );
            particle:SetVelocity( VectorRand() * 0.25  * math.Rand( 5, 25 ) );
            particle:SetDieTime( math.Rand( 0.2, 0.6 ) );
            particle:SetStartAlpha( math.Rand( 50, 250 ) );
            particle:SetEndAlpha( 0 );
            particle:SetStartSize( math.Rand( 15, 25 ) );
            particle:SetEndSize( 0 );
            particle:SetRoll( math.Rand( 0, 359 ) );
            particle:SetRollDelta( math.Rand( -2, 2 ) );
            particle:SetColor(Color( 0, 150, 0 ));
            particle:SetGravity( Vector( 0, 0, 125 ) );
            particle:SetCollide( false );
            particle:SetBounce( 0 );
            particle:SetAirResistance( 2 );
        end
        // emit a burst of light
        local light = DynamicLight( self.Weapon:EntIndex() );
            light.Pos            = pos;
            light.Size            = 200;
            light.Decay            = 400;
            light.R                = 0;
            light.G                = 150;
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
            render.DrawSprite( pos, self.Size, self.Size, Color( 0, 150, 0, alpha ) );
            render.StartBeam( 2 );
                render.AddBeam( pos - ang:Forward() * 48, 16, 0, Color( 0, 150, 0, alpha ) );
                render.AddBeam( pos + ang:Forward() * 64, 16, 1, Color( 0, 150, 0, 0 ) );
            render.EndBeam();
        end
    
    end
    
    effects.Register( EFFECT, "SpitMuzzle" );
    
end


