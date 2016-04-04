/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

/*
Round State data is intended to be sent whenever the round
changes (prep->active->post ect)

*/

if not Morbus.RoundState then
  Morbus.RoundState = {}
  Morbus.RoundState.State = {}
  Morbus.RoundState._first = true
end

local RoundState = Morbus.RoundState

function RoundState:Default()
  self.State.RoundEnd = -1
  self.State.RoundsLeft = Morbus.Settings.Game.NumberRounds
  self.State.RoundWinner = 0
  self.State.RoundNumber = 0

  self.State.AlienWins = 0
  self.State.HumanWins = 0

  self.State.PlayerNames = {} -- Send player rp names this way?
end


if RoundState._first then
  RoundState:Default()
  RoundState._first = false
end

if SERVER then
  util.AddNetworkString("MorbusRoundState")
  --util.AddNetworkString("MorbusStateBatch")

  function RoundState:_SendState()
    net.WriteTable(self.State)
  end

  function RoundState:SendStateToPlayer(ply)
    net.Start("MorbusRoundState")
    self:_SendState()
    net.Send(ply)
  end

  function RoundState:SendStateToAll()
    net.Start("MorbusRoundState")
    self:_SendState()
    net.Broadcast()
  end

else

  function RoundState:_GetStateAll(msgLen)
    self.State = net.ReadTable()
  end
  net.Receive("MorbusRoundState", function(len) RoundState:_GetStateAll(len) end)

end