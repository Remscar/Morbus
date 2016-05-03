/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

if not Morbus.Weapons then
  Morbus.Weapons = {}
end

function Morbus:AmmoList()
  return self._AmmoList
end

function Morbus:WeaponList()
  return self._WeaponList
end

local Weapons = Morbus.Weapons

function Weapons:AmmoList()
  return Morbus:AmmoList()
end

function Weapons:WeaponList()
  return Morbus:WeaponList()
end
