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

function GM:PlayerInitialSpawn(ply)
  ply:FullReset()
  ply:SpawnSetup()

  RoundEngine:SendState(ply)
  GameData:Send(ply)
  TeamState:SendStateToPlayer(ply)
  Settings:SendToPlayer(ply)
end

function GM:PlayerSpawn(ply)
  ply:ResetBroodStats()
  ply:ResetNeed()

  self:PlayerSetModel(ply)
end

function GM:PlayerSetModel(ply)
  local mdl = ply.WantedModel
  if ply:IsSwarm() then
    mdl = Morbus.Models[eRoleSwarm]
  end

  ply:SetModel(mdl)
end

function GM:CanPlayerSuicide(ply)
  return true
end

function GM:PlayerUse(ply, ent)
   return not ply:IsSpec()
end

function GM:ShowHelp(ply)

end

function GM:ShowTeam(ply)

end

function GM:ShowSpare1(ply)

end

function GM:GetFallDamage(ply, speed)
   return 1
end

function GM:OnPlayerHitGround(ply, in_water, on_floater, speed)

end