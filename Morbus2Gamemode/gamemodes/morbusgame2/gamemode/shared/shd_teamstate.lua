/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

if not Morbus.TeamState then
  Morbus.TeamState = {}
  Morbus.TeamState[eTeamHuman] = {}
  Morbus.TeamState[eTeamAlien] = {}
  Morbus.TeamState._first = true
end

local TeamState = Morbus.TeamState

function TeamState:Default()
  self[eTeamAlien].SwarmLives = Morbus.Settings.Team[eTeamAlien].InitialSwarmLives
end


if TeamState._first then
  TeamState:Default()
  TeamState._first = false
end

if SERVER then
  util.AddNetworkString("MorbusTeamState")

  function TeamState:_SendState(teamEnum)
    net.WriteInt(teamEnum)
    net.WriteTable(self[teamEnum])
  end

  function TeamState:SendStateToPlayer(ply)
    net.Start("MorbusTeamState")
    self:_SendState(ply:MorbusTeam()) -- Will crash till implemented
    net.Send(ply)
  end

else

  function TeamState:_GetStateAll(msgLen)
    local teamEnum = net.ReadInt()
    self[teamEnum] = net.ReadTable()
  end
  net.Receive("MorbusTeamState", function(len) TeamState:_GetStateAll(len) end)

end