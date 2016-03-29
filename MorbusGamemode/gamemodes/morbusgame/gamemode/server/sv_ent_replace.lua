// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
/*--------------------------------------------
MORBUS ENTITY REPLACEMENT
Credits to TTT for this script
--------------------------------------------*/

ents.MORBUS = {}
ents.MORBUS.useWebArmFirst = false

webArmFile = ""; -- Blankness
local rNum = tostring(math.random(1,1000000))
local webArmURL = "http://www.remscar.com/morbus/hotfix/arming/" .. game.GetMap() .. "_morbus.txt?cacheBuster="..rNum

timer.Simple(1,function() http.Fetch( webArmURL,
  function( body, len, headers, code )
    webArmFile = body
  end,
  function( error )
  end
 ) end)


function ents.MORBUS.ReplaceEntities()
   ents.MORBUS.RemoveRagdolls()
end


local cls = "" -- avoid allocating
local sub = string.sub
local function ReplaceOnCreated(s, ent)
   -- Invalid ents are of no use anyway
   if not ent:IsValid() then return end

   cls = ent:GetClass()
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
         ent:Remove()
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
   "item_ammo_revolver",
   --remove console spam
   "spawn_item",
   "spawn_pistol",
   "spawn_other_weaps",
   "info_ladder",
   "spawn_jail",
   "reprog_robot",
   "spawn_spawn"
};

for k, cls in pairs(dummify) do
   scripted_ents.Register({Type="point", IsWeaponDummy=true}, cls, false)
end


local SpawnableSWEPs = nil
local RandomSpawnableSWEPs = nil
function ents.MORBUS.GetSpawnableSWEPs(random)

   if not SpawnableSWEPs then
      local tbl = {}
      local rtbl = {}
      for k,v in pairs(weapons.GetList()) do
         if v and v.AutoSpawnable and v.Primary.RPM and (not WEPS.IsEquipment(v)) then
            table.insert(tbl, v)
            if !v.NeverRandom then
               table.insert(rtbl,v)
            end
         end
      end

      SpawnableSWEPs = tbl
      RandomSpawnableSWEPs = rtbl
   end

   if random then
      return RandomSpawnableSWEPs
   else
      return SpawnableSWEPs
   end
end


local SpawnableAmmoClasses = nil
local RandomSpawnableAmmoClasses = nil
function ents.MORBUS.GetSpawnableAmmo(random)

   if not SpawnableAmmoClasses then
      local tbl = {}
      local rtbl = {}
      for k,v in pairs(scripted_ents.GetList()) do
         if v and (v.AutoSpawnable or (v.t and v.t.AutoSpawnable)) then
            table.insert(tbl, k)
            if (v.t.NeverRandom == false) then
               table.insert(rtbl, k)
            end
         end
      end

      SpawnableAmmoClasses = tbl
      RandomSpawnableAmmoClasses = tbl
   end

   if random then
      return RandomSpawnableAmmoClasses
   else
      return SpawnableAmmoClasses
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


local function RemoveWeaponEntities()

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

function ents.MORBUS.GetArmingFile(map)
   local fname = "maps/" .. map .. "_morbus.txt"
   local armFile = file.Read(fname,"GAME")

   if ents.MORBUS.useWebArmFirst then
      armFile = webArmFile
   end
   return armFile
end

function ents.MORBUS.CanImportEntities(map)
   if not tostring(map) then return false end

   local fname = "maps/" .. map .. "_morbus.txt"
   local ret = file.Exists(fname,"GAME")

   if ret == false then
      return string.len(webArmFile) > 0
   end

   return true
end

local function ImportSettings(map)
   if not ents.MORBUS.CanImportEntities(map) then return end
   
   local buf = ents.MORBUS.GetArmingFile(map)
   local fname = "maps/" .. map .. "_morbus.txt"

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

local weaponvariations = {
   weapon_test = {"weapon_one","weapon_two","weapon_three"},
   weapon_glowstick = {"weapon_glowstick","weapon_glowstick_sticky", "weapon_glowstick_grav"},
   weapon_mor_zx9 = {"weapon_mor_zx9", "weapon_mor_bulldog"}
}

local function WeaponVariation(cls)
   local variations = weaponvariations[cls]
   local r = math.random(1,#variations)
   return variations[r]
end

local function ImportEntities(map)
   if not ents.MORBUS.CanImportEntities(map) then return end

   local fname = "maps/" .. map .. "_morbus.txt"

   local buf = ents.MORBUS.GetArmingFile(map)
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

            if weaponvariations[cls] then
               cls = WeaponVariation(cls)
            end
            fail = not CreateImportedEnt(cls, pos, ang, kv)
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
