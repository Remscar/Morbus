---- Dummy ent that just spawns a random TTT ammo item and kills itself

ENT.Type = "point"
ENT.Base = "base_point"


function ENT:Initialize()
   local ammos = ents.MORBUS.GetSpawnableAmmo(true)

   local chance = math.Rand(1,3)

   if chance > 2 then return end

   if ammos then
      local cls = table.Random(ammos)
      local ent = ents.Create(cls)
      if IsValid(ent) then
         local pos = self:GetPos()
         pos.z = pos.z + 3
         ent:SetPos(pos)
         ent:SetAngles(self:GetAngles())
         ent:Spawn()
         ent:PhysWake()
      end

      self:Remove()
   end
end