local plymeta = FindMetaTable( "Player" )
if not plymeta then return end

if CLIENT then
   function plymeta:SetWeaponHoldType() --fuck you garry
   end
end

function plymeta:IsGame() return self:Team() == TEAM_GAME end
function plymeta:IsSpec() return self:Team() == TEAM_SPEC end

AccessorFunc(plymeta, "role", "Role", FORCE_NUMBER)


function plymeta:GetBrood() return self:GetRole() == ROLE_BROOD end
function plymeta:GetSwarm() return self:GetRole() == ROLE_SWARM end
function plymeta:GetHuman() return self:GetRole() == ROLE_HUMAN end
function plymeta:GetAlien()
	if (self:GetRole() == ROLE_SWARM || self:GetRole() == ROLE_BROOD || self:Team() == TEAM_SPEC) then
		return true
	else
		return false
	end
end

plymeta.IsAlien = plymeta.GetAlien
plymeta.IsBrood = plymeta.GetBrood
plymeta.IsHuman = plymeta.GetHuman
plymeta.IsSwarm = plymeta.GetSwarm

function plymeta:IsSpecial() return self:GetRole() != ROLE_HUMAN end

function plymeta:IsRole(role) return self:GetRole() == role end
function plymeta:IsActiveRole(role) return self:IsRole(role) and (GetRoundState() == ROUND_ACTIVE) end
function plymeta:IsActiveBrood() return self:IsActiveRole(ROLE_BROOD) end
function plymeta:IsActiveSwarm() return self:IsActiveRole(ROLE_SWARM) end
function plymeta:IsActiveSpecial() return self:IsSpecial() and (GetRoundState() == ROUND_ACTIVE) end
function plymeta:IsActiveAlien() return self:IsActiveRole(ROLE_BROOD) or self:IsActiveRole(ROLE_SWARM) end
function plymeta:IsActiveHuman() return self:IsActiveRole(ROLE_HUMAN) end

function plymeta:SetWeight(number)
   self.Weight = number
end

function plymeta:GetWeight()
   return self.Weight or 0
end

function plymeta:GetFName(fake)
   if !ValidEntity(self) then return "disconnected" end

   if CLIENT then // Players may want to disable the rp names
      if GetConVar("morbus_hide_rpnames"):GetBool() && GetGlobalBool("morbus_rpnames_optional",false) then
         return self:Nick()
      end
   end

   if fake then
      return "("..self:Nick().. ") "..self:GetNWString("fakename","")
   else
      return self:GetNWString("fakename","")
   end
end

function plymeta:GetBaseSanity()
   return self:GetNWFloat("sanity", 1000) -- f it
end

function plymeta:CanCarryWeapon(wep)
   if (not wep) or (not wep.Kind) then return false end

   return self:CanCarryType(wep.Kind)
end

function plymeta:CanCarryType(t)
   if not t then return false end

   for _, w in pairs(self:GetWeapons()) do
      if w.Kind and w.Kind == t then
         return false
      end
   end
   return true
end

GM.Author = "Remscar"


function plymeta:GetEyeTrace(mask)
   if self.LastPlayerTraceMask == mask and self.LastPlayerTrace == CurTime() then
      return self.PlayerTrace
   end

   local tr = util.GetPlayerTrace(self)
   tr.mask = mask

   self.PlayerTrace = util.TraceLine(tr)
   self.LastPlayerTrace = CurTime()
   self.LastPlayerTraceMask = mask
   
   return self.PlayerTrace
end

