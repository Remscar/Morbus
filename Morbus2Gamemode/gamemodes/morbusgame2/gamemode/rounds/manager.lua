--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

if not Morbus.RoundEngine then
  Morbus.RoundEngine = {}
end

local RoundEngine = Morbus.RoundEngine

function RoundEngine:RoundState()
  return self.CurrentState or eRoundWait
end

function RoundEngine:ChangeState(newState)
  local oldState = self.CurrentState

  if not newState then
    print("invalid state?   newState = " .. tostring(newState))
    return
  end

  local oldTable = self:GetStateTable(oldState)
  local newTable = self:GetStateTable(newState)

  -- Exit out of our old state if we have one
  if oldState and oldTable.OnExit then
      oldTable:OnExit(newState)
  end

  self.CurrentState = newState

  print("Changing state to " .. EnumRound[newState])

  if newTable.OnEnter then
    newTable:OnEnter(oldState)
  end

  if SERVER then
    self:SendState()
  end
end

if SERVER then
  util.AddNetworkString("MorbusRoundState")

  function RoundEngine:SendState(plyList)
    net.Start("MorbusRoundState")
    net.WriteInt(self.CurrentState, 8)

    if not plyList then
      net.Broadcast()
    else
      net.Send(plyList)
    end
  end

else
  function RoundEngine:GetState(len)
    local newState = net.ReadInt(8)
    if newState ~= self.CurrentState then
      self:ChangeState(newState)
    end
  end
  net.Receive("MorbusRoundState", function(len) RoundEngine:GetState(len) end)
end

function RoundEngine:Think()
  local curState = self.CurrentState
  if not curState then return end

  if not Morbus.RoundStates[curState].Think then return end

  local nextState = Morbus.RoundStates[curState]:Think()

  if nextState ~= nil then
    self:ChangeState(nextState)
  end
end

function RoundEngine:DeclareWinner(winner)
  Morbus.GameData.State.RoundWinner = winner
  Morbus.GameData:Updated()

  Morbus.Comms:GameMsg(EnumWin[winner] .. "s win!")

  self:ChangeState(eRoundPost)
end
