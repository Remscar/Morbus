/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

include("shared.lua")
include("settings/settings.lua")

for k, v in pairs(file.Find(Morbus.Folder .. "/gamemode/shared/*.lua","LUA")) do include("shared/" .. v) end
--for k, v in pairs(file.Find(Morbus.Folder .. "/gamemode/server/*.lua","LUA")) do include("server/" .. v) end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("settings/settings.lua")

for k, v in pairs(file.Find(Morbus.Folder .. "/gamemode/shared/*.lua","LUA")) do AddCSLuaFile("shared/" .. v) end