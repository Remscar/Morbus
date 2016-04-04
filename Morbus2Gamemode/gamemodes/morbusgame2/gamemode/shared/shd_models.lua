/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

if not Morbus.Models then
  Morbus.Models = {}
end

/* ===== ===== Human Models ===== ===== */
if not Morbus.Models[eRoleHuman] then
  Morbus.Models[eRoleHuman] = {}
end

Morbus.Models[eRoleHuman][eGenderMale] = {
"models/player/group01/male_01.mdl",
"models/player/group01/male_02.mdl",
"models/player/group01/male_03.mdl",
"models/player/group01/male_04.mdl",
"models/player/group01/male_05.mdl",
"models/player/group01/male_06.mdl",
"models/player/group01/male_07.mdl",
"models/player/group01/male_08.mdl",
"models/player/group01/male_09.mdl",
"models/player/monk.mdl",
"models/player/odessa.mdl",
"models/player/Kleiner.mdl",
"models/player/breen.mdl",
"models/player/Barney.mdl",
"models/player/Hostage/hostage_01.mdl",
"models/player/Hostage/hostage_02.mdl",
"models/player/Hostage/hostage_03.mdl",
"models/player/Hostage/hostage_04.mdl",
}

Morbus.Models[eRoleHuman][eGenderFemale] = {
"models/player/group01/female_01.mdl",
"models/player/group01/female_02.mdl",
"models/player/group01/female_03.mdl",
"models/player/group01/female_04.mdl",
"models/player/group01/female_06.mdl",
"models/player/alyx.mdl",
"models/player/mossman.mdl",
}

/* ===== ===== Alien Models ===== ===== */
Morbus.Models[eRoleBrood] = "models/player/verdugo/verdugo.mdl"
Morbus.Models[eRoleSwarm] = "models/morbus/swarm/enhancedslasher.mdl"

local function PrecacheModelTable(tab)
  if type(tab) == "table" then
    for k,v in pairs(tab) do
      util.PrecacheModel(v)
    end
  elseif type(tab) == "string" then
    util.PrecacheModel(tab)
  end
end

PrecacheModelTable(Morbus.Models[eRoleHuman][eGenderFemale])
PrecacheModelTable(Morbus.Models[eRoleHuman][eGenderMale])
PrecacheModelTable(Morbus.Models[eRoleBrood])
PrecacheModelTable(Morbus.Models[eRoleSwarm])