if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"
ENT.Base = "base_ammo_mor"
ENT.AmmoType = "Buckshot"
ENT.AmmoAmount = 8
ENT.AmmoMax = 16
ENT.Model = Model("models/items/boxbuckshot.mdl")
ENT.AutoSpawnable = true
ENT.NeverRandom = false