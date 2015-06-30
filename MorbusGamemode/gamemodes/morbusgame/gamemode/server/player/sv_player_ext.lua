// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

local plymeta = FindMetaTable( "Player" )
if not plymeta then return end




function plymeta:StripAll(reset_everything)
   -- standard stuff
   self:StripAmmo()
   if (reset_everything) then
      self:ResetStatus()
   end
end

function plymeta:MakeSpec(temp)
   self:LightReset()
   self:StripAmmo()
   self:StripWeapons()
   self:SetMoveType(MOVETYPE_NOCLIP)
   self:SpectateEntity(nil)
   self:SetTeam(TEAM_SPEC)
   if temp then
      self.TempSpec = true
   end
end

function plymeta:MakeSwarm()
   self:LightReset()
   self:SetTeam(TEAM_GAME)
end

function plymeta:LightReset()
   self:Freeze(false)
   self.FreeKill = 0
   self.Invisible = false
   self.AlienForm = false
   self.Mission = 0
   self.Battery = LIGHT_BATTERY
   self.Touching = MISSION_NONE
   self.NightVision = false
   self.Mission_Doing = false
   self.Mission_End = 0
   self.Mission_Complete = 0
   self:ResetMission()
   self.Mission_Next = CurTime() + math.random(GetConVar("morbus_mission_next_time_min"):GetInt(),GetConVar("morbus_mission_next_time_max"):GetInt())
   self.Moving = false
   self.Moved = false
   self.Cloaked = 0
   self:SetMoveType(MOVETYPE_WALK)
   self.Cloaking = false
   self.CloakStart = 0
   self.Weight = 0
   self.NextTransform = CurTime()
   self.CanTransform = true
   self.Jump = DEFAULT_JUMP
   self:SetNWBool("alienform",false)
   self:UnSpectate()
   self:SetColor(Color(255,255,255,255))
   self.MaxHealth = 100
   self:SetNoDraw(false)
   GAMEMODE:SetPlayerSpeed(self,HUMAN_SPEED,HUMAN_SPEED) 
   self:SetJumpPower(DEFAULT_JUMP)
end

function plymeta:End_ClearMission()
   self.Mission = 0
   self.Touching = MISSION_NONE
   self.Mission_Doing = false
   self.Mission_End = 0
   self.Mission_Complete = 0
   self.Mission_Next = CurTime() + 9999
   self:ResetMission()
   self.TempSpec = false
   self:Freeze(false)
end


function plymeta:ResetStatus()
   self:SetTeam(TEAM_GAME)
   self:SetRole(ROLE_HUMAN)
   self.Battery = LIGHT_BATTERY
   LIGHT.TurnOff(self)
   self.WantedModel = Models.Swarm
   self.Touching = MISSION_NONE
   self.Invisible = false
   self.AlienForm = false
   self.WantsSpec = false
   self.TempSpec = false
   self.Mission = 0
   self.NightVision = false
   self.Mission_End = 0
   self.Mission_Doing = false
   self.Mission_Complete = 0
   self:ResetMission()
   self.Mission_Next = CurTime() + math.random(60,90)--math.random(30,60)
   self:SetNWInt("Mute_Status",0)
   self.Moving = false
   self.Moved = false
   self.Cloaked = 0
   self.Cloaking = false
   self.CloakStart = 0
   self.Weight = 0
   self.Killer = self
   self:Freeze(false)
   self:SetNWBool("alienform",false)
   self:SetNWString("fakename","")
   self:UnSpectate()
   self:SetColor(Color(255,255,255,255))
   self:SetNoDraw(false)
   self.MaxHealth = 100
   GAMEMODE:SetPlayerSpeed(self,HUMAN_SPEED,HUMAN_SPEED)
   self.Jump = DEFAULT_JUMP
   self:SetJumpPower(self.Jump)
   self.Evo_Points = 0
   self.Upgrades = {}
   self.NextTransform = CurTime()
   self.CanTransform = true
end

/*-------------------------------------------
WEIGHT AND SPEED
-------------------------------------------*/


function plymeta:SendWeight()
   SendPlayerWeight(self.Weight,self) //networking
end

function plymeta:CalcWeight()
   if self:IsSwarm() then return end
   local Weight = 0
   for k,v in pairs(self:GetWeapons()) do
      Weight = Weight + (v.KGWeight*2.3)
   end

   self.Weight = Weight // Transfer to global
   local m_speed = HUMAN_SPEED - self.Weight // Set speed
   if m_speed < 50 then m_speed = 50 end // Set the bottom limit

   GAMEMODE:SetPlayerSpeed(self,m_speed,m_speed) // Set the speed
   self:SetMaxSpeed(m_speed)
end


function plymeta:SetSpeed()
   if self:IsSwarm() then
      if self:GetSwarmMod() == 5 then
          GAMEMODE:SetPlayerSpeed(self,350,350)
      else
          GAMEMODE:SetPlayerSpeed(self,SWARM_SPEED,SWARM_SPEED)
      end

   end
   if self:IsHuman() || self:IsBrood() then
      self:CalcWeight()
   end

end

/*------------------------------------------------
SOUNDS
---------------------------------------------------*/

function plymeta:DeathSound() -- TO DO
   if not ValidEntity(self) then return end

   if self:IsSpec() then return end

   if self:IsBrood() then
      sound.Play(table.Random(Sounds.Brood.Death), self:GetPos(), 300, 100)
   elseif self:IsSwarm() then
      sound.Play(table.Random(Sounds.Swarm.Death), self:GetPos(), 300, 100)
   elseif self.Gender == GENDER_FEMALE then
      sound.Play(table.Random(Sounds.Female.Death), self:GetPos(), 300, 100)
   else
      sound.Play(table.Random(Sounds.Male.Death), self:GetPos(), 300, 100)
   end
end

function plymeta:KilledAlien()
   if self.Gender == GENDER_FEMALE then
      self:EmitSound(table.Random(Sounds.Female.KillAlien),100,100)
   else
      self:EmitSound(table.Random(Sounds.Male.KillAlien),100,100)
   end
end


/*------------------------------------------------
SANITY
---------------------------------------------------*/


function plymeta:SetLiveSanity(k)
   self.LiveSanity = k
end

function plymeta:GetLiveSanity()
   return self.LiveSanity
end

function plymeta:SetBaseSanity(k)
   self:SetNWFloat("sanity", k, true)
end

function plymeta:InitSanity()
   SANITY.InitPlayer(self)
end

function plymeta:SetDamageFactor(dmg)
   self.DamageFactor = dmg
end

function plymeta:GetDamageFactor()
   return self.DamageFactor or 1
end

/*------------------------------------------------
MISSION SHIT
---------------------------------------------------*/

function plymeta:SendMission()
   Send_MissionInfo(self)
end

function plymeta:SendMissionComplete()
   Send_MissionComplete(self)
end

function plymeta:ResetMission()
   ResetMission(self)
end


/*-------------------------------------------
MODEL STUFF + SETUP
-------------------------------------------*/

function plymeta:SelectGender()
   local gen = math.random(GENDER_FEMALE,GENDER_MALE)

   if self.ForceGender then gen = self.ForceGender end
   return gen
end

function plymeta:SelectName()
   local gen = self.Gender
   local name

   if gen == GENDER_MALE then
      name = table.Random(NAMES.MALE)
   else
      name = table.Random(NAMES.FEMALE)
   end

   name = name.." "..table.Random(NAMES.LAST)

   if self.ForceName then
      name = self.ForceName // Donator
   end

   return name
end

function plymeta:SelectModel()
   local gender = self.Gender

   if (self:IsSwarm()) then return Models.Swarm end

   if (gender == GENDER_MALE) then
      self:SetHardGender( 1 )
      return table.Random(Models.Male)
   else
      self:SetHardGender( 2 )
      return table.Random(Models.Female)
   end

end

function plymeta:SetupPlayer()
   self.Gender = self:SelectGender()
   self:SetNWString("fakename",self:SelectName())
   self.WantedModel = self:SelectModel()
end





/*-------------------------------------------
UTIL
-------------------------------------------*/
function plymeta:ShouldReset()
   if self.WantsSpec then return false end
   return true
end


function plymeta:ShouldSpawn()
	if not self.IsGame() then return false end
	return true
end


function plymeta:ResetViewRoll()
   local ang = self:EyeAngles()
   if ang.r != 0 then
      ang.r = 0
      self:SetEyeAngles(ang)
   end
end

function plymeta:SpawnForRound(dead)

	if dead and self:Alive() then

		self:SetHealth(self:GetMaxHealth())
		return false
	end

   if !self:ShouldReset() then return end

	self:StripAll(true)
	self:SetTeam(TEAM_GAME)
   self:SetupPlayer()

   self:Spawn()
	return true
end

function plymeta:GetTierPoints(tree,tier)
   local c = 0

   for k,v in pairs(UPGRADES) do
      if (v.Tier==tier) && (v.Tree==tree) then
         if self.Upgrades[k] then
            c = c + self.Upgrades[k]
         end
      end
   end

   return c
end    
