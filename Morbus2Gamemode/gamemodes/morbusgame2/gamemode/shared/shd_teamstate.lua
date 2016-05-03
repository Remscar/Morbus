/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local Settings = Morbus.Settings

if not Morbus.TeamState then
  Morbus.TeamState = {}
end

local TeamState = Morbus.TeamState

function TeamState:Default()
  self[eTeamAlien].SwarmLives = Settings.Team[eTeamAlien].InitialSwarmLives
end

function TeamState:Updated()
  self.ShouldSend = true
end


if not TeamState._first then
  Morbus.TeamState[eTeamHuman] = {}
  Morbus.TeamState[eTeamAlien] = {}
  Morbus.TeamState._first = true
  Morbus.GameData.ShouldSend = false

  TeamState:Default()
  TeamState._first = false
end

if SERVER then
  util.AddNetworkString("MorbusTeamState")

  function TeamState:_SendState(teamEnum)
    net.WriteInt(teamEnum, 8)
    net.WriteTable(self[teamEnum])
  end

  function TeamState:SendStateToPlayer(ply)
    net.Start("MorbusTeamState")
    self:_SendState(ply:MorbusTeam())
    net.Send(ply)
  end

  function TeamState:Send(ply)
    if not ply then ply = player.GetAll() end

    for k,v in pairs(ply) do
      if v:IsPlayer() then self:SendStateToPlayer(v) end
    end
  end
  
  function TeamState:SendIfReady()
    if not self.ShouldSend then return end

    self.ShouldSend = false
    self:Send()
  end

else

  function TeamState:_GetStateAll(msgLen)
    local teamEnum = net.ReadInt(8)
    self[teamEnum] = net.ReadTable()
  end
  net.Receive("MorbusTeamState", function(len) TeamState:_GetStateAll(len) end)

end