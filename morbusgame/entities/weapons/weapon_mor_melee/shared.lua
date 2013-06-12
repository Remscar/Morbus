AddCSLuaFile("shared.lua")
SWEP.PrintName = "Crowbar"

if (CLIENT) then
    SWEP.PrintName      = "Crowbar"
    SWEP.ViewModelFOV       = 70
    SWEP.ViewModelFlip      = false
    SWEP.Slot           = 1
    SWEP.SlotPos        = 1
    SWEP.IconLetter         = "y"

end
SWEP.Base               = "weapon_mor_base"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawWeaponInfoBox=false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.SwingSound = "Weapon_Crowbar.Single"
SWEP.HitSound = "Weapon_Crowbar.Melee_Hit"

SWEP.HoldType="melee"

SWEP.AllowDrop = false
SWEP.Kind = WEAPON_MELEE

SWEP.Delay=0.7
SWEP.Range=75
SWEP.Damage=20
SWEP.AutoSpawnable = false

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
    return true
end


function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Delay)

    local trace = {}
    trace.start = self.Owner:GetShootPos()
    trace.endpos = trace.start + (self.Owner:GetAimVector()*self.Range)
    trace.filter = self.Owner
    trace.mins = Vector(1,1,1) * -10
    trace.maxs = Vector(1,1,1) * 10
    trace = util.TraceLine(trace)
    if SERVER then self.Owner:EmitSound(self.SwingSound) end

    if trace.Fraction < 1 && trace.HitNonWorld && trace.Entity:IsPlayer()  then
        if SERVER then
            trace.Entity:TakeDamage( self.Damage*2, self.Owner, self.Weapon )
            self.Owner:EmitSound(self.HitSound)
        end
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    elseif trace.Hit && trace.Entity then
            if SERVER then trace.Entity:TakeDamage( self.Damage*3, self.Owner, self.Weapon ) end
        self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
    else
        self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
    end
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

end



function SWEP:Reload()
    return false
end

function SWEP:Think()
    return false
end

function SWEP:SecondaryAttack()
    return false
end
