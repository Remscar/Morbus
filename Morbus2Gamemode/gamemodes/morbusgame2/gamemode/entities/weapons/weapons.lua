/*------------------------------------
 Morbus 2
 Zachary Nawar - zachary.nawar.org
 ------------------------------------*/

local Settings = Morbus.Settings

if not Morbus._WeaponList then
  Morbus._WeaponList = {}
end

local function PrepareWeaponTable(enumIdx, vModel, wModel)
  local wep = {}
  wep.Base = "weapon_mor_base"
  wep.ViewModel = Model(vModel)
  wep.WorldModel = Model(wModel)

  Settings:FillWeaponStats(enumIdx, wep)

  return wep
end

function RegisterWeaponTable(enumIdx, wepTable)
  local className = "weapon_mor_" .. string.lower(EnumWeapon[enumIdx])
  Morbus._WeaponList[enumIdx] = wepTable
  weapons.Register(wepTable, className)
  return wepTable
end

local function DeclareWeapon(enumIdx, vModel, wModel)
  return RegisterWeaponTable(enumIdx, PrepareWeaponTable(enumIdx, vModel, wModel))
end

function RegisterWeapons()
  local beretta = DeclareWeapon(eWeaponBeretta, "models/weapons/v_trh_92fs.mdl", "models/weapons/w_trh_92fs.mdl")

  local r22 = DeclareWeapon(eWeaponR22, "models/weapons/v_rif_zamas.mdl", "models/weapons/w_rif_zamas.mdl")

  local ka47 = DeclareWeapon(eWeaponKA47, "models/weapons/v_rif_lamas.mdl", "models/weapons/w_irifle.mdl")
  ka47.WElements = {
    ["WorldModel"] = { type = "Model", model = "models/weapons/w_rif_lamas.mdl", bone = "ValveBiped.Bip01_R_Hand",
     rel = "", pos = Vector(5, 5, 2), angle = Angle(-10, 0, 220), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255),
      surpresslightning = false, material = "", skin = 0, bodygroup = {} }
  }
  ka47.ShowWorldModel = false
end

RegisterWeapons()
