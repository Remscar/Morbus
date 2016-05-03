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

  timer.Create("CheckPlayerCount", 1, 0, function()
    if #player.GetAll() >= Settings.Game.PlayerRequirement then
      RoundEngine:ChangeState(eRoundPrep)
    end
  end)

  self.LastPCount = 0
end

function WaitState:Think()
  if not SERVER then return end

  local now = CurTime()
  local plyCount = #player.GetAll()

  if not self.NotifyTime or self.NotifyTime < now or self.LastPCount != plyCount then
    self.NotifyTime = now + 15

    self.LastPCount = plyCount
    plyCount = Settings.Game.PlayerRequirement - plyCount

    Comms:Msg(plyCount .. " more players are required to start.", nil, HUD_PRINTCENTER)
  end

end

function WaitState:OnExit(nextState)
  if not SERVER then return end

  timer.Stop("CheckPlayerCount")
end