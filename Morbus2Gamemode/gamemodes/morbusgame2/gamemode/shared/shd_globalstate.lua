/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

if not Morbus.GlobalState then
  Morbus.GlobalState = {}
  Morbus.GlobalState.State = {}
  Morbus.GlobalState._first = true
end

local GlobalState = Morbus.GlobalState

function GlobalState:Default()
  self.State.RoundEnd = -1
  self.State.RoundsLeft = Morbus.Settings.Game.NumberRounds
  self.State.RoundWinner = 0

  self.State.AlienWins = 0
  self.State.HumanWins = 0
end


if GlobalState._first then
  GlobalState:Default()
  GlobalState._first = false
end

if SERVER then
  util.AddNetworkString("MorbusStateAll")
  --util.AddNetworkString("MorbusStateBatch")

  function GlobalState:_SendStateAll()
    net.WriteTable(self.State)
  end

  function GlobalState:SendStateToPlayer(ply)
    net.Start("MorbusStateAll")
    self:_SendStateAll()
    net.Send(ply)
  end

  function GlobalState:SendStateToAll()
    net.Start("MorbusStateAll")
    self:_SendStateAll()
    net.Broadcast()
  end

else

  function GlobalState:_GetStateAll(msgLen)
    self.State = net.ReadTable()
  end
  net.Receive("MorbusStateAll", function(len) GlobalState:_GetStateAll(len) end)

end