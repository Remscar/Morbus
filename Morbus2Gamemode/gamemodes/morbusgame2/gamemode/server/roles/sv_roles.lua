/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local Settings = Morbus.Settings
local Players = Morbus.Players
local Aliens = Morbus.Aliens

local function BroodCount(plyCount)
  local count = math.Round(plyCount * Settings.Game.BroodCount)
  if count > 0 then return count end
  return 1
end

function Players:SelectRoles()
  local options = GetPlayerList(function(p)
    print(tostring(p:IsGame()))
    if IsValid(p) and p:IsGame() then
      if (Settings.Game.BroodBots and p:IsBot()) or not p:IsBot() then
        return true
      end
    end
    return false
  end)

  local numberBroods = BroodCount(#options)

  local broodsPicked = 0

  while broodsPicked < numberBroods do
    local pick = math.random(1, #options)

    local ply = options[pick]
    
    ply:SetRole(eRoleBrood)

    table.remove(options, pick)
    broodsPicked = broodsPicked + 1
  end

  

  Players:SendRoles()
  Aliens:SendAllRoles()
end

function Players:SendRoles()
  for k,v in pairs(player.GetAll()) do
    v:SendRole()
  end
end

function Players:PrepareRoles()

end