--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

local Settings = MorbusTable("Settings")
local RoundEngine = MorbusTable("RoundEngine")
local GameData = MorbusTable("GameData")
local TeamState = MorbusTable("TeamState")
local Corpses = MorbusTable("Corpses")
local Players = MorbusTable("Players")
local Aliens = MorbusTable("Aliens")

-- Return true if player can spawn
function GM:PlayerDeathThink(ply)

  if ply:IsGame() then

    if RoundEngine:RoundState() == eRoundWait then
      if ply.NextSpawnTime <= CurTime() then
        ply:SetRole(eRoleHuman)
        ply:SendRole()
        ply:SpectateEntity(nil)
        ply:UnSpectate()
        ply:Spawn()
      end

      return true
    end

    if ply:IsBrood() or ply:IsSwarm() then
      if ply.NextSpawnTime <= CurTime() then
        ply:Spawn()
        ply:UnSpectate()
      end

      return true
    end
  end

  if ply:GetMoveType() < MOVETYPE_NOCLIP and ply:GetMoveType() > 0 or ply:GetMoveType() == MOVETYPE_LADDER then
    ply:Spectate(OBS_MODE_ROAMING)
  end

  if ply:GetObserverMode() != OBS_MODE_ROAMING then
    local tgt = ply:GetObserverTarget()
    if IsValid(tgt) and tgt:IsPlayer() then
      if (not tgt:IsGame()) or (not tgt:Alive()) then
        -- stop speccing as soon as target diesd
        ply:Spectate(OBS_MODE_ROAMING)
        ply:SpectateEntity(nil)
      else
        ply:SetPos(tgt:GetPos())
      end
    end
  end


  return true
end

-- Returns whether default death sound should play
function GM:PlayerDeathSound(ply)
  return true
end

-- Handles player death
-- Player::Alive will still return true, but after this they are no longer alive
function GM:DoPlayerDeath(victim, killer, dmginfo)
  -- Turn off Light

  -- Create Kill Point spawn point
  ply.DeathSpawnPoint = ents.Create("info_player_start")
  if IsValid(ply.DeathSpawnPoint) then
    ply.DeathSpawnPoint:SetPos(ply:GetPos())
    ply.DeathSpawnPoint:Spawn()
  end

  -- Drop all weapons and Ammo
  for k, wep in pairs(ply:GetWeapons()) do
    ply:DropWeapon(wep)
    wep:DampenDrop()
  end

  if ply:IsBrood() then
    ply:SetModel(Morbus.Models[eRoleBrood])
  end

  if not ply:IsSpec() then
    local rag = Corpses:Create(ply)
    ply.Ragdoll = rag
    ply:DeathEffect()
    ply:DeathSound()
  end
end

-- Called when a player is killed (unless from KillSilent)
-- PostPlayerDeath is for when the player is 100% dead (?)
-- Inflictor and Killer are entities, not neccesarily players
function GM:PlayerDeath(victim, inflictor, killer)

  if killer.GetOwner then
    local killOwner = killer:GetOwner()
    if killOwner and killOwner.IsPlayer and killOwner:IsPlayer() then
      killer = killOwner
    end
  end

  if victim:IsSpec() then return end

  -- Player died and was infected
  if victim:IsHuman() and victim.InfectTime then
    if victim.InfectTime > CurTime() and victim.Infector then
      killer = victim.Infector
      Players:DeathInfected(victim, inflictor, killer)
      return
    end
  end

  if not killer:IsPlayer() then
    -- Player died from an unknown cause
    Players:DeathUnknown(victim, inflictor, killer)
    return
  end

  if victim == inflictor or victim == killer then
    -- player killed themselves
    Players:DeathSuicide(victim, inflictor, killer)
    return
  end

  if killer:GetActiveWeapon().AlienWeapon and victim:IsHuman() then
    Players:DeathInfected(victim, inflictor, killer)
    return
  end

  if victim:IsBrood() then
    Players:DeathBrood(victim, inflictor, killer)
    return
  end

  if victim:IsSwarm() then
    Players:DeathSwarm(victim, inflictor, killer)
    return
  end

  Players:DeathHumanoid(victim, inflictor, killer)
end

function Players:DeathHumanoid(victim, inflictor, killer)
  if victim:IsSwarm() then
    self:DeathSwarm(victim, inflictor, killer)
    return
  end

  if victim:IsBrood() and killer:IsBrood() and victim ~= killer then
    -- Punish Brood player for killing another brood
  end

  local now = CurTime()
  if victim:IsHuman() and killer:IsHuman() and victim ~= killer and victim.FreeKill < now then
    -- Human killed another human
  end

  -- Turn player into a swarm alien
  Aliens:MakeAlien(victim, eRoleSwarm)
end

function Players:DeathUnknown(victim, inflictor, killer)
  if victim:IsAlien() then
    self:DeathSwarm(victim, inflictor, killer)
    return
  end

  -- Turn player into a swarm alien
  Aliens:MakeAlien(victim, eRoleSwarm)
end

function Players:DeathSuicide(victim, inflictor, killer)
  self:DeathHumanoid(victim, inflictor, killer)
end

function Players:DeathBrood(victim, inflictor, killer)
  self:DeathHumanoid(victim, inflictor, killer)
end

function Players:DeathSwarm(victim, inflictor, killer)
  if not Aliens:SwarmRespawn(victim) then
    -- Not enough lives so become spectator
    victim:MakeSpec()
  end

  if killer:IsHuman() then
    -- Killed by a human
  end

  if victim ~= killer then

  end
end

function Players:DeathInfected(victim, inflictor, killer)
  Aliens:HumanInfected(victim)
end