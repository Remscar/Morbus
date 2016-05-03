/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local Settings = MorbusTable("Settings")
local RoundEngine = MorbusTable("RoundEngine")
local GameData = MorbusTable("GameData")
local TeamState = MorbusTable("TeamState")
local Corpses = MorbusTable("Corpses")
local Players = MorbusTable("Players")
local Aliens = MorbusTable("Aliens")
local Comms = MorbusTable("Comms")

function Aliens:ResetTeamState()
  TeamState[eTeamAlien].SwarmLives = Settings.Team[eTeamAlien].InitialSwarmLives
end

function Aliens:SendAllRoles(rec)
  local alienList = Morbus.AlienList()

  for k,v in pairs(alienList) do
    v:TellRoleTo(alienList)
  end
end

function Aliens:SwarmRespawn(ply)
  if TeamState[eTeamAlien].SwarmLives > 0 then
    TeamState[eTeamAlien].SwarmLives = TeamState[eTeamAlien].SwarmLives - 1
    TeamState:Updated()
    ply.NextSpawnTime = CurTime() + Settings.Game.SwarmRespawnTime
    return true
  end
  return false
end

function Aliens:MakeAlien(ply, alienRole)
  if not IsValid(ply) then return end

  if ply:Team() == eGTeamSpectators then
    ply:SetTeam(eGTeamPlayers)
    ply:UnSpectate()
    ply:SpectateEntity(nil)
    ply:SetRole(alienRole)
    ply:SetPos(GAMEMODE:PlayerSelectSpawn(ply):GetPos())
    ply:Spawn()
  else
    Comms:AlienMsg(ply:MorbusName(true).." is now a "..EnumRole(alienRole))
  end

  if ply:GetRole() ~= alienRole then
    ply:SetRole(alienRole)
  end

  ply:SendRole()
  self:SendAllRoles()

  if role == eRoleSwarm then
    if not Aliens:SwarmRespawn(ply) then
      -- Not enough lives so become spectator
      ply:MakeSpec()
      ply.NextSpawnTime = CurTime() + 1
    end
  end
end

function Aliens:HumanInfected(ply)
  self:MakeAlien(ply, eRoleBrood)
  ply.NextSpawnTime = CurTime() + Settings.Game.BroodRespawnTime
end
