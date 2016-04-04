/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

if not Morbus.Settings then
  Morbus.Settings = {}
  Morbus.Settings._first = true

  Morbus.Settings.Role = {}
  Morbus.Settings.Role[eRoleHuman] = {}
  Morbus.Settings.Role[eRoleBrood] = {}
  Morbus.Settings.Role[eRoleSwarm] = {}

  Morbus.Settings.Team = {}
  Morbus.Settings.Team[eTeamHuman] = {}
  Morbus.Settings.Team[eTeamAlien] = {}

  Morbus.Settings.Game = {}
end

local Settings = Morbus.Settings


function Settings:Default()
  self:DefaultRole()
  self:DefaultTeam()
  self:DefaultGame()
end

function Settings:DefaultRole()
  /* Human */
  local human = self.Role[eRoleHuman]
  human.DefaultJump = 200
  human.RunSpeed = 270
  human.SprintSpeed = 270

  human.NeedCompleteTime = 8

  human.BatteryMult = 0.3
  human.BatterySize = 35

  /* Brood */
  local brood = self.Role[eRoleBrood]
  brood.DefaultJump = 200
  brood.RunSpeed = 330
  brood.SprintSpeed = 270 

  brood.FirstPerkPoints = 5
  brood.NewPerkPoints = 1
  brood.PerkPointsPerKill = 1
  brood.TierRequirement = 3

  brood.TransformCooldown = 10

  /* Swarm */
  local swarm = self.Role[eRoleSwarm]
  swarm.DefaultJump = 200
  swarm.RunSpeed = 250
  swarm.SprintSpeed = 250

end

function Settings:DefaultTeam()
  /* Human */
  local human = self.Team[eTeamHuman]
  human.NeedEntities = {}
  human.NeedEntities[eNeedNone] = {}
  human.NeedEntities[eNeedSleep] = {"need_bed", "need_bedroom"}
  human.NeedEntities[eNeedEat] = {"need_food", "need_restaurant"}
  human.NeedEntities[eNeedClean] = {"need_wash", "need_shower"}
  human.NeedEntities[eNeedBathroom] = {"need_piss", "need_toilet"}

  /* Alien */
  local alien = self.Team[eTeamAlien]
  alien.InitialSwarmLives = 5
  alien.SwarmLivesPerInfect = 3

end

function Settings:DefaultGame()

  /* Game */ 
  self.Game.NumberRounds = 8
  self.Game.RoundTime = 600

end


/* Only default settings the first run of the file */
if Settings._first then
  Settings:Default()
  Settings._first = false
end

if SERVER then
  util.AddNetworkString("MorbusSettings")

  function Settings:_SendSettings()
    net.WriteTable(self.Role[eRoleHuman])
    net.WriteTable(self.Role[eRoleBrood])
    net.WriteTable(self.Role[eRoleSwarm])

    net.WriteTable(self.Team[eTeamHuman])
    net.WriteTable(self.Team[eTeamAlien])

    net.WriteTable(self.Game)
  end

  function Settings:SendSettingsToPlayer(ply)
    net.Start("MorbusSettings")
    self:_SendSettings()
    net.Send(ply)
  end

  function Settings:BroadcastSettings()
    net.Start("MorbusSettings")
    self:_SendSettings()
    net.Broadcast()
  end

else

  function Settings:_GetSettings(msgLength)
    self.Role[eRoleHuman] = net.ReadTable()
    self.Role[eRoleBrood] = net.ReadTable()
    self.Role[eRoleSwarm] = net.ReadTable()

    self.Team[eTeamHuman] = net.ReadTable()
    self.Team[eTeamAlien] = net.ReadTable()

    self.Game = net.ReadTable()
  end
  net.Receive("MorbusSettings", function(len) Settings:_GetSettings(len) end)

end