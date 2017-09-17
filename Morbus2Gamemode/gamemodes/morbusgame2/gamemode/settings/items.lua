--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

local Settings = Morbus.Settings

-- Morbus.Settings.Items = {}
function Settings:DefaultItems()
  local items = self.Items

  items.AmmoPickup = {}
  local ammo = items.AmmoPickup
  ammo[eAmmoPistol] = 15
  ammo[eAmmoSMG] = 30
  ammo[eAmmoRifle] = 30
  ammo[eAmmoShotgun] = 8
  ammo[eAmmoBattery] = 10

end
