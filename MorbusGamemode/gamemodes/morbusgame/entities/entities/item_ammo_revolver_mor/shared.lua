if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"
ENT.Base = "base_ammo_mor"
ENT.AmmoType = "AlyxGun"
ENT.AmmoAmount = 30
ENT.AmmoMax = 90
ENT.Model = Model("models/items/boxsrounds.mdl")
ENT.AutoSpawnable = true
ENT.NeverRandom = false

function ENT:Initialize()
    self:SetColor(Color(120, 120, 120, 255))

    return self.BaseClass.Initialize(self)
end