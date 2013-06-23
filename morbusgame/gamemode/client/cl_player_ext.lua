// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
/*------------------------------------------------
PLAYER EXTENSION CLIENT SIDE
-------------------------------------------------*/

local plymeta = FindMetaTable( "Player" )
if not plymeta then return end


function plymeta:GetMission()
	return self.Mission or MISSION_NONE
end

function plymeta:SetMission(number)
	self.Mission = number or MISSION_NONE
end

function plymeta:GetMissionIcon()
	return MissionIcon[self:GetMission()] or ICON_WAIT
end

function plymeta:GetMissionTitle()
	return GetMissionTitle(self:GetMission())
end

function plymeta:GetMissionText()
	return GetMissionText(self:GetMission())
end

function plymeta:ResetPlayer()
	self.Mission = MISSION_NONE
	self.Mission_End = CurTime()
	self.Weight = 0
	self.NightVision = true
	self.Role = ROLE_HUMAN
	self.Battery = LIGHT_BATTERY
	self.Light = false
	self.MaxHealth = 100
	self.Cloaked = false
	self.Cloaking = 0
	self.NextBattery = LIGHT_BATTERY
	self.OLDANG = Angle(0,0,0)
	self.OLDPOS = Vector(0,0,0)
	Morbus.CanTransform = true
end

function plymeta:GetRoleName()
	return GetRoleName(self:GetRole())
end

function plymeta:GetTierPoints(tree,tier)
   local c = 0

   for k,v in pairs(UPGRADES) do
      if (v.Tier==tier) && (v.Tree==tree) then
         if Morbus.Upgrades[k] then
            c = c + Morbus.Upgrades[k]
         end
      end
   end

   return c
end


function plymeta:HasWeapon(cls)
  for _, wep in pairs(self:GetWeapons()) do
     if IsValid(wep) and wep:GetClass() == cls then
        return true
     end
  end

  return false
end

local gmod_GetWeapons = plymeta.GetWeapons
function plymeta:GetWeapons()
  if self != LocalPlayer() then
     return {}
  else
     return gmod_GetWeapons(self)
  end
end