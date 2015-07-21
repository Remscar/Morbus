SWEP.PrintName = "Alien Claws"

if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName      = "Alien Claws"
if (CLIENT) then
	SWEP.PrintName 		= "Alien Claws"
	SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
	SWEP.Slot 			= 0
    SWEP.DrawCrosshair  = true 
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "y"

end

SWEP.Spawnable          = true
SWEP.AdminSpawnable         = true
SWEP.Category       = "Morbus Weapons"

SWEP.Weight             = 5
SWEP.Base 				= "weapon_mor_melee"
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
    name =          "brood.swing",
    channel =       CHAN_ITEM,
    volume =        0.9,
    sound =             "npc/fast_zombie/claw_miss2.wav"
})

sound.Add({
    name =          "brood.hit",
    channel =       CHAN_ITEM,
    volume =        0.9,
    sound =             "hellknight/hit1.wav"
})

SWEP.SwingSound = Sound("brood.swing")
SWEP.HitSound = Sound("brood.hit")


SWEP.HoldType= "melee"

SWEP.Delay=0.55
SWEP.Range=92

SWEP.DamageDefault = 13
SWEP.Damage= SWEP.DamageDefault

SWEP.Kind = WEAPON_ROLE
SWEP.AutoSpawnable = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:SecondaryAttack()

    self.Damage = self.DamageDefault / 2
    self:PrimaryAttack()
    self.Damage = self.DamageDefault

    --self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay * 0.3)
    self.Weapon:SetNextSecondaryFire(CurTime() + self.Delay * 0.45)
end

function SWEP:PrimaryAttack()
    self:SetWeaponHoldType("melee")
    self.HolsterTime = CurTime() + 1.5

    self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)

    self.Owner:LagCompensation(true)
    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + (self.Owner:GetAimVector()*self.Range)
    trace.filter = self.Owner
    trace.mins = Vector(1,1,0.5) * -15
    trace.maxs = Vector(1,1,0.5) * 15
    trace.mask = CONTENTS_HITBOX + CONTENTS_MONSTER
    trace = util.TraceHull(trace)

    local trace2 = {}
    trace2.start = self.Owner:GetShootPos()
    trace2.endpos = trace2.start + (self.Owner:GetAimVector()*self.Range)
    trace2.filter = self.Owner
    trace2.mins = Vector(1,1,0.5) * -14
    trace2.maxs = Vector(1,1,0.5) * 14
    trace2 = util.TraceHull(trace2)

    if trace2.Fraction*1.3 < trace.Fraction then
        if SERVER then self.Owner:EmitSound(self.SwingSound,400,100) end
        trace = {}
        trace.start = self.Owner:GetShootPos()
        trace.endpos = trace.start + (self.Owner:GetAimVector()*self.Range)
        trace.filter = self.Owner
        trace = util.TraceLine(trace)
        if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity && !trace.Entity:IsPlayer() then
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            if SERVER then 

                print(trace.Entity:GetClass())

                local dmg = self.Damage

                local ed = EffectData()
                ed:SetOrigin(trace.HitPos)
                ed:SetEntity(trace.Entity)
                ed:SetNormal(trace.HitNormal)

                util.Effect("Impact", ed)

                trace.Entity:TakeDamage( dmg * 5, self.Owner, self.Weapon ) 
                

            
            end
        else
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        end
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self.HolsterTime = CurTime() + 1.5
        return 
    end

    if SERVER then self.Owner:EmitSound(self.SwingSound) end

    

    if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity:IsPlayer() or trace.Entity:IsNPC() then
        if SERVER then
            local a1,a2 = trace.Entity:GetAngles().y, self.Owner:GetAngles().y
            local diff = a1-a2

            local dmg = self.Damage

            local ed = EffectData()
            ed:SetOrigin(trace.HitPos)
            ed:SetEntity(trace.Entity)
            ed:SetNormal(trace.HitNormal)

            util.Effect("BloodImpact", ed)

            if (diff <= 60 && diff >= -60) then
                dmg = dmg * 2.5
                trace.Entity:TakeDamage( dmg , self.Owner, self.Weapon )
            else
                dmg = dmg
                trace.Entity:TakeDamage( dmg, self.Owner, self.Weapon )
            end


            local ent = trace.Entity

            



            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            self.Owner:EmitSound(self.HitSound,500,100)
        end
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    else
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    end
    self.Owner:SetAnimation( PLAYER_ATTACK1 )
    self.Owner:LagCompensation(false)

    self.HolsterTime = CurTime() + 1
    

end

function SWEP:Think()
    if self.HolsterTime && self.HolsterTime < CurTime() then
        --self:SetWeaponHoldType("fist")
    end

end

function SWEP:Deploy()

    if !self.Owner.CanTransform then return false end
    
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    return true
end