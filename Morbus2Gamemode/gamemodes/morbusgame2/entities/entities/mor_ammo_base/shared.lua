/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

if SERVER then AddCSLuaFile("shared.lua") end

ENT.Type = "anim"

ENT.AmmoType = eAmmoPistol
ENT.AmmoAmount = 1
ENT.NeverRandom = false
ENT.Model = Model("models/items/boxsrounds.mdl")
ENT.AmmoColor = Color(255, 255, 255, 255)

function ENT:Initialize()
  self:SetModel(self.Model)
  self:SetColor(self.AmmoColor)

  self:PhysicsInit( SOLID_VPHYSICS )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_BBOX )

  self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
  local b = 26
  self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

  if SERVER then
    self:SetTrigger(true)
  end

  self.AmmoAmount = Morbus.Settings.Items.AmmoPickup[self.AmmoType]

  self.empty = false
end

function ENT:PlayerCanPickup(ply)
   if ply == self:GetOwner() then return false end

   local ent = self.Entity
   local phys = ent:GetPhysicsObject()   
   local spos = phys:IsValid() and phys:GetPos() or ent:OBBCenter()
   local epos = ply:GetShootPos() -- equiv to EyePos in SDK

   local tr = util.TraceLine({start=spos, endpos=epos, filter={ply, ent}, mask=MASK_SOLID})

   -- can pickup if trace was not stopped
   return tr.Fraction == 1.0
end

function ENT:CheckForWeapon(ply)
   if not self.CachedWeapons then
      -- create a cache of what weapon classes use this ammo
      local tbl = {}
      for k,v in pairs(weapons.GetList()) do
         if v and v.AmmoType == self.AmmoType then
            table.insert(tbl, v.ClassName)
         end
      end

      self.CachedWeapons = tbl
   end

   for _, w in pairs(self.CachedWeapons) do
      if ply:HasWeapon(w) then return true end
   end
   return false
end


function ENT:Touch(ent)
   if SERVER and self.empty != true then
      if (ent:IsValid() and ent:IsPlayer() and self:CheckForWeapon(ent) and self:PlayerCanPickup(ent)) then

         local ammo = ent:GetAmmoCount(EnumAmmo[self.AmmoType])
         local maxAmmo = Morbus.Settings.Player.AmmoTypeLimit[self.AmmoType]

         -- Can only pick up ammo if you have room to carry it
         if ammo < maxAmmo then
            local given = self.AmmoAmount
            given = math.min(given, maxAmmo - ammo)
            ent:GiveAmmo(given, self.AmmoType)
            
            self.AmmoAmount = self.AmmoAmount - given

            if self.AmmoAmount <= 0 then
              self:Remove()
              self.empty = true
            end
         end
         
      end
   end
end