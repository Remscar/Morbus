/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

include("shared.lua")
include("settings.lua")

for k, v in pairs(file.Find(Morbus.Folder .. "/gamemode/shared/*.lua","LUA")) do include("shared/" .. v) end