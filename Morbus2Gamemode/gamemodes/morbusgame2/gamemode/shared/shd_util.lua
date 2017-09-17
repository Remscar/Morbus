--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

function GetPlayerList(req)
  local pList = {}
  for k,v in pairs(player.GetAll()) do
    if IsValid(v) and req(v) then
      table.insert(pList, v)
    end
  end
  return pList
end

function Morbus.HumanList()
  return GetPlayerList(function(p) return p:IsHuman() end )
end

function Morbus.AlienList()
  return GetPlayerList(function(p) return p:IsAlien() end )
end

function Morbus.BroodList()
  return GetPlayerList(function(p) return p:IsBrood() end )
end

function Morbus.SwarmList()
  return GetPlayerList(function(p) return p:IsSwarm() end )
end

function Morbus.SpectatorList()
  return GetPlayerList(function(p) return p:IsSpec() end )
end