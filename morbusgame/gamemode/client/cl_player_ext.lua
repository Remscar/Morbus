---------------------------------LOCALIZATION
local math = math
local table = table
local umsg = umsg
local player = player
local timer = timer
local pairs = pairs
local umsg = umsg
local usermessage = usermessage
local file = file
---------------------------------------------
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
