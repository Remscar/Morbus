--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

function GetPlayerFilter(req)
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

function Morbus.SpectatorFilter()
  return GetPlayerFilter(function(p) return p:IsSpec() end )
end

function Morbus.ChatFilter(ply)
  return GetPlayerFilter(function(p) return ply:GetShootPos():Distance(p:GetShootPos()) < Settings.Game.ChatRange end )
end

function Morbus.AllFilter()
  local rf = RecipientFilter()
  rf:AddAllPlayers()
  return rf
end