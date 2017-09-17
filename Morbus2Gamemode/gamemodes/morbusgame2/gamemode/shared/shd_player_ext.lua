--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

local META = FindMetaTable("Player")
if not META then return end

local Settings = Morbus.Settings

function META:IsGame() return self:Team() == eGTeamPlayers end
function META:IsSpec() return self:Team() == eGTeamSpectators end

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
    return "(" .. self:Nick() .. ") " .. self:GetNWString("MorbusName", "")
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

function META:GetWeight()
  return self:GetNWInt("Morbus_Weight", 0)
end

function META:SetWeight(newWeight)
  return self:SetNWInt("Morbus_Weight", newWeight)
end

function META:GetNeed()
  return self.Need or eNeedNone
end

function META:SetNeed(newNeed)
  self.Need = newNeed
end

function META:GetNeedTime()
  return self.NeedTime or 0
end

function META:SetNeedTime(newTime)
  self.NeedTime = newTime
end

function META:IsBusy()
  return self:GetNWBool("Morbus_Busy", false)
end
META.GetBusy = META.IsBusy

function META:SetBusy(isBusy)
  self:SetNWBool("Morbus_Busy", isBusy)
end

function META:CanCarryWeapon(wep)
  if not wep or not wep.Type then return false end
  return self:GetWeight() + wep.Weight <= Settings.Player.WeightLimit
end

function META:GetGameSanity()
  return self:GetNWFloat("MorbusSanity", 1000)
end



-- Networking for Variables 
if SERVER then

  util.AddNetworkString("Morbus_PlySendRole")
  function META:SendRole()
    net.Start("Morbus_PlySendRole")
    net.WriteInt(self:GetRole(), 8)
    net.Send(self)

  end

  util.AddNetworkString("Morbus_PlyTellRole")
  function META:TellRoleTo(target)
    net.Start("Morbus_PlyTellRole")
    net.WriteEntity(self)
    net.WriteInt(self:GetRole(), 8)
    net.Send(target)
  end

  util.AddNetworkString("Morbus_PlySendNeed")
  function META:SendNeedData()
    net.Start("Morbus_PlySendNeed")
    net.WriteInt(self:GetNeed(), 8)
    net.WriteInt(self:GetNeedTime(), 24)
    net.Send(self)
  end

else

  local function RecvRole(target)
    local roleNum = net.ReadInt(8)

    if not target.SetRole then return end
    target:SetRole(roleNum)
  end

  net.Receive("Morbus_PlySendRole", function(len) RecvRole(LocalPlayer()) end)
  net.Receive("Morbus_PlyTellRole", function(len) RecvRole(net.ReadEntity()) end)

  local function RecvNeed()
    local needNum = net.ReadInt(8)
    local needTime = net.ReadInt(24)

    if not LocalPlayer().SetNeed then return end

    LocalPlayer():SetNeed(needNum)
    LocalPlayer():SetNeedTime(needTime)
  end
  net.Receive("Morbus_PlySendNeed", function(len) RecvNeed() end)

end
