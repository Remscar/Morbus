// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team


local function GetBroodCount(ply_count)
  local count = math.Round(ply_count * 0.13)
  if count > 0 then
    return count
  else
    return 1
  end
end

local Allow_Bots = true
local function ChooseNewAliens()
  local choices = {}

  for k,v in pairs(player.GetAll()) do
    if IsValid(v) && v:IsHuman() then
      if (Allow_Bots && v:IsBot()) || !v:IsBot() then
        if v:GetBaseSanity() > 500 then
          table.insert(choices, v)
        end
      end
    end 
  end

  local choice_count = #choices
  local brood_count = GetBroodCount(choice_count)

  if choice_count == 0 then print("Error in role selection. #001\n") return end

  local ts = 0
  while ts < brood_count do
    local pick = math.random(1,#choices)

    local pply = choices[pick]

    if IsValid(pply) then

      if pply.Mission_Doing then
        pply:Freeze(false)
        if pply.Gender == GENDER_FEMALE then
          pply:EmitSound(table.Random(Response.Female.Yes),100,100)
        else
          pply:EmitSound(table.Random(Response.Male.Yes),100,100)
        end
      end
      
      ResetMission(pply)
      NewAlien(pply, ROLE_BROOD)
      pply.Evo_Points = STARTING_EVOLUTION_QUEEN + Total_Evolution_Points
      pply:SendEvoPoints()
      GiveLoadoutWeapons(pply)

      SendMsg(pply, "Turns out you were a Brood Alien afterall, better go infect some humans while there's still time.")
    end

    ts = ts + 1
  end
end


// 1 + 1 for every 10 players
local function NumberOfResurgence()
  return 1 + math.floor(#player.GetAll() * 0.095)
end


function CheckResurgence()
  local broods = GetBroodList()

  -- All broods must be dead
  if #broods > 0 then return end

  --SendAll("Number of resurgencies: ".. tostring(STATS.ResurgenceCount or 0))
  --SendAll("Number of allowed resurgencies: ".. tostring(NumberOfResurgence()))

  -- Can't have more than the allowed count
  if (STATS.ResurgenceCount or 0) >= NumberOfResurgence() then return end

  if #player.GetAll() < 9 then return end

  local startRoundTime = STATS.RoundStart
  local endRoundTime = STATS.RoundEnd
  local now = CurTime()

  --SendAll("Time Left in round: "..tostring(now - startRoundTime))
  --SendAll("Required Time Left: "..tostring((endRoundTime - startRoundTime) * 0.6))

  -- The round must be less than 60% done
  if now - startRoundTime > (endRoundTime - startRoundTime) * 0.6 then return end

  local humans = GetHumanList()

  --SendAll("Number of humans = "..tostring(#humans))
  --SendAll("Required number of humans = ".. tostring(STATS.InitialHumans * 0.6))

  -- 40% of the humans at the start of the round must still be alive
  if #humans < STATS.InitialHumans * 0.6 then return end

  STATS.ResurgenceCount = STATS.ResurgenceCount + 1

  ChooseNewAliens()

end
hook.Add("MorbusBroodDied", "Resurgence_Checker", CheckResurgence)