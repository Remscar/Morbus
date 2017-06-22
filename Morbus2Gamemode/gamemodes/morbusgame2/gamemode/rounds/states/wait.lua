/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local RoundEngine = Morbus.RoundEngine
local Settings = Morbus.Settings
local WaitState = RoundEngine:GetStateTable(eRoundWait)

local Comms = Morbus.Comms

function WaitState:OnEnter(lastState)
  if not SERVER then return end

  -- Wait to start until enough players are connected
  timer.Create("CheckPlayerCount", 1, 0, function()
    if #player.GetAll() >= Settings.Game.PlayerRequirement then
      RoundEngine:ChangeState(eRoundPrep)
    end
  end)

  self.LastPCount = 0
end

local notifYDelayTime = 15

function WaitState:Think()
  if not SERVER then return end

  local now = CurTime()
  local plyCount = #player.GetAll()

  -- Tell players that more are required to start playing
  if not self.NotifyTime or self.NotifyTime < now or self.LastPCount != plyCount then
    self.NotifyTime = now + notifYDelayTime

    self.LastPCount = plyCount
    plyCount = Settings.Game.PlayerRequirement - plyCount

    Comms:Msg(plyCount .. " more players are required to start the game.", nil, HUD_PRINTCENTER)
  end

end

function WaitState:OnExit(nextState)
  if not SERVER then return end

  timer.Stop("CheckPlayerCount")
end
