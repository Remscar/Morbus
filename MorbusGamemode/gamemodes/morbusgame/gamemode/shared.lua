// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team


GM.Name = "MORBUS" //VERSION 1.5.8
GM.Author = "Remscar"
GM.Email = "zachary@remscar.com"
GM.Website = "http://www.remscar.com"
GM.TeamBased  = false;

GM_VERSION = "1.5.8"
GM_VERSION_SHORT = 158
-----------------------------------------------------
local folder = GM.Folder
FOLDER_NAME = folder:gsub("gamemodes/", "")

// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

_G.ValidEntity = _G.IsValid

---------------------------------------ENUMERATIONS

ROUND_WAIT = 1
ROUND_PREP = 2
ROUND_ACTIVE = 3
ROUND_POST = 4
ROUND_EVAC = 5

ROUND_TEXT = {}
ROUND_TEXT[1] = "Wait"
ROUND_TEXT[2] = "Prepare"
ROUND_TEXT[3] = "Extraction"
ROUND_TEXT[4] = "Cooldown"
ROUND_TEXT[5] = "Evacuation"

GENDER_FEMALE = 1
GENDER_MALE = 2

ROLE_HUMAN = 1
ROLE_BROOD = 2
ROLE_SWARM = 3
ROLE_NONE = ROLE_SWARM

MISSION_NONE = 0
MISSION_SLEEP = 1
MISSION_EAT = 2
MISSION_CLEAN = 3
MISSION_BATHROOM = 4
MISSION_KILL = 5

WIN_NONE = 1
WIN_HUMAN = 2
WIN_ALIEN = 3

TEAM_GAME = 1
team.SetUp(TEAM_GAME,"Players",Color(0,255,0,255),true)
TEAM_SPEC = 2
team.SetUp(TEAM_SPEC,"Spectators",Color(255,125,0,255),true)

WEAPON_MELEE = 0
WEAPON_PISTOL = 1
WEAPON_LIGHT = 2
WEAPON_RIFLE = 3
WEAPON_HEAVY = 4
WEAPON_MISC = 5
WEAPON_ROLE = 6


DEFAULT_JUMP = 200

STARTING_EVOLUTION_QUEEN = 5
STARTING_EVOLUTION = 1

POINTS_PER_KILL = 1
POINTS_PER_KILL2 = 0

UPGRADE_TIER_REQUIREMENT = 3

LIGHT_MULT = 0.3
LIGHT_BATTERY = 35

TRANSFORM_TIME = 10

STARTING_SWARM_SPAWNS = 5
SWARM_SPAWNS_BONUS = 3





----------------------------------------------------
NEED_ENTS = {}
NEED_ENTS_LOCATIONS = {}
NEED_ENTS[MISSION_SLEEP] = {"need_bed","need_bedroom"}
NEED_ENTS[MISSION_EAT] = {"need_food","need_restaurant"}
NEED_ENTS[MISSION_CLEAN] = {"need_wash","need_shower"}
NEED_ENTS[MISSION_BATHROOM] = {"need_piss","need_toilet"}

/*-----------------------------
COSNTANTS
------------------------------*/
BROOD_SPEED = 330
BROOD_SPRINT = 390
SWARM_SPEED = 250
HUMAN_SPEED = 270

TTC_MISSION = 8
--FIRST_SPAWN = true



/*-------------------------------------------------
Random Shared Models
aka humanss
---------------------------------------------------*/
Models = {}
Models.Male = {
-- "models/player/group01/male_01.mdl",
-- "models/player/group01/male_02.mdl",
-- "models/player/group01/male_03.mdl",
-- "models/player/group01/male_04.mdl",
-- "models/player/group01/male_05.mdl",
-- "models/player/group01/male_06.mdl",
-- "models/player/group01/male_07.mdl",
-- "models/player/group01/male_08.mdl",
-- "models/player/group01/male_09.mdl",
-- "models/player/monk.mdl",
-- "models/player/odessa.mdl",
-- "models/player/Kleiner.mdl",
-- "models/player/breen.mdl",
-- "models/player/Barney.mdl",
-- "models/player/Hostage/hostage_01.mdl",
-- "models/player/Hostage/hostage_02.mdl",
-- "models/player/Hostage/hostage_03.mdl",
-- "models/player/Hostage/hostage_04.mdl",
"models/player/combine_soldier_prisonguard.mdl",
"models/player/combine_soldier.mdl",
"models/player/police.mdl",
"models/player/marine/marine.mdl",
"models/ez2models/combine_soldier_bloody.mdl",
"models/ez2models/humans/group05b/male_01.mdl",
"models/ez2models/humans/group05b/male_02.mdl",
"models/ez2models/humans/group05b/male_03.mdl",
"models/ez2models/humans/group05b/male_05.mdl",
"models/ez2models/humans/group05b/male_06.mdl",
"models/ez2models/humans/group05b/male_08.mdl",
"models/ez2models/humans/group05b/male_09.mdl",
"models/player/marine/marine.mdl",
"models/bloo_ltcom/citizens/male_09.mdl",
"models/player/deadspace2023/dsrisaaclv3.mdl",
"models/ez2models/radioguy.mdl",
}


Models.Female = {
-- "models/player/group01/female_01.mdl",
-- "models/player/group01/female_02.mdl",
-- "models/player/group01/female_03.mdl",
-- "models/player/group01/female_04.mdl",
-- "models/player/group01/female_06.mdl",
"models/player/alyx.mdl",
"models/player/mossman.mdl",
"models/player/police_fem.mdl",
"models/ez2models/mossman_young.mdl",
}


Models.Brood = "models/player/verdugo/verdugo.mdl"
Models.Swarm = "models/morbus/swarm/enhancedslasher.mdl"
util.PrecacheModel(Models.Brood)
util.PrecacheModel(Models.Swarm)

local function LoadModels(tab)
  for k,v in pairs(tab) do
    util.PrecacheModel(v)
  end
end
LoadModels(Models.Male)
LoadModels(Models.Female)


//I removed my little monologue here because it was pretty dumb