--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

local META = FindMetaTable("Player")
if not META then return end

local Settings = Morbus.Settings

function META:FullReset()
  self:SetWeight(0)

  self:SetTeam(eGTeamPlayers)

  self:ResetRole()
  self:ResetNeed()
  self:StripAll()
  self:ResetPlayerStats()
  self:ResetBroodStats()
end

function META:ResetMorbusData()
  self:SetNWString("Morbus_Name", "")
  self:SetNWInt("Morbus_MuteStatus", 0)
end

function META:ResetRole()
  self:SetRole(eRoleHuman)
  self:SendRole()
end

function META:ResetNeed()
  self:SetNeed(eNeedNone)
  self:SetNeedTime(0)
  self:SetBusy(false)
  self:SendNeedData()

  self.NextNeed = CurTime() + math.random(Settings.Game.MinNeedTime, Settings.Game.MaxNeedTime)
end

function META:StripAll()
  self:StripAmmo()
  self:StripWeapons()
end

function META:ResetPlayerStats()
  self.FreeKill = 0
  self:Freeze(false)
  self:SetColor(Color(255, 255, 255, 255))
  self:SetNoDraw(false)

  self.JumpPower = Settings.Role[eRoleHuman].DefaultJump
  self:SetJumpPower(self.JumpPower)
  GAMEMODE:SetPlayerSpeed(self, Settings.Role[eRoleHuman].RunSpeed,
    Settings.Role[eRoleHuman].SprintSpeed)
end

function META:ResetBroodStats()
  self.CanTransform = true
  self.NextTransform = CurTime()
  self:SetNWBool("Morbus_AlienForm", false)
end

function META:ShouldSpawn()
  return not self.ForceSpectator
end

function META:SpawnForRound(dead)
  if dead and self:Alive() then
    self:SetHealth(self:GetMaxHealth())
    return false
  end

  if not self:ShouldSpawn() then return end

  self:FullReset()
  self:SetTeam(eGTeamPlayers)
  self:SpawnSetup()
  self:Spawn()

  return true
end

function META:SpawnSetup()
  self:SelectGender()
  self:SelectName()
  self:SelectModel()
end

function META:SelectGender()
  local gen = math.random(eGenderMale, eGenderFemale)
  self.Gender = gen
end

function META:SelectName()
  local name

  if self.Gender == eGenderMale then
    name = table.Random(Morbus.Names.Male)
  else
    name = table.Random(Morbus.Names.Female)
  end

  name = name .. " " .. table.Random(Morbus.Names.Last)

  self:SetNWString("Morbus_Name", name)
end

function META:SelectModel()
  if self:IsSwarm() then return end

  if self.Gender == eGenderMale then
    self.WantedModel =  table.Random(Morbus.Models[eRoleHuman][eGenderMale])
  elseif self.Gender == eGenderFemale then
    self.WantedModel =  table.Random(Morbus.Models[eRoleHuman][eGenderFemale])
  end
end

function META:DeathSound()

end

function META:DeathEffect()

end

