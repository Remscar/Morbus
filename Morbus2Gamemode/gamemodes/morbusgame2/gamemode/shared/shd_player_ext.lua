/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local META = FindMetaTable("Player")
if not META then return end

local Settings = Morbus.Settings

function META:IsGame() return self:Team() == eTeamPlayer end
function META:IsSpec() return self:Team() == eTeamSpectator end

function META:GetRole()
  return self.Role
end

function META:SetRole(newRole)
  self.Role = newRole
end

function META:IsHuman() return self.Role == eRoleHuman end
function META:IsBrood() return self.Role == eRoleBrood end
function META:IsSwarm() return self.Role == eRoleSwarm end
function META:IsAlien() return self:IsSwarm() or self:IsBrood() or self:IsSpec() end

function META:IsRole(role) return self:GetRole() == role end

function META:MorbusName(real)
  if real then
    return "("..self:Nick()..") "..self:GetNWString("MorbusName", "")
  else
    return self:GetNWString("MorbusName", "")
  end
end

function META:MorbusTeam()
  if self:IsAlien() then
    return eTeamAlien
  else
    return eTeamHuman
  end
end

function META:CanCarryWeapon(wep)
  if not wep or not wep.Type then return false end

  return self:CanCarryWeaponType(wep.Type)
end

function META:CanCarryWeaponType(wepType)
  if not wepType then return end

  local hasCount = 0

  for k, w in pairs(self:GetWeapons()) do
    if w.Type == wepType then
      hasCount = hasCount + 1

      if hasCount >= Settings.Player.WeaponTypeLimit[w.Type] then
        return false
      end
    end
  end

  return true
end

function META:GetGameSanity()
  return self:GetNWFloat("MorbusSanity", 1000)
end