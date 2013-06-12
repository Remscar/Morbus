if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"
ENT.Base = "base_ammo_mor"
ENT.AmmoType = "Battery"
ENT.AmmoAmount = 10
ENT.AmmoMax = 40
ENT.Model = Model("models/Items/combine_rifle_cartridge01.mdl")
ENT.AutoSpawnable = true
ENT.NeverRandom = true
