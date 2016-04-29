/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local Settings = Morbus.Settings


local function DefaultWeapon(wep, enum)
  wep.ID = enum
  wep.Name = EnumWeapon[enum]
  wep.Custom = false
end

-- Morbus.Settings.Weapons = {}
function Settings:DefaultWeapons()
  local weps = self.Weapons

  /* Do a pass through every enum entry and default it */
  for i=1, eWeaponCount do
    weps[i] = {} -- Should I really remake the table every time?
    DefaultWeapon(weps[i], i)
  end

  /* Fill in the stats */
  self:DefaultWeaponStats()
end

-- Name should match enum
function Settings:GetWeapon(name)
  return self.Weapons[_G["eWeapon"..name]]
end

function Settings:SetWeaponStats(name, defFunc, dmg, rpm, cone, recoil, clip, weight)
  local wep = self:GetWeapon(name)

  if defFunc then
    defFunc(wep)
  end

  wep.Damage =  dmg
  wep.RPM = rpm
  wep.Cone = cone
  wep.Recoil = recoil
  wep.Clip = clip
  wep.Weight = weight

  return wep
end

/* Helpers for basic weapons */
local function DefaultPistol(wep)
  wep.HoldType = "pistol"
  wep.AmmoType = eAmmoPistol
  wep.Type = eWTypeHandgun

  wep.NumShots = 1
  wep.Automatic = false
end

local function DefaultSMG(wep)
  wep.HoldType = "ar2"
  wep.AmmoType = eAmmoSMG
  wep.Type = eWTypeLight

  wep.NumShots = 1
  wep.Automatic = true
end

local function DefaultRifle(wep)
  wep.HoldType = "ar2"
  wep.AmmoType = eAmmoRifle
  wep.Type = eWTypeRifle

  wep.NumShots = 1
  wep.Automatic = true
end


function Settings:DefaultWeaponStats()
  local weps = self.Weapons

  self:SetWeaponStats("Beretta", DefaultPistol,
    18, 330, 0.01, 0.2, 8, 3)

  self:SetWeaponStats("R22", DefaultSMG,
    13, 660, 0.04, 0.5, 40, 16)

  self:SetWeaponStats("KA47", DefaultRifle,
    19, 500, 0.0375, 0.44, 30, 24)

end

function Settings:FillWeaponStats(enumName, swepTable)
  local wep = self:GetWeapon(enumName)

  swepTable.PrintName = wep.Name -- Do i need this?
  swepTable.HoldType = wep.HoldType -- Do i need this?

  swepTable.Weight = wep.Weight -- Means something different to the engine

  swepTable.Primary.Damage = wep.Damage
  swepTable.Primary.RPM = wep.RPM
  swepTable.Primary.Cone = wep.Cone
  swepTable.Primary.Recoil = wep.Recoil
  swepTable.Primary.NumShots = wep.NumShots
  swepTable.Primary.ClipSize = wep.Clip
  swepTable.Primary.DefaultClip = wep.Clip
  swepTable.Primary.Ammo = EnumAmmo[wep.AmmoType]
  swepTable.Primary.AmmoType = wep.AmmoType
  swepTable.Primary.Automatic = wep.Automatic
end