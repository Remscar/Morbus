--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

local RoundEngine = Morbus.RoundEngine

local Comms = Morbus.Comms
local Arming = Morbus.Arming

local GameData = Morbus.GameData
--local TeamData = Morbus.TeamState

local Settings = Morbus.Settings

--local Mutators = Morbus.Mutators

local PrepState = RoundEngine:GetStateTable(eRoundPrep)


if not SERVER then return end

function PrepState:OnEnter(lastState)

  Comms:GlobalMute(true)
  Arming:Cleanup()

  local prepTime = Settings.Game.PrepTime
  if not Morbus.NotFirstRound then
    prepTime = prepTime * 2
    Morbus.NotFirstRound = true
  end

  -- Setup GameData and send to clients
  GameData.State.RoundEnd = CurTime() + prepTime
  GameData.State.RoundWinner = eWinNone
  GameData:Updated()

  --Mutators:Check()
  --Mutators:Prep()

  Comms:GameMsg("Round will start in " .. prepTime .. " seconds.")

  -- Jank way of delaying this until the next frame
  timer.Simple(0.01,
    function()
      Arming:ArmMap()
      Arming:SpawnPlayers()
      Comms:GlobalMute(false)
    end)

  --Players:ClearClient()
end

function PrepState:Think()
  local now = CurTime()
  if now <= GameData.State.RoundEnd then
    return eRoundActive
  end

end

function PrepState:OnExit(nextState)

end
