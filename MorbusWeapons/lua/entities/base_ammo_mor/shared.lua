if SERVER then
   AddCSLuaFile( "shared.lua" )
end

ENT.Type = "anim"

-- Override these values
ENT.AmmoType = "Pistol"
ENT.AmmoAmount = 1
ENT.AmmoMax = 10
ENT.NeverRandom = false
ENT.Model = Model( "models/items/boxsrounds.mdl" )

function ENT:RealInit() end

function ENT:Initialize()
   self:SetModel( self.Model )	

   self:PhysicsInit( SOLID_VPHYSICS )
   self:SetMoveType( MOVETYPE_VPHYSICS )
   self:SetSolid( SOLID_BBOX )

   self:SetCollisionGroup( COLLISION_GROUP_WEAPON)
   local b = 26
   self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

   if SERVER then
      self:SetTrigger(true)
   end

   self.taken = false

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
         if v and v.AmmoEnt == self:GetClass() then
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
   if SERVER and self.taken != true then
      if (ent:IsValid() and ent:IsPlayer() and self:CheckForWeapon(ent) and self:PlayerCanPickup(ent)) then

         local ammo = ent:GetAmmoCount(self.AmmoType)
         -- need clipmax info and room for at least 1/4th
         if self.AmmoMax >= (ammo + math.ceil(self.AmmoAmount * 0.25)) then
            local given = self.AmmoAmount
            given = math.min(given, self.AmmoMax - ammo)
            ent:GiveAmmo( given, self.AmmoType)
            
            self:Remove()
            
            -- just in case remove does not happen soon enough
            self.taken = true
         end
      end
   end
end

if SERVER then
   function ENT:Think()
      if not self.first_think then
         self:PhysWake()
         self.first_think = true

         -- Immediately unhook the Think, save cycles. The first_think thing is
         -- just there in case it still Thinks somehow in the future.
         self.Think = nil
      end
   end
end
