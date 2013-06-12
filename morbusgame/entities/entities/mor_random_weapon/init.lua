
ENT.Type = "point"
ENT.Base = "base_point"

ENT.AutoAmmo = 0

function ENT:KeyValue(key, value)
   if key == "auto_ammo" then
      self.AutoAmmo = tonumber(value)
   end
end

function ENT:Initialize()
   local weps = ents.MORBUS.GetSpawnableSWEPs(true)
   if weps then
      local w = table.Random(weps)
   
      local ent = ents.Create(WEPS.GetClass(w))

      if IsValid(ent) then
         local pos = self:GetPos()
         pos.z = pos.z + 1
         ent:SetPos(pos)
         ent:SetAngles(self:GetAngles())
         ent:Spawn()
         ent:PhysWake()

         if true then
            self.AutoAmmo = math.Round(math.Rand(0,10)/4)
         end

         if ent.AmmoEnt and self.AutoAmmo > 0 then
            for i=1, self.AutoAmmo do
               local ammo = ents.Create(ent.AmmoEnt)
               if IsValid(ammo) then
                  pos.z = pos.z + 4 -- shift every box up a bit
                  ammo:SetPos(pos)
                  ammo:SetAngles(VectorRand():Angle())
                  ammo:Spawn()
                  ammo:PhysWake()
               end
            end
         end
      end

      self:Remove()
   end
end
