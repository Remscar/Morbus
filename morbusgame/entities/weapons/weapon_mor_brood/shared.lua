SWEP.PrintName = "Alien Form"

if (SERVER) then
	AddCSLuaFile("shared.lua")
end

SWEP.PrintName      = "Alien Form"
if (CLIENT) then
	SWEP.PrintName 		= "Alien Form"
	SWEP.ViewModelFOV       = 70
	SWEP.ViewModelFlip		= false
	SWEP.Slot 			= 6
    SWEP.DrawCrosshair  = true 
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "y"

end
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
SWEP.Secondary.Automatic = false
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
SWEP.Damage=13
SWEP.Kind = WEAPON_ROLE
SWEP.AutoSpawnable = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
    self:SetWeaponHoldType("melee")
    self.HolsterTime = CurTime() + 1.5
    if SERVER then
        if self.Owner.Upgrades[UPGRADE.ATKSPEED] then
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay-(((self.Owner.Upgrades[UPGRADE.ATKSPEED]*UPGRADE.ATKSPEED_AMOUNT)/100)*self.Delay))
        else
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)
        end
    else
        if Morbus.Upgrades[UPGRADE.ATKSPEED] then
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay-(((Morbus.Upgrades[UPGRADE.ATKSPEED]*UPGRADE.ATKSPEED_AMOUNT)/100)*self.Delay))
        else
            self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)
        end
    end

    self.Owner:LagCompensation(true)
    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + (self.Owner:GetAimVector()*self.Range)
    trace.filter = self.Owner
    trace.mins = Vector(1,1,0.5) * -15
    trace.maxs = Vector(1,1,0.5) * 15
    trace.mask = CONTENTS_MONSTER + CONTENTS_HITBOX
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
                local dmg = self.Damage+(UPGRADE.CLAW_AMOUNT*(self.Owner.Upgrades[UPGRADE.CLAWS] or 0))

                trace.Entity:TakeDamage( dmg*5, self.Owner, self.Weapon ) 
                

            
            end
        else
            self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        end
        self.Owner:SetAnimation( PLAYER_ATTACK1 )
        self.HolsterTime = CurTime() + 1.5
        return 
    end

    if SERVER then self.Owner:EmitSound(self.SwingSound) end

    

    if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity:IsPlayer()  then
        if SERVER then
            local a1,a2 = trace.Entity:GetAngles().y, self.Owner:GetAngles().y
            local diff = a1-a2

            local dmg = self.Damage

            if (diff <= 60 && diff >= -60) then
                dmg = dmg*2 +(UPGRADE.CLAW_AMOUNT*(self.Owner.Upgrades[UPGRADE.CLAWS] or 0))
                trace.Entity:TakeDamage( dmg , self.Owner, self.Weapon )
            else
                dmg = dmg +(UPGRADE.CLAW_AMOUNT*(self.Owner.Upgrades[UPGRADE.CLAWS] or 0))
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