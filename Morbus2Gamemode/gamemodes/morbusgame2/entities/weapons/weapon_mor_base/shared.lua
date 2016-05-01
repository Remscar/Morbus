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
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

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
SWEP.ShowWorldModel = true
SWEP.MuzzleAttachment = "1"
SWEP.HasLaser = true
SWEP.HudPoint = "1"
SWEP.HasHud = true

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
SWEP.Primary.ReloadSpeed = 3.25
SWEP.Primary.ReloadAnim = ACT_VM_RELOAD
SWEP.Primary.Tracer = "Tracer"
SWEP.Primary.IronFOV = 50

SWEP.Primary.KickUp = 1.0
SWEP.Primary.KickDown = 0.25
SWEP.Primary.KickHorizontal = 1.0

-- We are going to be used Secondary fire for iron sights
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.IronFOV = 0 

SWEP.SightsPos = Vector (-4.7349, -7.416, 1.0654)
SWEP.SightsAng = Vector (0.1052, 0.0443, -1.1341)

function SWEP:CalculateReloadTimings()
  local vm = self.Owner:GetViewModel()
  self.ReloadSequence = vm:SelectWeightedSequence(self.Primary.ReloadAnim)
  --print("Reload Sequence:", self.ReloadSequence)

  self.ReloadDuration = vm:SequenceDuration(self.ReloadSequence)
  self.RealReloadDuration = self.ReloadDuration
  --print("Reload Duration:", self.ReloadDuration)

  if self.CustomReloadSpeed then
    self.ReloadPlaybackRate = self.ReloadDuration / self.Primary.ReloadSpeed
    --print("ReloadPlaybackRate:", self.ReloadPlaybackRate)

    self.ReloadDuration = self.Primary.ReloadSpeed
    --print("Reload Duration:", self.ReloadDuration)
  end
end

function SWEP:Initialize()
  self.IronSightsPos = self.SightsPos
  self.IronSightsAng = self.SightsAng

  self:SetWeaponHoldType(self.HoldType)
  self.Weapon:SetNetworkedBool("Reloading", false)

  if CLIENT then

    self.VElements = FullCopyTable( self.VElements )
    self.WElements = FullCopyTable( self.WElements )
    self.ViewModelBoneMods = FullCopyTable(self.ViewModelBoneMods)

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
    if not self.IsReloading then self:SendWeaponAnim(ACT_VM_IDLE) end
  end

  if not self.Owner:KeyDown(IN_SPEED) then

    -- If just hit iron sight button and not reloading
    if self.Owner:KeyPressed(IN_ATTACK2) and not self.Weapon:GetNWBool("Reloading") then
      self.Owner:SetFOV(self.Owner:GetFOV(), 0)
      self.Owner:SetFOV(self.Primary.IronFOV, 0.3)
      self.IronSightsPos = self.SightsPos
      self.IronSightsAng = self.SightsAng
      self:SetIronSights(true)

      return
    end

    -- If releasing iron sights
    if self.Owner:KeyReleased(IN_ATTACK2) then
      self.Owner:SetFOV(self.Owner:GetFOV(), 0)
      self.Owner:SetFOV(0, 0.15)
      self:SetIronSights(false)

      return
    end

    if self.Owner:KeyDown(IN_ATTACK) then

    end

  end
end

function SWEP:Think()
  self:IronSight()
end

function SWEP:CanReload()
  return self.Weapon:Clip1() < self.Weapon:GetMaxClip1() and
         self.Owner:GetAmmoCount(self.Weapon:GetPrimaryAmmoType()) > 0 and
         not self.Weapon:GetNWBool("Reloading", true) and
         not self.IsReloading
end


function SWEP:Reload()
  if not self:CanReload() then return end
  self:CalculateReloadTimings()

  self.Weapon:SendWeaponAnim(self.Primary.ReloadAnim)
  local vm = self.Owner:GetViewModel()
  --vm:SendViewModelMatchingSequence(self.ReloadSequence)
  vm:SetPlaybackRate(self.ReloadPlaybackRate)


  --@TODO: test + 3rd person


  self.ResetSights = CurTime() + self.ReloadDuration
  self.Owner:SetFOV(self.Owner:GetFOV(), 0)
  self.Owner:SetFOV(0, 0.15)
  self:SetIronSights(false)

  self.Weapon:SetNWBool("Reloading", true)
  self.IsReloading = true

  self.Weapon:SetNextPrimaryFire(CurTime() + self.ReloadDuration + 0.1 )

  timer.Create("Rld"..tostring(self:EntIndex()), self.ReloadDuration, 1,
    function()
      self:FinishReload()
    end)
end

function SWEP:FinishReload()
  if self.Weapon == nil then return end
  if not IsValid(self.Owner) then return end

  local ammoType = self.Weapon:GetPrimaryAmmoType()
  local curClip = self.Weapon:Clip1()
  local maxClip = self.Weapon:GetMaxClip1()
  local reserveAmmo = self.Owner:GetAmmoCount(ammoType)

  local takenAmmo = maxClip - curClip
  if takenAmmo > reserveAmmo then
    takenAmmo = reserveAmmo
  end

  self.IsReloading = false

  self.Owner:RemoveAmmo(takenAmmo, ammoType)
  self.Weapon:SetClip1(curClip + takenAmmo)

  self.Weapon:SetNWBool("Reloading", false)
end



function SWEP:Equip(newowner)
  if SERVER then
    if self:IsOnFire() then
      self:Extinguish()
    end
  end

  if SERVER then
    self.Owner:GiveAmmo(1000, self.Primary.Ammo)
  end

  if self.CustomReloadSpeed then
    self.ReloadDuration = self.Primary.ReloadSpeed
  end
end


function SWEP:Deploy()
  self.Weapon:SetNWBool("Reloading", false)
  self.IsReloading = false
  self:SetIronSights(false)
  self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
  self.ResetSights = CurTime() + self.Owner:GetViewModel():SequenceDuration()
  return true
end

function SWEP:Holster()
  if self.Weapon:GetNWBool("Reloading", false) then
    timer.Stop("Rld"..tostring(self:EntIndex()))
    self.Weapon:SetNWBool("Reloading", false)
    self.Weapon:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60) )
    self.IsReloading = false
  end

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

function SWEP:FireEffect()
  --self.Owner:MuzzleFlash()

  local fx = EffectData()
  fx:SetEntity(self.Weapon)
  fx:SetOrigin(self.Owner:GetShootPos())
  fx:SetNormal(self.Owner:GetAimVector())
  fx:SetAttachment(self.MuzzleAttachment)
  util.Effect("mor_muzzle_pistol",fx)
end

function SWEP:PrimaryAttack()
  if not self:CanPrimaryAttack() then return end
  if self.Owner:WaterLevel() >= 3 then return end
  if self.Owner:KeyDown(IN_SPEED) then return end
  if self.Owner:KeyDown(IN_RELOAD) then return end

  self.Weapon:EmitSound(self.Primary.Sound, 135, 100)
  self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
  self.Owner:SetAnimation(PLAYER_ATTACK1)
  self:FireEffect()

  self:ShootBullet()

  self.Weapon:TakePrimaryAmmo(1)
  self.Weapon:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60) )
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
    local kickAngle = Angle(math.Rand(-self.Primary.KickDown, self.Primary.KickUp) * recoil,
                            math.Rand(-self.Primary.KickHorizontal, self.Primary.KickHorizontal) * recoil,
                            0) -- No roll!
    self.Owner:ViewPunch(kickAngle)

    local newEyeAngle = self.Owner:EyeAngles()
    newEyeAngle.pitch = newEyeAngle.pitch - kickAngle.pitch
    newEyeAngle.yaw = newEyeAngle.yaw - kickAngle.yaw
    self.Owner:SetEyeAngles(newEyeAngle)
  end

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


function SWEP:Ammo1()
  return IsValid(self.Owner) and self.Owner:GetAmmoCount(self.Primary.Ammo) or false
end

function SWEP:DampenDrop()
  local phys = self:GetPhysicsObject()
  if IsValid(phys) then
    phys:SetVelocityInstantaneous(Vector(0, 0, -75) + phys:GetVelocity() * 0.001)
    phys:AddAngleVelocity(phys:GetAngleVelocity() * -0.99)
  end
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

function SWEP:SetIronSights(b)
  self.Weapon:SetNetworkedBool("Ironsights", b)
end

function SWEP:GetIronSights()
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

  SWEP.vRenderOrder = nil

  function SWEP:ViewModelDrawn()
    
    local vm = self.Owner:GetViewModel()
    if !IsValid(vm) then return end
    
    if (!self.VElements) then return end
    
    self:UpdateBonePositions(vm)

    if (!self.vRenderOrder) then
      
      -- // we build a render order because sprites need to be drawn after models
      self.vRenderOrder = {}

      for k, v in pairs( self.VElements ) do
        if (v.type == "Model") then
          table.insert(self.vRenderOrder, 1, k)
        elseif (v.type == "Sprite" or v.type == "Quad") then
          table.insert(self.vRenderOrder, k)
        end
      end
      
    end

    for k, name in ipairs( self.vRenderOrder ) do
    
      local v = self.VElements[name]
      if (!v) then self.vRenderOrder = nil break end
      if (v.hide) then continue end
      
      local model = v.modelEnt
      local sprite = v.spriteMaterial
      
      if (!v.bone) then continue end
      
      local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
      
      if (!pos) then continue end
      
      if (v.type == "Model" and IsValid(model)) then

        model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
        ang:RotateAroundAxis(ang:Up(), v.angle.y)
        ang:RotateAroundAxis(ang:Right(), v.angle.p)
        ang:RotateAroundAxis(ang:Forward(), v.angle.r)

        model:SetAngles(ang)
        -- //model:SetModelScale(v.size)
        local matrix = Matrix()
        matrix:Scale(v.size)
        model:EnableMatrix( "RenderMultiply", matrix )
        
        if (v.material == "") then
          model:SetMaterial("")
        elseif (model:GetMaterial() != v.material) then
          model:SetMaterial( v.material )
        end
        
        if (v.skin and v.skin != model:GetSkin()) then
          model:SetSkin(v.skin)
        end
        
        if (v.bodygroup) then
          for k, v in pairs( v.bodygroup ) do
            if (model:GetBodygroup(k) != v) then
              model:SetBodygroup(k, v)
            end
          end
        end
        
        if (v.surpresslightning) then
          render.SuppressEngineLighting(true)
        end
        
        render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
        render.SetBlend(v.color.a/255)
        model:DrawModel()
        render.SetBlend(1)
        render.SetColorModulation(1, 1, 1)
        
        if (v.surpresslightning) then
          render.SuppressEngineLighting(false)
        end
        
      elseif (v.type == "Sprite" and sprite) then
        
        local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
        render.SetMaterial(sprite)
        render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
        
      elseif (v.type == "Quad" and v.draw_func) then
        
        local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
        ang:RotateAroundAxis(ang:Up(), v.angle.y)
        ang:RotateAroundAxis(ang:Right(), v.angle.p)
        ang:RotateAroundAxis(ang:Forward(), v.angle.r)
        
        cam.Start3D2D(drawpos, ang, v.size)
          v.draw_func( self )
        cam.End3D2D()

      end
      
    end
    
  end

  SWEP.wRenderOrder = nil
  function SWEP:DrawWorldModel()

    if (self.ShowWorldModel == nil or self.ShowWorldModel) then
      self:DrawModel()
    end

    local tgt = LocalPlayer():GetObserverTarget()
    if (self.Owner == tgt) && (LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE) then return end
    
    if (!self.WElements) then return end
    
    if (!self.wRenderOrder) then

      self.wRenderOrder = {}

      for k, v in pairs( self.WElements ) do
        if (v.type == "Model") then
          table.insert(self.wRenderOrder, 1, k)
        elseif (v.type == "Sprite" or v.type == "Quad") then
          table.insert(self.wRenderOrder, k)
        end
      end

    end
    
    if (IsValid(self.Owner)) then
      bone_ent = self.Owner
    else
      -- // when the weapon is dropped
      bone_ent = self
    end
    
    for k, name in pairs( self.wRenderOrder ) do
    
      local v = self.WElements[name]
      if (!v) then self.wRenderOrder = nil break end
      if (v.hide) then continue end
      
      local pos, ang
      
      if (v.bone) then
        pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
      else
        pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
      end
      
      if (!pos) then continue end
      
      local model = v.modelEnt
      local sprite = v.spriteMaterial
      
      if (v.type == "Model" and IsValid(model)) then

        model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
        ang:RotateAroundAxis(ang:Up(), v.angle.y)
        ang:RotateAroundAxis(ang:Right(), v.angle.p)
        ang:RotateAroundAxis(ang:Forward(), v.angle.r)

        model:SetAngles(ang)
        -- //model:SetModelScale(v.size)
        local matrix = Matrix()
        matrix:Scale(v.size)
        model:EnableMatrix( "RenderMultiply", matrix )
        
        if (v.material == "") then
          model:SetMaterial("")
        elseif (model:GetMaterial() != v.material) then
          model:SetMaterial( v.material )
        end
        
        if (v.skin and v.skin != model:GetSkin()) then
          model:SetSkin(v.skin)
        end
        
        if (v.bodygroup) then
          for k, v in pairs( v.bodygroup ) do
            if (model:GetBodygroup(k) != v) then
              model:SetBodygroup(k, v)
            end
          end
        end
        
        if (v.surpresslightning) then
          render.SuppressEngineLighting(true)
        end
        
        render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
        render.SetBlend(v.color.a/255)
        model:DrawModel()
        render.SetBlend(1)
        render.SetColorModulation(1, 1, 1)
        
        if (v.surpresslightning) then
          render.SuppressEngineLighting(false)
        end
        
      elseif (v.type == "Sprite" and sprite) then
        
        local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
        render.SetMaterial(sprite)
        render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
        
      elseif (v.type == "Quad" and v.draw_func) then
        
        local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
        ang:RotateAroundAxis(ang:Up(), v.angle.y)
        ang:RotateAroundAxis(ang:Right(), v.angle.p)
        ang:RotateAroundAxis(ang:Forward(), v.angle.r)
        
        cam.Start3D2D(drawpos, ang, v.size)
          v.draw_func( self )
        cam.End3D2D()

      end
      
    end
    
  end

  function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
    
    local bone, pos, ang
    if (tab.rel and tab.rel != "") then
      
      local v = basetab[tab.rel]
      
      if (!v) then return end
      
      -- // Technically, if there exists an element with the same name as a bone
      -- // you can get in an infinite loop. Let's just hope nobody's that stupid.
      pos, ang = self:GetBoneOrientation( basetab, v, ent )
      
      if (!pos) then return end
      
      pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
      ang:RotateAroundAxis(ang:Up(), v.angle.y)
      ang:RotateAroundAxis(ang:Right(), v.angle.p)
      ang:RotateAroundAxis(ang:Forward(), v.angle.r)
        
    else
    
      bone = ent:LookupBone(bone_override or tab.bone)

      if (!bone) then return end
      
      pos, ang = Vector(0,0,0), Angle(0,0,0)
      local m = ent:GetBoneMatrix(bone)
      if (m) then
        pos, ang = m:GetTranslation(), m:GetAngles()
      end
      
      if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
        ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
        ang.r = -ang.r --// Fixes mirrored models
      end
    
    end
    
    return pos, ang
  end

  function SWEP:CreateModels( tab )

    if (!tab) then return end

    -- // Create the clientside models here because Garry says we can't do it in the render hook
    for k, v in pairs( tab ) do
      if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
          string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
        
        v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
        if (IsValid(v.modelEnt)) then
          v.modelEnt:SetPos(self:GetPos())
          v.modelEnt:SetAngles(self:GetAngles())
          v.modelEnt:SetParent(self)
          v.modelEnt:SetNoDraw(true)
          v.createdModel = v.model
        else
          v.modelEnt = nil
        end
        
      elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
        and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
        
        local name = v.sprite.."-"
        local params = { ["$basetexture"] = v.sprite }
        -- // make sure we create a unique name based on the selected options
        local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
        for i, j in pairs( tocheck ) do
          if (v[j]) then
            params["$"..j] = 1
            name = name.."1"
          else
            name = name.."0"
          end
        end

        v.createdSprite = v.sprite
        v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
        
      end
    end
    
  end
  
  local allbones
  local hasGarryFixedBoneScalingYet = false

  function SWEP:UpdateBonePositions(vm)
    
    if self.ViewModelBoneMods then
      
      if (!vm:GetBoneCount()) then return end
      
      -- // !! WORKAROUND !! --//
      -- // We need to check all model names :/
      local loopthrough = self.ViewModelBoneMods
      if (!hasGarryFixedBoneScalingYet) then
        allbones = {}
        for i=0, vm:GetBoneCount() do
          local bonename = vm:GetBoneName(i)
          if (self.ViewModelBoneMods[bonename]) then 
            allbones[bonename] = self.ViewModelBoneMods[bonename]
          else
            allbones[bonename] = { 
              scale = Vector(1,1,1),
              pos = Vector(0,0,0),
              angle = Angle(0,0,0)
            }
          end
        end
        
        loopthrough = allbones
      end
      //!! ----------- !! --
      
      for k, v in pairs( loopthrough ) do
        local bone = vm:LookupBone(k)
        if (!bone) then continue end
        
        -- // !! WORKAROUND !! --//
        local s = Vector(v.scale.x,v.scale.y,v.scale.z)
        local p = Vector(v.pos.x,v.pos.y,v.pos.z)
        local ms = Vector(1,1,1)
        if (!hasGarryFixedBoneScalingYet) then
          local cur = vm:GetBoneParent(bone)
          while(cur >= 0) do
            local pscale = loopthrough[vm:GetBoneName(cur)].scale
            ms = ms * pscale
            cur = vm:GetBoneParent(cur)
          end
        end
        
        s = s * ms
        //!! ----------- !! --
        
        if vm:GetManipulateBoneScale(bone) != s then
          vm:ManipulateBoneScale( bone, s )
        end
        if vm:GetManipulateBoneAngles(bone) != v.angle then
          vm:ManipulateBoneAngles( bone, v.angle )
        end
        if vm:GetManipulateBonePosition(bone) != p then
          vm:ManipulateBonePosition( bone, p )
        end
      end
    else
      self:ResetBonePositions(vm)
    end
       
  end
   
  function SWEP:ResetBonePositions(vm)
    
    if (!vm:GetBoneCount()) then return end
    for i=0, vm:GetBoneCount() do
      vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
      vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
      vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
    end
    
  end

end

function FullCopyTable(tab)
  if (!tab) then return nil end
  
  local res = {}
  for k, v in pairs( tab ) do
    if (type(v) == "table") then
      res[k] = FullCopyTable(v) --// recursion ho!
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