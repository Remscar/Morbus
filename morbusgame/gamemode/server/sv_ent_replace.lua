---------------------------------LOCALIZATION
local math = math
local table = table
local umsg = umsg
local player = player
local timer = timer
local pairs = pairs
local umsg = umsg
local usermessage = usermessage
local file = file
---------------------------------------------
/*--------------------------------------------
MORBUS ENTITY REPLACEMENT
Credits to TTT for this script
--------------------------------------------*/

ents.MORBUS = {}




local function ReplaceSingle(ent, newname)

   if ent:GetPos() == vector_origin then
      return
   end

   ent:SetSolid(SOLID_NONE)

   local rent = ents.Create(newname)
   rent:SetPos(ent:GetPos())
   rent:SetAngles(ent:GetAngles())
   rent:Spawn()

   rent:Activate()
   rent:PhysWake()

   ent:Remove()
end


local hl2_ammo_replace = {
   ["item_ammo_pistol"] = "item_ammo_pistol_mor",
   ["item_box_buckshot"] = "item_ammo_buckshot_mor",
   ["item_ammo_smg1"] = "item_ammo_smg1_mor",
   ["item_ammo_357"] = "item_ammo_pistol_mor",
   ["item_ammo_357_large"] = "item_ammo_pistol_mor",
   ["item_ammo_revolver"] = "item_ammo_revolver_mor", -- zm
   ["item_ammo_ar2"] = "item_ammo_revolver_mor",
   ["item_ammo_ar2_large"] = "item_ammo_smg1_mor",
   ["item_ammo_smg1_grenade"] = "item_ammo_pistol_mor",
   ["item_battery"] = "item_ammo_pistol_mor",
   ["item_healthkit"] = "item_ammo_buckshot_mor",
   ["item_suitcharger"] = "item_ammo_revolver_mor",
   ["item_ammo_ar2_altfire"] = "item_ammo_revolver_mor",
   ["item_rpg_round"] = "item_ammo_smg1_mor",
   ["item_ammo_crossbow"] = "item_ammo_buckshot_mor",
   ["item_healthvial"] = "item_ammo_buckshot_mor",
   ["item_healthcharger"] = "item_ammo_pistol_mor",
   ["item_ammo_crate"] = "item_ammo_smg1_mor",
   ["item_item_crate"] = "item_ammo_smg1_mor"
}


local function ReplaceAmmoSingle(ent, cls)
   if cls == nil then cls = ent:GetClass() end

   local rpl = hl2_ammo_replace[cls]
   if rpl then
      ReplaceSingle(ent, rpl)
   end
end


local function ReplaceAmmo()
   for _, ent in pairs(ents.FindByClass("item_*")) do
      ReplaceAmmoSingle(ent)
   end
end

local hl2_weapon_replace = {
   ["weapon_smg1"] = "weapon_mor_r22",
   ["weapon_shotgun"] = "weapon_mor_r22",
   ["weapon_ar2"] = "weapon_mor_m20",
   ["weapon_357"] = "weapon_mor_m20",
   ["weapon_crossbow"] = "weapon_mor_ka47",
   ["weapon_rpg"] = "weapon_mor_ka47",
   ["weapon_slam"] = "item_ammo_pistol_mor",
   ["weapon_frag"] = "weapon_mor_ka47",
   ["weapon_crowbar"] = "weapon_mor_m20"
}

local function ReplaceWeaponSingle(ent, cls)
   if ent.AllowDelete == false then
      return
   else
      if cls == nil then cls = ent:GetClass() end
      
      local rpl = hl2_weapon_replace[cls]
      if rpl then
         ReplaceSingle(ent, rpl)
      end
      
   end
end


local function ReplaceWeapons()
   for _, ent in pairs(ents.FindByClass("weapon_*")) do
      ReplaceWeaponSingle(ent)
   end
end


local function RemoveCrowbars()
   for k, ent in pairs(ents.FindByClass("weapon_zm_improvised")) do
      ent:Remove()
   end
end


function ents.MORBUS.ReplaceEntities()
   ReplaceAmmo()
   ents.MORBUS.RemoveRagdolls()
   ReplaceWeapons()
   RemoveCrowbars()
end


local cls = "" -- avoid allocating
local sub = string.sub
local function ReplaceOnCreated(s, ent)
   -- Invalid ents are of no use anyway
   if not ent:IsValid() then return end

   cls = ent:GetClass()

   if sub(cls, 1, 4) == "item" then
      ReplaceAmmoSingle(ent, cls)
   elseif sub(cls, 1, 6) == "weapon" then
      ReplaceWeaponSingle(ent, cls)
   end
end

local noop = util.noop

GM.OnEntityCreated = ReplaceOnCreated

-- Helper so we can easily turn off replacement stuff when we don't need it
function ents.MORBUS.SetReplaceChecking(state)
   if state then
      GAMEMODE.OnEntityCreated = ReplaceOnCreated
   else
      GAMEMODE.OnEntityCreated = noop
   end
end


local broken_parenting_ents = {
   "move_rope",
   "keyframe_rope",
   "info_target",
   "func_brush"
}


function ents.MORBUS.FixParentedPreCleanup()
   for _, rcls in pairs(broken_parenting_ents) do
      for k,v in pairs(ents.FindByClass(rcls)) do
         if IsValid(v:GetParent()) then
            v.CachedParentName = v:GetParent():GetName()
            v:SetParent(nil)

            if not v.OrigPos then
               v.OrigPos = v:GetPos()
            end
         end
      end
   end
end


function ents.MORBUS.FixParentedPostCleanup()
   for _, rcls in pairs(broken_parenting_ents) do
      for k,v in pairs(ents.FindByClass(rcls)) do
         if v.CachedParentName then
            if v.OrigPos then
               v:SetPos(v.OrigPos)
            end

            local parents = ents.FindByName(v.CachedParentName)
            if #parents == 1 then
               local parent = parents[1]
               v:SetParent(parent)
            end
         end
      end
   end
end

function ents.MORBUS.RemoveRagdolls(player_only)
   for k, ent in pairs(ents.FindByClass("prop_ragdoll")) do
      if IsValid(ent) then
         if not player_only and string.find(ent:GetModel(), "zm_", 6, true) then
            ent:Remove()
         elseif ent.ragdoll then
            -- cleanup ought to catch these but you know
            ent:Remove()
         end
      end
   end
end


local dummify = {
   -- CS:S
   "hostage_entity",
   -- TF2
   "item_ammopack_full",
   "item_ammopack_medium",
   "item_ammopack_small",
   "item_healthkit_full",
   "item_healthkit_medium",
   "item_healthkit_small",
   "item_teamflag",
   "game_intro_viewpoint",
   "info_observer_point",
   "team_control_point",
   "team_control_point_master",
   "team_control_point_round",
   -- ZM
   "item_ammo_revolver"
};

for k, cls in pairs(dummify) do
   scripted_ents.Register({Type="point", IsWeaponDummy=true}, cls, false)
end


local SpawnableSWEPs = nil
local SpawnableSWEPsRand = nil
function ents.MORBUS.GetSpawnableSWEPs(random)

   if !random then
      if not SpawnableSWEPs then
         local tbl = {}
         for k,v in pairs(weapons.GetList()) do
            if v and v.AutoSpawnable and v.Primary.RPM and (not WEPS.IsEquipment(v)) then
               table.insert(tbl, v)
            end
         end

         SpawnableSWEPs = tbl
      end

      return SpawnableSWEPs

   else

      if not SpawnableSWEPsRand then
         local tbl = {}
         for k,v in pairs(weapons.GetList()) do
            if v and v.AutoSpawnable and v.Primary.RPM and (not WEPS.IsEquipment(v)) and !v.NeverRandom then
               table.insert(tbl, v)
            end
         end

         SpawnableSWEPsRand = tbl
      end

      return SpawnableSWEPsRand

   end
end


local SpawnableAmmoClasses = nil
local SpawnableAmmoClassesRand = nil
function ents.MORBUS.GetSpawnableAmmo(random)

   if !random then
      if not SpawnableAmmoClasses then
         local tbl = {}
         for k,v in pairs(scripted_ents.GetList()) do
            if v and (v.AutoSpawnable or (v.t and v.t.AutoSpawnable)) then
               table.insert(tbl, k)
            end
         end

         SpawnableAmmoClasses = tbl
      end

      return SpawnableAmmoClasses
   else
      if not SpawnableAmmoClassesRand then
         local tbl = {}
         for k,v in pairs(scripted_ents.GetList()) do
            if v and (v.AutoSpawnable or (v.t and v.t.AutoSpawnable)) then
               if (v.t.NeverRandom == false) then
                  table.insert(tbl, k)
               end
            end
         end

         SpawnableAmmoClassesRand = tbl
      end

      return SpawnableAmmoClassesRand


   end
end


local function PlaceWeapon(swep, pos, ang)
   local cls = swep and swep.Classname
   if not cls then return end

   -- Create the weapon, somewhat in the air in case the spot hugs the ground.
   local ent = ents.Create(cls)
   pos.z = pos.z + 3
   ent:SetPos(pos)
   ent:SetAngles(VectorRand():Angle())
   ent:Spawn()

   -- Create some associated ammo (if any)
   if ent.AmmoEnt then
      for i=1, math.random(0,3) do
         local ammo = ents.Create(ent.AmmoEnt)
         
         if IsValid(ammo) then
            pos.z = pos.z + 2
            ammo:SetPos(pos)
            ammo:SetAngles(VectorRand():Angle())
            ammo:Spawn()
            ammo:PhysWake()
         end
      end
   end

   return ent
end

local function PlaceWeaponsAtEnts(spots_classes)
   local spots = {}
   for _, s in pairs(spots_classes) do
      for _, e in pairs(ents.FindByClass(s)) do
         table.insert(spots, e)
      end
   end

   local spawnables = ents.MORBUS.GetSpawnableSWEPs()

   local max = math.max(server_settings.Int("maxplayers", 16), #player.GetAll())
   max = max + math.max(3, 0.33 * max)

   local num = 0
   local w = nil
   for k, v in RandomPairs(spots) do
      w = table.Random(spawnables)
      if w and IsValid(v) and util.IsInWorld(v:GetPos()) then
         local spawned = PlaceWeapon(w, v:GetPos(), v:GetAngles())

         num = num + 1

         -- People with only a grenade are sad pandas. To get IsGrenade here,
         -- we need the spawned ent that has inherited the goods from the
         -- basegrenade swep.
         if spawned and spawned.IsGrenade then
            w = table.Random(spawnables)
            if w then
               PlaceWeapon(w, v:GetPos(), v:GetAngles())
            end
         end
      end

      if num > max then
         return
      end
   end
end



local function RemoveReplaceables()
   -- This could be transformed into lots of FindByClass searches, one for every
   -- key in the replace tables. Hopefully this is faster as more of the work is
   -- done on the C side. Hard to measure.
   for _, ent in pairs(ents.FindByClass("item_*")) do
      if hl2_ammo_replace[ent:GetClass()] then
         ent:Remove()
      end
   end

   for _, ent in pairs(ents.FindByClass("weapon_*")) do
      if hl2_weapon_replace[ent:GetClass()] then
         ent:Remove()
      end
   end
end

local function RemoveWeaponEntities()
   RemoveReplaceables()

   for _, cls in pairs(ents.MORBUS.GetSpawnableAmmo()) do
      for k, ent in pairs(ents.FindByClass(cls)) do
         ent:Remove()
      end
   end

   for _, sw in pairs(ents.MORBUS.GetSpawnableSWEPs()) do

      for k, ent in pairs(ents.FindByClass(sw.ClassName)) do
         ent:Remove()
      end
   end
   ents.MORBUS.RemoveRagdolls(false)
   RemoveCrowbars()
end

local function RemoveSpawnEntities()
   for k, ent in pairs(GetSpawnEnts(false, true)) do
      ent.BeingRemoved = true -- they're not gone til next tick
      ent:Remove()
   end
end

local function CreateImportedEnt(cls, pos, ang, kv)
   if not cls or not pos or not ang or not kv then return false end

   local ent = ents.Create(cls)
   ent:SetPos(pos)
   ent:SetAngles(ang)

   for k,v in pairs(kv) do
      ent:SetKeyValue(k, v)
   end

   ent:Spawn()

   ent:PhysWake()

   return true
end

function ents.MORBUS.CanImportEntities(map)
   if not tostring(map) then return false end

   local fname = "maps/" .. map .. "_morbus.txt"

   return file.Exists(fname,"GAME")
end

local function ImportSettings(map)
   if not ents.MORBUS.CanImportEntities(map) then return end

   local fname = "maps/" .. map .. "_morbus.txt"
   local buf = file.Read(fname,"GAME")

   local settings = {}

   local lines = string.Explode("\n", buf)
   for k, line in pairs(lines) do
      if string.match(line, "^setting") then
         local key, val = string.match(line, "^setting:\t(%w*) ([0-9]*)$")
         val = tonumber(val)

         if key and val then 
            settings[key] = val
         else
            ErrorNoHalt("Invalid line " .. k .. " in " .. fname .. "\n")
         end
      end
   end

   return settings
end

local classremap = {
   player_start = "info_player_deathmatch",
   info_alien_spawn = "info_alien_spawn",
   weapon_mor_p90 = "weapon_mor_ump",
   weapon_medkit = "weapon_mor_medkit"
}

local function ImportEntities(map)
   if not ents.MORBUS.CanImportEntities(map) then return end

   local fname = "maps/" .. map .. "_morbus.txt"

   local buf = file.Read(fname,"GAME")
   local lines = string.Explode("\n", buf)
   local num = 0
   for k, line in ipairs(lines) do
      if (not string.match(line, "^#")) and (not string.match(line, "^setting")) and line != "" then
         local data = string.Explode("\t", line)

         local fail = true -- pessimism

         if data[2] and data[3] then 
            local cls = data[1]
            local ang = nil
            local pos = nil
            
            local posraw = string.Explode(" ", data[2])
            pos = Vector(tonumber(posraw[1]), tonumber(posraw[2]), tonumber(posraw[3]))

            local angraw = string.Explode(" ", data[3])
            ang = Angle(tonumber(angraw[1]), tonumber(angraw[2]), tonumber(angraw[3]))

            -- Random weapons have a useful keyval
            local kv = {}
            if data[4] then
               local kvraw = string.Explode(" ", data[4])
               local key = kvraw[1]
               local val = tonumber(kvraw[2])

               if key and val then
                  kv[key] = val
               end               
            end

            -- Some dummy ents remap to different, real entity names
            cls = classremap[cls] or cls

            --if (string.sub(cls, 4) == "need" && FIRST_SPAWN) || string.sub(cls, 4) != "need" then
               fail = not CreateImportedEnt(cls, pos, ang, kv)
            --end
         end

         if fail then
            ErrorNoHalt("Invalid line " .. k .. " in " .. fname .. "\n")
         else
            num = num + 1
         end
      end
   end
   
   MsgN("Spawned " .. num .. " entities found in script.")

   return true
end


function ents.MORBUS.ProcessImportScript(map)
   MsgN("Weapon/ammo placement script found, attempting import...")

   MsgN("Reading settings from script...")
   local settings = ImportSettings(map)

   if tobool(settings.replacespawns) then
      MsgN("Removing existing player spawns")
      RemoveSpawnEntities()
   end

   MsgN("Removing existing weapons/ammo")
   RemoveWeaponEntities()

   MsgN("Importing entities...")

   local result = ImportEntities(map)
   if result then
      MsgN("Weapon placement script import successful!")
      --FIRST_SPAWN = false
   else
      ErrorNoHalt("Weapon placement script import failed!\n")
   end

end