--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

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

  Morbus.Settings.Weapons = {}

  Morbus.Settings.Items = {}

  Morbus.Settings.Player = {}
end

local Settings = Morbus.Settings

function Settings:Default()
  self:DefaultRole()
  self:DefaultTeam()
  self:DefaultGame()
  self:DefaultWeapons()
  self:DefaultItems()
  self:DefaultPlayer()
end

function Settings:DefaultRole()
  -- Human 
  local human = self.Role[eRoleHuman]
  human.DefaultJump = 200
  human.RunSpeed = 270
  human.SprintSpeed = 270

  human.NeedCompleteTime = 8

  human.BatteryMult = 0.3
  human.BatterySize = 35

  -- Brood 
  local brood = self.Role[eRoleBrood]
  brood.DefaultJump = 200
  brood.RunSpeed = 330
  brood.SprintSpeed = 270

  brood.FirstPerkPoints = 5
  brood.NewPerkPoints = 1
  brood.PerkPointsPerKill = 1
  brood.TierRequirement = 3

  brood.TransformCooldown = 10

  -- Swarm 
  local swarm = self.Role[eRoleSwarm]
  swarm.DefaultJump = 200
  swarm.RunSpeed = 250
  swarm.SprintSpeed = 250

end

function Settings:DefaultTeam()
  -- Human 
  local human = self.Team[eTeamHuman]
  human.NeedEntities = {}
  human.NeedEntities[eNeedNone] = {}
  human.NeedEntities[eNeedSleep] = {"need_bed", "need_bedroom"}
  human.NeedEntities[eNeedEat] = {"need_food", "need_restaurant"}
  human.NeedEntities[eNeedClean] = {"need_wash", "need_shower"}
  human.NeedEntities[eNeedBathroom] = {"need_piss", "need_toilet"}

  -- Alien 
  local alien = self.Team[eTeamAlien]
  alien.InitialSwarmLives = 5
  alien.SwarmLivesPerInfect = 3

end

function Settings:DefaultGame()
  -- Game 
  self.Game.NumberRounds = 8
  self.Game.RoundTime = 5
  self.Game.PlayerRequirement = 2

  self.Game.PrepTime = 3
  self.Game.PostTime = 3
  self.Game.EvacTime = 3

  self.Game.ChatRange = 800

  self.Game.BroodCount = 0.13

  self.Game.MinNeedTime = 60
  self.Game.MaxNeedTime = 90

  self.Game.SwarmRespawnTime = 5
  self.Game.BroodRespawnTime = 3

  self.Game.BroodBots = true

end

function Settings:DefaultPlayer()
  self.Player.WeaponTypeLimit = {}
  local wepLimits = self.Player.WeaponTypeLimit

  -- Default all to 1
  for i = 1, eWTypeCount do wepLimits[i] = 1 end
  wepLimits[eWTypeMisc] = 2


  self.Player.AmmoTypeLimit = {}
  local ammoLimits = self.Player.AmmoTypeLimit
  ammoLimits[eAmmoPistol] = 45
  ammoLimits[eAmmoSMG] = 60
  ammoLimits[eAmmoRifle] = 60
  ammoLimits[eAmmoShotgun] = 16
  ammoLimits[eAmmoBattery] = 30


  self.Player.WeightLimit = 100
end

include("weapons.lua")
include("items.lua")

-- Only default settings the first run of the file 
if Settings._first then
  Settings:Default()
  Settings._first = false
end

if SERVER then
  util.AddNetworkString("MorbusSettings")
  AddCSLuaFile("weapons.lua")
  AddCSLuaFile("items.lua")

  function Settings:_SendSettings()
    net.WriteTable(self.Role[eRoleHuman])
    net.WriteTable(self.Role[eRoleBrood])
    net.WriteTable(self.Role[eRoleSwarm])

    net.WriteTable(self.Team[eTeamHuman])
    net.WriteTable(self.Team[eTeamAlien])

    net.WriteTable(self.Game)

    net.WriteTable(self.Weapons)

    net.WriteTable(self.Items)

    net.WriteTable(self.Player)
  end

  function Settings:SendToPlayer(ply)
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

    self.Weapons = net.ReadTable()

    self.Items = net.ReadTable()

    self.Player = net.ReadTable()
  end
  net.Receive("MorbusSettings", function(len) Settings:_GetSettings(len) end)

end
