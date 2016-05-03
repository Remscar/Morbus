/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

/*
Round State data is intended to be sent whenever the round
changes (prep->active->post ect)

*/

if not Morbus.GameData then
  Morbus.GameData = {}
end

local GameData = Morbus.GameData

function GameData:Default()
  self.State.RoundEnd = -1
  self.State.RoundsLeft = Morbus.Settings.Game.NumberRounds
  self.State.RoundWinner = eWinNone
  self.State.RoundNumber = 0

  self.State.AlienWins = 0
  self.State.HumanWins = 0

  self.State.PlayerNames = {} -- Send player rp names this way?
end

function GameData:Updated()
  self.ShouldSend = true
end


if not GameData._first then
  Morbus.GameData.State = {}
  Morbus.GameData.ShouldSend = false
  GameData:Default()
  GameData._first = true
end

if SERVER then
  util.AddNetworkString("MorbusGameData")

  function GameData:_SendState()
    net.WriteTable(self.State)
  end

  function GameData:Send(ply)
    net.Start("MorbusGameData")
    self:_SendState()

    if not ply then
      net.Broadcast()
    else
      net.Send(ply)
    end

    self.ShouldSend = false
  end

  function GameData:SendIfReady()
    if not self.ShouldSend then return end

    self:Send()
  end

else

  function GameData:_GetStateAll(msgLen)
    self.State = net.ReadTable()
  end
  net.Receive("MorbusGameData", function(len) GameData:_GetStateAll(len) end)

end