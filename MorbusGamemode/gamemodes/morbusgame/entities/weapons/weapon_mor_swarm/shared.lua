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
SWEP.Secondary.Automatic = true
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




SWEP.Delay      = 0.65
SWEP.Range      = 75
SWEP.Damage     = 8
SWEP.NerfDamage = 0
SWEP.MaxNerf    = 6
SWEP.Kind = WEAPON_ROLE
SWEP.AutoSpawnable  = false
SWEP.Destructing    = 0
SWEP.Beep       = CurTime() + 1
SWEP.refire     = 3
SWEP.Remotes    = 0
SWEP.attackType = "spit"

SWEP.FlameEffect    = "swep_flamethrower_flame2"
SWEP.FlameExpl      = "swep_flamethrower_explosion"

SWEP.spitBall = "sent_spitball"

SWEP.HoldType = "melee"

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)

end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire( CurTime() + self.Delay )
    
    if self.Weapon:GetNextSecondaryFire() < CurTime() + 1 then	
        self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
    end

    -- Start lag compensate for traces.
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

    -- End lag compensate after traces.
    self.Owner:LagCompensation(false)

    if trace2.Fraction*1.3 < trace.Fraction then
        if SERVER then self.Owner:EmitSound(self.SwingSound,200,100) end
        trace = {}
        trace.start = self.Owner:GetShootPos()
        trace.endpos = trace.start + (self.Owner:GetAimVector()*self.Range)
        trace.filter = self.Owner
        trace = util.TraceLine(trace)
        if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity && !trace.Entity:IsPlayer() then
            if SERVER then
                trace.Entity:TakeDamage( 16, self.Owner, self.Weapon )
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

            if (diff <= 60 && diff >= -60) then
                trace.Entity:TakeDamage( 8, self.Owner, self.Weapon ) --Surprise buttsex   
            else
                trace.Entity:TakeDamage( 8, self.Owner, self.Weapon )
            end
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            self.Owner:EmitSound(self.HitSound,200,100)
        end
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    else

        if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity && !trace.Entity:IsPlayer() then
            if trace.Entity:GetClass() == "prop_ragdoll" then

                self.Owner:EmitSound(self.HitSound,200,100)
            end
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        else
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        end
    end
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

function SWEP:Reload()
    self:RemoteDet()
end

function SWEP:RemoteDet()
    self.Remotes = 0
    for k, v in pairs ( ents.FindByClass( "sent_spitball_remote" ) ) do  
        if v:GetNWEntity( "Owner" ) == self.Owner then
            v.Exploded = 1
        end
    end 
    for k, v in pairs ( ents.FindByClass( "monster_hlfd_infection_h3" ) ) do  
        if v:GetNWEntity( "Owner" ) == self.Owner then
            v.Exploded = 1
        end
    end 
end

function SWEP:SecondaryAttack()

    if ( self.Owner:GetSwarmMod() == 0 ) then 
        self.spitBall = "sent_spitball"
        self.attackType = "spit"
        self.refire = 3
        self.SpitSound = Sound("swarm.spit")

    elseif ( self.Owner:GetSwarmMod() == 2 ) then 
        self.spitBall = "sent_spitball_ice"
        self.attackType = "spit"
        self.refire = 3
        self.SpitSound = Sound("alien.Impact2")

    elseif ( self.Owner:GetSwarmMod() == 3 ) then 
        self.spitBall = "sent_spitball_storm"
        self.attackType = "spit"
        self.refire = 3
        self.SpitSound = Sound("alien.Impact2")

    elseif ( self.Owner:GetSwarmMod() == 5 ) then 
        self.spitBall = "sent_spitball"
        self.attackType = "spit"
        self.refire = 3
        self.SpitSound = Sound("swarm.spit")

    elseif ( self.Owner:GetSwarmMod() == 7 ) then 
        self.spitBall = "sent_spitball_timed"
        self.attackType = "spit"
        self.refire = 2
        self.SpitSound = Sound("swarm.spit")

    elseif ( self.Owner:GetSwarmMod() == 8 ) then 
        self.spitBall = "sent_spitball_remote"
        self.attackType = "spit"
        self.refire = 1
        self.SpitSound = Sound("alien.Spit1")

    elseif ( self.Owner:GetSwarmMod() == 10 ) then 
        self.spitBall = "leap"
        self.attackType = "special"
        self.refire = 3
        self.SpitSound = Sound("alien.Grunt2")

    elseif ( self.Owner:GetSwarmMod() == 12 ) then 
        self.spitBall = "sent_spitball_acid"
        self.attackType = "spit"
        self.refire = 3
        self.SpitSound = Sound("alien.Impact2")

    end
    
    self.Weapon:SetNextSecondaryFire( CurTime() + ( self.refire ))

    if self.attackType == "spit" then
    	local tr = self.Owner:GetEyeTrace()
    	    local ent      = ents.Create( self.spitBall )
    		local aim     = self.Owner:GetAimVector()
    		local side    = aim:Cross( Vector( 0, 0, 1 ) )
    		local up      = side:Cross( aim )

    	if SERVER then
         	ent:SetPos( self.Owner:GetShootPos() +  aim * 24 + side * 8 + up * -15 )
        	ent:SetOwner( self.Owner )
        	ent:SetAngles( self.Owner:EyeAngles() )
        	ent.SpitOwner = self.Owner

            -- Remote Det
            if self.Owner:GetSwarmMod() == 8 then
                ent:SetNWEntity("Owner", self.Owner)
                if self.Remotes == 5 or self.Owner:KeyPressed(IN_RELOAD) then
                    self:RemoteDet()
                end
                self.Remotes = self.Remotes + 1
            end

        	   ent:Spawn()
            self.Owner:EmitSound( self.SpitSound, 200, 100 )
         
        	local phys = ent:GetPhysicsObject()
        	phys:ApplyForceCenter( self.Owner:GetAimVector() + 	self.Owner:GetForward( Vector( math.random( -255, 255 ), math.random( -255, 255 ), 0) ) * 2100 )
        	phys:SetVelocity( phys:GetVelocity() + self.Owner:GetVelocity() )
        	phys:EnableGravity( true )
    	end
    	
    	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    	self.Owner:SetAnimation( PLAYER_ATTACK1 )
    end

    -- Spikes
    if self.attackType == "bullet" then

        self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self:ShootBullet()

    end


    -- Special Abilities
    if self.attackType == "special" then

        -- Swarm Leap
        if self.spitBall == "leap" then
            self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
            self.Owner:SetAnimation( PLAYER_ATTACK1 )
            self.Owner:SetVelocity( self.Owner:GetForward() * 300 + Vector( 0, 0, 400 ) )
            if SERVER then
                self.Owner:EmitSound( self.SpitSound, 100, 100 )
            end
        end
	

        -- Self Destruct
        if self.spitBall == "destruct" then
            if SERVER then
                self.Weapon:SetNextSecondaryFire(CurTime() + 10)
                self.Owner:EmitSound( self.SpitSound, 200, 100 )
                self.Destructing = 1
                timer.Simple( 0.8, function()
                    ParticleEffect( "spit_blast", self:GetPos() + Vector( 0, 0, 50 ), Angle(0, 0, 0), nil )
                    self.Owner:EmitSound( self.SpitSound, 200, 100 )
                end)
                timer.Simple( 1.6, function()
                    ParticleEffect( "spit_blast", self:GetPos() + Vector( 0, 0, 50 ), Angle(0, 0, 0), nil )
                    self.Owner:EmitSound( self.SpitSound, 200, 100 )
                end)

                timer.Simple( 2.4, function()
                    if self.Owner:Alive() then
                        -- SFX
                        ParticleEffect( "destruct_blast", self:GetPos() + Vector( 0, 0, 50 ), Angle(0, 0, 0), nil )
                        self.Owner:EmitSound( "weapons/demon/explosion.wav", 100, math.random(95,125) );

                        -- Damage in sphere
                        for _, v in ipairs(ents.FindInSphere( self:GetPos(), 105 )) do
                            local dmginfo = DamageInfo()
                            dmginfo:SetAttacker( self.Owner )
                            dmginfo:SetInflictor( self.Weapon )
                            dmginfo:SetDamage( 90 )
                            v:TakeDamageInfo( dmginfo )
                        end

                        self.Owner:Kill()
                    end
                end)
            end
        end
    end
    -- End of Self Destruct

	if ( self.Owner:IsNPC() ) then return end
end

function SWEP:Think()   

end

-- Spikes
function SWEP:ShootBullet( damage, num_bullets, aimcone )

        local bullet = {}
            bullet.Num          = 8
            bullet.Src          = self.Owner:GetShootPos()
            bullet.Dir          = self.Owner:GetAimVector()
            bullet.Spread       = Vector( 0.1, 0.1, 0 )
            bullet.Tracer       = 8
            bullet.TracerName   = "Tracer"
            bullet.Force        = 355
            bullet.Damage       = 3

            self.Owner:FireBullets(bullet)
            self.Owner:EmitSound( self.SpitSound, 200, 100 )
            self:ShootEffects()

end

function SWEP:DoImpactEffect( tr, dmgtype )

    if( tr.HitSky ) then return true; end
    
    if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

        local effect = EffectData();
        effect:SetOrigin( tr.HitPos );
        effect:SetNormal( tr.HitNormal );
        ParticleEffect( "imp_phaser", tr.HitPos, Angle(0, 0, 0), nil )
        util.Effect( "GaussImpact", effect );

    end

    return true;

end
