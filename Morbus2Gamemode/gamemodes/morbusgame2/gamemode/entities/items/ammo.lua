/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local AmmoModels = {
  "models/items/boxsrounds.mdl",
  "models/items/boxmrounds.mdl",
  "models/items/boxsrounds.mdl",
  "models/items/boxbuckshot.mdl",
  "models/items/combine_rifle_cartridge01.mdl",
}

local AmmoColors = {
  Color(255, 255, 255, 255),
  Color(255, 255, 255, 255),
  Color(120, 120, 120, 255),
  Color(255, 255, 255, 255),
  Color(255, 255, 255, 255)
}



for i=1, eAmmoCount do
  local AmmoEnt = {}
  AmmoEnt.Type = "anim"
  AmmoEnt.Base = "mor_ammo_base"
  AmmoEnt.AmmoType = i
  AmmoEnt.Model = Model(AmmoModels[i])
  AmmoEnt.AmmoColor = AmmoColors[i]
  AmmoEnt.AutoSpawnable = true
  AmmoEnt.NeverRandom = false

  scripted_ents.Register(AmmoEnt, "mor_ammo_"..string.lower(EnumAmmo[i]))
end

function TestAmmo()
  local p1 = player.GetAll()[1]
  for i=1, eAmmoCount do
    local ammo = ents.Create("mor_ammo_"..string.lower(EnumAmmo[i]))
    ammo:SetPos(p1:GetPos() + Vector(i * 15, 25, 3))
    ammo:Spawn()
    ammo:PhysWake()
  end
end