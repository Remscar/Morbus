/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local Settings = MorbusTable("Settings")
local RoundEngine = MorbusTable("RoundEngine")
local GameData = MorbusTable("GameData")
local TeamState = MorbusTable("TeamState")
--local Mutators = MorbusTable("Mutators")
local Players = MorbusTable("Players")
local Aliens = MorbusTable("Aliens")
local Comms = MorbusTable("Comms")
local Arming = MorbusTable("Arming")

local ActiveState = RoundEngine:GetStateTable(eRoundActive)

if not SERVER then return end

function ActiveState:OnEnter(lastState)

  -- Global State Data
  GameData.State.RoundEnd = CurTime() + Settings.Game.RoundTime
  GameData:Send()

  -- Team State Data
  Aliens:ResetTeamState()

  -- Setup Round History Stuff
  --Logging:Reset()

  -- Spawn Players
  Arming:SpawnPlayers(true)

  -- Select Roles
  Players:SelectRoles()

  -- Remove Ragdolls
  Arming:RemoveRagdolls()

  -- Default Alien Info
  TeamState[eTeamAlien].SwarmLives = Settings.Team[eTeamAlien].InitialSwarmLives

  -- Mutators
  --Mutators:Check()
  --Mutators:Start()

  -- Data Collection Reset
  --DataTracking:Reset()

  -- Update Load outs
  --Morbus.Players:UpdateLoadouts()

  Comms:GameMsg("Round will end in " .. math.floor(Settings.Game.RoundTime / 60) .. " minutes.")

  timer.Start("Morbus_WinCheck", 1, 0, function() self:WinCheck() end)
end

function Morbus:CheckForWinner()
  local broodAlive = false
  local humanAlive = false

  for k,v in pairs(player.GetAll()) do
    if not IsValid(v) or not v:Alive() then continue end
    if v:IsBrood() then broodAlive = true end
    if v:IsHuman() then humanAlive = true end

    if humanAlive and broodAlive then return eWinNone end
  end

  if broodAlive and not humanAlive then return eWinAlien end
  if not broodAlive then return eWinHuman end
end

function ActiveState:WinCheck()
  local winType = Morbus:CheckForWinner()

  if winType ~= eWinNone then
    RoundEngine:DeclareWinner(winType)
    return
  end
end

function ActiveState:Think()
  local now = CurTime()

  if now > GameData.State.RoundEnd then
    -- if evac map then goto evac mode
    -- otherwise, humans win by default
    RoundEngine:DeclareWinner(eWinHuman)
  end
end

function ActiveState:OnExit(newState)
  timer.Stop("Morbus_WinCheck")
end
