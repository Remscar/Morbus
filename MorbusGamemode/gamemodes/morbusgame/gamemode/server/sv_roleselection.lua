// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/*-----------------------------
ROLE SELECTION
------------------------------*/

local function GetBroodCount(ply_count)
	local count = math.Round(ply_count * 0.13)
	if count > 0 then
		return count
	else
		return 1
	end
end

local function SendRoles()
   for k,v in pairs(player.GetAll()) do
      if IsValid(v) then
         SendPlayerRole(v:GetRole(), v)
      end
   end
end


LAST_ALIEN = {}
local Allow_Bots = true
function SelectRoles()
	local choices = {}

   for k,v in pairs(player.GetAll()) do
      if IsValid(v) && v:IsGame() then
         if (Allow_Bots && v:IsBot()) || !v:IsBot() then
            if v:GetBaseSanity() > 500 then
               table.insert(choices, v)
            end
         end
      end

      v:SetRole(ROLE_HUMAN)
   end
   local la = {}
   

   local choice_count = #choices
   local brood_count = GetBroodCount(choice_count)

   if choice_count == 0 then print("Error in role selection. #001\n") return end

   local ts = 0
   while ts < brood_count do
   	local pick = math.random(1,#choices)

   	local pply = choices[pick]
      local pass = false

      if table.HasValue(LAST_ALIEN,pply) then
         if math.random(1,5) < 2 then
            pass = true
         end
      else
         pass = true
      end

   	if IsValid(pply) && (pass == true) then
   		pply:SetRole(ROLE_BROOD)
         pply.Mission = MISSION_KILL
         pply:SendMission()
   		table.remove(choices, pick)
   		ts = ts + 1
         RoundHistory["First"][ts] = pply
         pply.Evo_Points = STARTING_EVOLUTION_QUEEN
         table.insert(la,pply)
   	end
   end


   LAST_ALIEN = table.Copy(la)

   SendRoles()
   UpdateAliens(true)
end


