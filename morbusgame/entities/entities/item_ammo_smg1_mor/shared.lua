if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"
ENT.Base = "base_ammo_mor"
ENT.AmmoType = "SMG1"
ENT.AmmoAmount = 30
ENT.AmmoMax = 90
ENT.Model = Model("models/items/boxmrounds.mdl")
ENT.AutoSpawnable = true
ENT.NeverRandom = false