--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

include("shared.lua")
AddCSLuaFile("shared.lua")

include("settings/settings.lua")
AddCSLuaFile("settings/settings.lua")

IncludeFolder("server")

IncludeFolder("shared", AddCSLuaFile)
IncludeFolder("rounds", AddCSLuaFile)
IncludeFolder("entities", AddCSLuaFile)

function GM:InitPostEntity()
  print("Post entity")
  Morbus.RoundEngine:ChangeState(eRoundWait)
end

function GM:Think()
  Morbus.RoundEngine:Think()
end

