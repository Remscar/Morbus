/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

include("shared.lua")
AddCSLuaFile("shared.lua")

include("settings/settings.lua")
AddCSLuaFile("settings/settings.lua")

IncludeFolder("shared", AddCSLuaFile)
IncludeFolder("entities", AddCSLuaFile)