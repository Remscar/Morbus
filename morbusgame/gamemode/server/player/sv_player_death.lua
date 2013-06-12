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



local function CreateDeathEffect(ent)
   local pos = ent:GetPos() + Vector(0, 0, 20)

   local jit = 35.0

   local jitter = Vector(math.Rand(-jit, jit), math.Rand(-jit, jit), 0)
   util.PaintDown(pos + jitter, "Blood", ent)

end

local function CreateCorpse(ply, attacker, dmginfo)
   if not IsValid(ply) then return end

   local rag = ents.Create("prop_ragdoll")
   if not IsValid(rag) then return nil end
   rag.ragdoll = true
   ply.Body = rag

   rag:SetPos(ply:GetPos())
   rag:SetModel(ply:GetModel())
   rag:SetAngles(ply:GetAngles())
   rag:SetNWBool("HumanBody",!ply:GetSwarm())
   rag:SetNWString("Name",ply:GetFName())
   rag:SetNWEntity("Player",ply)

   rag:Spawn()
   rag:Activate()

   -- nonsolid to players, but can be picked up and shot
   rag:SetCollisionGroup(COLLISION_GROUP_WEAPON)


end


function GM:PlayerDeathThink(ply)

   if GetRoundState() == ROUND_WAIT && ply:IsGame() then
      ply:Spectate(OBS_MODE_NONE)
      if (CurTime()>=ply.NextSpawnTime) then
         ply:SetRole(ROLE_HUMAN)
         ply:SpectateEntity(nil)
         ply:UnSpectate()
         ply:Spawn()
      end
      //return true
   end


   if ply:IsBrood() && ply:IsGame() then
      if (CurTime()>=ply.NextSpawnTime) then
          ply:Spawn()
      end
      return true
   end

   if ply:IsSwarm() && ply:IsGame() then
      ply:Spectate(OBS_MODE_NONE)
      if (CurTime()>=ply.NextSpawnTime) then
          ply:Spawn()
          ply:UnSpectate()
      end
      return true
   end
   -- when spectating a ragdoll after death
   if ply:GetMoveType() < MOVETYPE_NOCLIP and ply:GetMoveType() > 0 or ply:GetMoveType() == MOVETYPE_LADDER then
      ply:Spectate(OBS_MODE_ROAMING)
   end

   -- when speccing a player
   if ply:GetObserverMode() != OBS_MODE_ROAMING then
      local tgt = ply:GetObserverTarget()
      if IsValid(tgt) and tgt:IsPlayer() then
         if (not tgt:IsGame()) or (not tgt:Alive()) then
            -- stop speccing as soon as target dies
            ply:Spectate(OBS_MODE_ROAMING)
            ply:SpectateEntity(nil)
         elseif GetRoundState() == ROUND_ACTIVE then
            -- Sync position to target. Uglier than parenting, but unlike
            -- parenting this is less sensitive to breakage: if we are
            -- no longer spectating, we will never sync to their position.
            ply:SetPos(tgt:GetPos())
         end
      end
   end
end

function GM:PlayerDeathSound() return true end //When you return true it overrides, yes i know

function GM:DoPlayerDeath(ply, attacker, dmginfo)

  LIGHT.TurnOff(ply)
  ply:ResetViewRoll()

  ply.Killer = ents.Create("info_player_start")
  if ValidEntity(ply.Killer) then
    ply.Killer:SetPos(ply:GetPos())
    ply.Killer:Spawn()
  end

  if GetRoundState() == ROUNT_ACTIVE then
    if ply.FreeKill < CurTime() then
      if attacker:GetHuman() && ply:GetHuman() then
        attacker.FreeKill = CurTime() + 5
      end
      SANITY.Killed(attacker, ply, dmginfo)
    end
  end

  for k, wep in pairs(ply:GetWeapons()) do
    WEPS.DropNotifiedWeapon(ply, wep, true) -- with ammo in them
    wep:DampenDrop()
  end

  ply:LightReset()
  ply:DeathSound()

  if ply:IsBrood() then
    ply:SetModel(Models.Brood)
  end

  if (!ply:IsSpec()) then
    local rag = CreateCorpse(ply, attacker, dmginfo)
    ply.ragdoll = rag
    CreateDeathEffect(ply)
  end

end

function GM:PlayerDeath(victim, weapon, killer)

  if killer:GetClass() == "env_explosion" then
    killer = killer:GetOwner()
  end


  if (victim:IsSpec()) then
    return
  end

  if killer:IsPlayer() && killer!=victim && victim:IsAlien() && !killer:GetNWBool("alienform",false) then
    killer:KilledAlien()
  end



  // Don't bother with this shit if we aren't playing
  if (GetRoundState() != ROUND_ACTIVE) then victim.NextSpawnTime = CurTime() + 5 return end


  // Infection timer
  if !victim:IsAlien() && victim.BroodInfect then
    if victim.BroodInfect > CurTime() && victim.BroodHit then
      LogInfect(victim.BroodHit,victim,"Brood")
      Death_Brood_Infect(victim,weapon,victim.BroodHit)
      return
    end
  end



  if not killer:IsPlayer() then

    // The played died from UNKNOWN causes (Falling, crushed by map)

    LogDeath(victim,"Unknown")
    Death_Unknown(victim,weapon,killer)

  elseif killer:GetActiveWeapon() == NULL or weapon == victim then

    // The player killed themselves

    LogDeath(victim,"Suicide")
    Death_Suicide(victim,weapon,killer)

  elseif killer:GetActiveWeapon():GetClass() == "weapon_mor_swarm" && !victim:IsAlien() then

    // The player is infected by a Swarm Alien

    LogInfect(killer,victim,"Swarm")
    Round_Swarm_Infects = Round_Swarm_Infects + 1
    Death_Swarm_infect(victim,weapon,killer)

  elseif victim:IsBrood() then

    // The player was a Brood Alien & died

    LogKill(victim,killer,"Brood Killed")
    Round_Brood_Kills = Round_Brood_Kills + 1
    Death_Brood(victim,weapon,killer)

  elseif victim:IsSwarm() then

    // The player was a Swarm Alien & died

    LogKill(victim,killer,"Swarm Killed")
    Round_Swarm_Kills = Round_Kills + 1
    Death_Swarm(victim,weapon,killer)

  elseif killer:GetActiveWeapon():GetClass() ==  "weapon_mor_brood" && !victim:IsAlien() then

    // The player was infected by a Brood Alien

    LogInfect(killer,victim,"Brood")
    Round_Brood_Infects = Round_Brood_Infects + 1
    Death_Brood_Infect(victim,weapon,killer)

  else -- If the player did not suide, was not killed with brood/spawn weapon, if the player was not a brood or spawn

    if (victim:IsAlien() == killer:IsAlien()) then

      // The player was killed by their team member

      LogRDM(killer,victim,"RDM")
      Round_RDMs = Round_RDMs + 1

    else

      // The player is an alien and shot by a human, or vice versa

      LogKill(victim,killer,"KILL")

    end

    // Normal death

    Death_Normal(victim,weapon,killer)

  end



end



function Death_Normal(ply,weapon,killer)

   if ply:IsSwarm() then --They are a swarm, we don't care
      Death_Swarm(ply,weapon,killer)
      return
   end

   --They were shot to death by a Brood or a Human, make them a Swarm Alien now
   NewAlien(ply,ROLE_SWARM)

end


function Death_Unknown(ply,wpn,klr)
  Death_Normal(ply,wpn,klr) --Nothing special here
end


function Death_Suicide(ply,wpn,klr)
  Death_Normal(ply,wpn,klr) -- Nothing special here
end


function Death_Brood(ply,weapon,killer)

   Death_Normal(ply,weapon,killer) -- Turn them into a swarm

   if ply != killer then -- No suicides
      if !RoundHistory["Kill"][killer] then -- Round Achievment
         RoundHistory["Kill"][killer] = 0
      end

      RoundHistory["Kill"][killer] = RoundHistory["Kill"][killer] + 1 -- Add a kill
   end
end


function Death_Swarm(ply,weapon,killer)

   if (Swarm_Respawns > 0) then -- If we have respawns

      Swarm_Respawns = Swarm_Respawns - 1 -- Take one away
      SetGlobalInt("morbus_swarm_spawns", Swarm_Respawns) -- Update the global
      ply.NextSpawnTime = CurTime() + 8 -- Respawn us in 8 seconds

   else

      ply:MakeSpec() -- No respawns, become a spectator

   end

   if ply != killer then -- No suicides
      if !RoundHistory["Kill"][killer] then -- Round Achievment
         RoundHistory["Kill"][killer] = 0
      end

      RoundHistory["Kill"][killer] = RoundHistory["Kill"][killer] + 1 -- Add a point
   end
end


function Death_Swarm_Infect(ply,weapon,killer)

   if !RoundHistory["Infect"][killer] then  --This is for the achievment
      RoundHistory["Infect"][killer] = 0
   end
   RoundHistory["Infect"][killer] = RoundHistory["Infect"][killer] + 1 --Add a point

   BroodInfected(ply) -- Brood Creation

   ply.NextSpawnTime = CurTime() + 4 -- Force the Brood Alien to ressurect in 4 seconds

end

function Death_Brood_Infect(ply,weapon,killer)
   Death_Swarm_Infect(ply,weapon,killer) -- Same thing as a swarm alien
end








