--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

-- Still heavily based on TTT 

local Settings = Morbus.Settings

local Comms = MorbusTable("Comms")
local Arming = MorbusTable("Arming")


local classremap = {
   player_start = "info_player_deathmatch",
   info_alien_spawn = "info_alien_spawn",
}

local weaponvariations = {
   weapon_test = {"weapon_one","weapon_two","weapon_three"},
   weapon_glowstick = {"weapon_glowstick","weapon_glowstick_sticky", "weapon_glowstick_grav"},
   weapon_mor_zx9 = {"weapon_mor_zx9", "weapon_mor_bulldog"}
}



function Arming:Cleanup()
  self.NeedLocations = {}

  for id, ent in pairs(ents.FindByClass("prop_ragdoll")) do
    if not IsValid(ent) then continue end

    ent:SetNoDraw(true)
    ent:SetSolid(SOLID_NONE)
    ent:SetColor(Color(0, 0, 0, 0))

    ent:SetNWEntity("Morbus_Player", nil)
    ent:SetNWString("Morbus_Name", "")

    ent.NoTarget = true
  end

  self:_PreMapCleanup()
  game.CleanUpMap()
  self:_PostMapCleanup()
  
  for k,v in pairs(player.GetAll()) do
    if IsValid(v) then v:StripWeapons() end
  end

end

local brokenParentEnts = {
   "move_rope",
   "keyframe_rope",
   "info_target",
   "func_brush"
}

function Arming:_PreMapCleanup()
  for _, rcls in pairs(brokenParentEnts) do
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

function Arming:_PostMapCleanup()
   for _, rcls in pairs(brokenParentEnts) do
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

function Arming:RemoveRagdolls()
  for k, v in pairs(ents.FindByClass("prop_ragdoll")) do
    if IsValid(v) then v:Remove() end
  end
end

function Arming:SpawnPlayers(dead)
  for k,v in pairs(player.GetAll()) do
    if IsValid(v) then v:SpawnForRound(dead) end
  end
end

function Arming:CanImport(map)
  return not (self:GetArmingFile(map) == false)
end

function Arming:GetArmingFile(map)
  if not tostring(map) then return false end
  local fname = "maps/" .. map .. "_morbus2.txt"
  local armFile = file.Read(fname,"GAME")

  return armFile
end

function Arming:ImportSettings(map)
  local armBuffer = self:GetArmingFile(map)

  local fname = "maps/" .. map .. "_morbus.txt"

  local settings = {}

  local lines = string.Explode("\n", armBuffer)
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

function Arming:RemoveSpawnLocations()
   for k, ent in pairs(Morbus:GetSpawnEnts(false, true)) do
      ent.BeingRemoved = true
      ent:Remove()
   end
end

function Arming:RemoveWeaponEntities()
  for i, cls in pairs(Morbus:AmmoList()) do
    for k, v in pairs(ents.FindByClass(cls)) do
      v:Remove()
    end
  end

  for _, cls in pairs(Morbus:WeaponList()) do
    for k, v in pairs(ents.FindByClass(cls.ClassName)) do
      v:Remove()
    end
  end
end

function Arming:ArmMap()
  local map = game.GetMap()
  local canImport = self:CanImport(map)

  if not canImport then
    Comms:Msg("Cannot arm the map! See morbus.remscar.com/arming.html for help.")
    return
  end

  local settings = self:ImportSettings(map)

  if tobool(settings.replacespawns) then
    self:RemoveSpawnLocations()
  end

  self:RemoveWeaponEntities()

  if not self:ImportEntities(map) then
    print("Failed to import weapon script!")
  end
end

local function WeaponVariation(cls)
   local variations = weaponvariations[cls]
   local r = math.random(1,#variations)
   return variations[r]
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

function Arming:ImportEntities(map)
  local fname = "maps/" .. map .. "_morbus2.txt"
  local armBuffer = self:GetArmingFile(map)

  local lines = string.Explode("\n", armBuffer)
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

      --print("try spawn"..cls)

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


local removeEnts = {
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
}

for k, cls in pairs(removeEnts) do
   scripted_ents.Register({Type="point", IsWeaponDummy=true}, cls, false)
end