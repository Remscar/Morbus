if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"
ENT.Base = "base_ammo_mor"
ENT.AmmoType = "Pistol"
ENT.AmmoAmount = 15
ENT.AmmoMax = 60
ENT.Model = Model("models/items/boxsrounds.mdl")
ENT.AutoSpawnable = true
ENT.NeverRandom = false