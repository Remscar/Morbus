/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

local function GetPlayerFilter(req)
  local filter = RecipientFilter()
  for k,v in pairs(player.GetAll()) do
    if IsValid(v) and req(v) then
      filter:AddPlayer(v)
    end
  end
  return filter
end

function Morbus.AlienFilter()
  return GetPlayerFilter(function(p) return p:IsAlien() end )
end

function Morbus.BroodFilter()
  return GetPlayerFilter(function(p) return p:IsBrood() end )
end

function Morbus.HumanFilter()
  return GetPlayerFilter(function(p) return p:IsHuman() end )
end

