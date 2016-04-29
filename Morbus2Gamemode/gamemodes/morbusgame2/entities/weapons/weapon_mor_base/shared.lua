/*------------------------------------
 Morbus 2
 Zachary Nawar - zachary.nawar.org
 ------------------------------------*/

if SERVER then
 AddCSLuaFile("shared.lua")
end

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.HoldType = "ar2" -- ar2, pistol, shotgun, rpg, normal, melee, gernade, smg

-- Arbitrary Data
SWEP.Category = "Morbus 2 Weapons"
SWEP.PrintName = "Default Weapon Name"
SWEP.Author = "Remscar"
SWEP.Contact = "remscar@live.com"

-- Don't switch weapons when finding one of better weight
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

-- Morbus Stuff
SWEP.NeverRandom = false
SWEP.Weight = 10
SWEP.Type = 1
SWEP.AmmoType = 1
SWEP.AllowDrop = true
SWEP.IsDropped = false
SWEP.CustomReloadSpeed = true

-- Internal Variables
SWEP.RealReloadDuration = 2
SWEP.ReloadDuration = 2 -- This gets set in intialize
SWEP.ReloadPlaybackRate = 1
SWEP.ReloadSequence = 0

-- Visual Modifications
SWEP.VElements = {}
SWEP.WElements = {}
SWEP.ShowViewModel = true
SWEP.MuzzleAttachment = "1"
SWEP.HasLaser = true

SWEP.Primary.Sound = Sound("")
SWEP.Primary.Cone = 0.2
SWEP.Primary.Recoil = 10
SWEP.Primary.Damage = 10
SWEP.Primary.Spread = .01
SWEP.Primary.NumShots = 1
SWEP.Primary.RPM = 0
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ReloadSpeed = 1.5
SWEP.Primary.ReloadAnim = ACT_VM_RELOAD
SWEP.Primary.Tracer = "Tracer"

SWEP.Primary.KickUp = 1
SWEP.Primary.KickDown = 0.25
SWEP.Primary.KickHorizontal = 0.5

-- We are going to be used Secondary fire for iron sights
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.IronFOV = 0 



function SWEP:Initialize()
  self:SetWeaponHoldType(self.HoldType)
  self.Weapon:SetNetworkedBool("Reloading", false)



  local vm = self.Owner:GetViewModel()
  self.ReloadSequence = vm:SelectWeightedSequence(self.Primary.ReloadAnim)
  print("Reload Sequence:", self.ReloadSequence)

  self.ReloadDuration = vm:SequenceDuration(self.ReloadSequence)
  self.RealReloadDuration = self.ReloadDuration
  print("Reload Duration:", self.ReloadDuration)

  if self.CustomReloadSpeed then
    self.ReloadPlaybackRate = self.Primary.ReloadSpeed / self.ReloadDuration
    print("ReloadPlaybackRate:", self.ReloadPlaybackRate)

    self.ReloadDuration = self.Primary.ReloadSpeed
  end




  if CLIENT then
    self.VElements = table.FullCopy( self.VElements )
    self.WElements = table.FullCopy( self.WElements )
    self.ViewModelBoneMods = table.FullCopy(self.ViewModelBoneMods)

    self:CreateModels(self.VElements) -- create viewmodels
    self:CreateModels(self.WElements) -- create worldmodels

    if IsValid(self.Owner) and self.Owner:IsPlayer() then
      if self.Owner:Alive() then
        local vm = self.Owner:GetViewModel()
        if IsValid(vm) then
          self:ResetBonePositions(vm)
        end
      end
    end

  end
end




function SWEP:IronSight()
  if self.ResetSights and CurTime() >= self.ResetSights then
    self.ResetSights = false
    self:SendWeaponAnim(ACT_VM_IDLE)
  end

  if not self.Owner:KeyDown(IN_SPEED) then

    -- If just hit iron sight button and not reloading
    if self.Owner:KeyPressed(IN_ATTACK2) and not self.Weapon:GetNWBool("Reloading") then
      self.Owner:SetFOV(self.Owner:GetFOV(), 0)
      self.Owner:SetFOV(self.Primary.IronFOV, 0.3)
      self.IronSightsPos = self.SightsPos
      self.IronSightsAng = self.SightsAng
      self:SetIronSights(true, self.Owner)

      return
    end

    -- If releasing iron sights
    if self.Owner:KeyReleased(IN_ATTACK2) then
      self.Owner:SetFOV(self.Owner:GetFOV(), 0)
      self.Owner:SetFOV(0, 0.15)
      self:SetIronSights(true, self.Owner)

      return
    end

    if self.Owner:KeyDown(IN_ATTACK) then

    end

  end
end

function SWEP:Think()
  self:IronSight()
end



function SWEP:Reload()
  local vm = self.Owner:GetViewModel()
  vm:SetSequence(self.ReloadSequence)
  vm:SetPlaybackRate(self.ReloadPlaybackRate)
  --@TODO: test + 3rd person

  self.ResetSights = CurTime() + self.ReloadDuration

  if SERVER then
    self.Owner:SetFOV(self.Owner:GetFOV(), 0)
    self.Owner:SetFOV(0, 0.15)

    self:SetIronSights(false)
    self.Weapon:SetNWBool("Reloading", true)
  end

  timer.Simple(self.ReloadDuration + 0.1,
    function()
      if self.Weapon == nil then return end
      if not IsValid(self.Owner) then return end

      self.Weapon:SetNWBool("Reloading", false)
    end)
end




function SWEP:Deploy()
  self.Weapon:SetNWBool("Reloading", false)
  self:SetIronSights(false, self.Owner)
  self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
  self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
  return true
end

function SWEP:Holster()
  self.Weapon:SetNWBool("Reloading", false)

  if CLIENT and IsValid(self.Owner) then
    local vm = self.Owner:GetViewModel()
    if IsValid(vm) then
      self:ResetBonePositions(vm)
    end
  end

  return true
end

function SWEP:OnRemove()
  self:Holster()
end


function SWEP:PrimaryAttack()
  if not self:CanPrimaryAttack then return end
  if self.Owner:WaterLevel() >= 3 then return end
  if self.Owner:KeyDown(IN_SPEED) then return end
  if self.Owner:KeyDown(IN_RELOAD) then return end

  self:ShootBullet()

  self.Weapon:TakePrimaryAmmo(1)
  self.Weapon:SetNextPrimaryFire(CurTime() + 1 / self.Primary.RPM / 60)

  self.Weapon:EmitSound(self.Primary.Sound, 135, 100)
  self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
  self.Owner:SetAnimation(PLAYER_ATTACK1)
  self.Owner:MuzzleFlash()
  self:FireEffect()
end

function SWEP:ShootBullet()
  local damage
  local recoil
  local cone

  local damageDice = math.Rand(0.9, 1.1)
  damage = self.Primary.Damage * damageDice

  local recoilDice = math.Rand(0.9, 1.1)
  recoil = self.Primary.Recoil * recoilDice

  if self:GetIronSights() and self.Owner:KeyDown(IN_ATTACK2) then
    cone = self.Primary.Cone / 2
    recoil = recoil / 2
  else
    cone = self.Primary.Cone
  end

  if self.Owner:KeyDown(IN_FORWARD || IN_BACK || IN_MOVELEFT || IN_MOVERIGHT) then
    recoil = recoil * 2
    cone = cone * 1.5
  end

  local bullet = {}
  bullet.Num = self.Primary.NumShots
  bullet.Src = self.Owner:GetShootPos()
  bullet.Dir = self.Owner:GetAimVector()
  bullet.Spread = Vector(cone, cone, 0)
  bullet.Tracer = 1
  bullet.TracerName = self.Primary.Tracer
  bullet.Force = damage * 0.75
  bullet.Damage = damage

  self.Owner:FireBullets(bullet)

  /* Recoil */
  if CLIENT then
    local kickAngle = Angle(math.Rand(-self.Primary.KickUp, self.Primary.KickDown) * recoil,
                            math.Rand(-self.Primary.KickHorizontal, self.Primary.KickHorizontal) * recoil),
                            0) -- No roll!
    self.Owner:ViewPunch(kickAngle)

    local newEyeAngle = self.Owner:EyeAngles()
    newEyeAngle.pitch = newEyeAngle.pitch - kickAngle.pitch
    newEyeAngle.yaw = newEyeAngle.yaw - kickAngle.yaw
    self.Owner:SetEyeAngles(newEyeAngle)
  end

end

function SWEP:FireEffect()
  local fx = EffectData()
  fx:SetEntity(self.Weapon)
  fx:SetOrigin(self.Owner:GetShootPos())
  fx:SetNormal(self.Owner:GetAimVector())
  fx:SetAttachment(self.MuzzleAttachment)
  -- do a thing
end

function SWEP:SecondaryAttack()
  return false
end

function SWEP:CanPrimaryAttack()
  if self.Weapon:Clip1() <= 0 and self.Primary.ClipSize > -1 then
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.25)
    self.Weapon:EmitSound("Weapons/ClipEmpty_Pistol.wav")
    return false
  end

  return true
end

local IRONSIGHT_TIME = 0.35
function SWEP:GetViewModelPosition(pos, ang)

  if (not self.IronSightsPos) then return pos, ang end

  local bIron = self.Weapon:GetNWBool("Ironsights")

  if (bIron != self.bLastIron) then
    self.bLastIron = bIron
    self.fIronTime = CurTime()

  end

  local fIronTime = self.fIronTime or 0

  if (not bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
    return pos, ang
  end

  local Mul = 1.0

  if (fIronTime > CurTime() - IRONSIGHT_TIME) then
    Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

    if not bIron then Mul = 1 - Mul end
  end

  local Offset  = self.IronSightsPos

  if (self.IronSightsAng) then
    ang = ang * 1
    ang:RotateAroundAxis(ang:Right(),     self.IronSightsAng.x * Mul)
    ang:RotateAroundAxis(ang:Up(),    self.IronSightsAng.y * Mul)
    ang:RotateAroundAxis(ang:Forward(),   self.IronSightsAng.z * Mul)
  end

  local Right   = ang:Right()
  local Up    = ang:Up()
  local Forward   = ang:Forward()

  pos = pos + Offset.x * Right * Mul
  pos = pos + Offset.y * Forward * Mul
  pos = pos + Offset.z * Up * Mul

  return pos, ang
end

function SWEP:SetIronsights(b)
  self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronsights()
  return self.Weapon:GetNWBool("Ironsights")
end


if CLIENT then
  local LaserDot = Material("Sprites/light_glow02_add")

  function RenderLaserDots()
    for k,v in pairs(player.GetAll()) do
      local wep = v:GetActiveWeapon()

      if not IsValid(wep) or not wep.HasLaser then return end
        
      cam.Start3D(EyePos(), EyeAngles())
      local laserColor = Color(255, 0, 0, 220)
      local shootPos = v:GetShootPos()
      local ang = v:GetAimVector()

      local tr = {}
      tr.start = shootPos
      tr.endPos = shootPos + ang * 999999
      tr.filter = v
      tr.mask = MASK_SHOT

      local trace = util.TraceLine(tr)
      local dotSize = 4 + math.random() * 10
      local hitPos = trace.HitPos

      render.SetMaterial(LaserDot)
      render.DrawQuadEasy(hitPos + trace.HitNormal * 0.5, trace.HitNormal, dotSize, dotSize, color, 0)
      render.DrawQuadEasy(hitPos + trace.HitNormal * 0.5, trace.HitNormal * -1, dotSize, dotSize, color, 0)
      cam.End3D()
    end
  end

  hook.Add("RenderScreenspaceEffects", "Morbus_LaserDot", RenderLaserDots)
end




function SWEP:CreateModels(models)

end

function SWEP:ResetBonePositions(mdl)

end

local function table.FullCopy( tab )

    if (!tab) then return nil end
    
    local res = {}
    for k, v in pairs( tab ) do
      if (type(v) == "table") then
        res[k] = table.FullCopy(v) --// recursion ho!
      elseif (type(v) == "Vector") then
        res[k] = Vector(v.x, v.y, v.z)
      elseif (type(v) == "Angle") then
        res[k] = Angle(v.p, v.y, v.r)
      else
        res[k] = v
      end
    end
    
    return res
    
  end