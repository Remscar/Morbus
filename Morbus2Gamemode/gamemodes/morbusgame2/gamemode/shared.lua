/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

/* GMOD Gamemode Data */
GM.Name = "Morbus 2"
GM.Author = "Zachary Nawar"
GM.Website = "http://morbus.remscar.com"

/* Morbus Global Data */
if not Morbus then
  Morbus = {}
end

/* Version data */
Morbus.Version = "2.0.0"
Morbus.VersionNumber = 200
Morbus.Folder = GM.Folder:gsub("gamemodes/", "")

/* Morbus Round Enums */
eRoundWait = 1
eRoundPrep = 2
eRoundActive = 3
eRoundEvac = 4
eRoundPost = 5

/* Morbus Gender Enums */
eGenderMale = 1
eGenderFemale = 2

/* Morbus Role Enums */
eRoleHuman = 1
eRoleBrood = 2
eRoleSwarm = 3
eRoleNone = 4

/* Morbus Need Enums */
eNeedNone = 1
eNeedSleep = 2
eNeedEat = 3
eNeedClean = 4
eNeedBathroom = 5

/* Morbus Teams */
eTeamHuman = 1
eTeamAlien = 2

/* Morbus Win Types */
eWinNone = 1
eWinHuman = 2
eWinAlien = 3

/* Morbus Weapon Types */
eWeaponMelee = 1
eWeaponHandgun = 2
eWeaponLight = 3
eWeaponRifle = 4
eWeaponHeavy = 5
eWeaponMisc = 6
eWeaponRole = 7
eWeaponMission = 8

/* GMOD Teams */
eTeamPlayers = 1
eTeamSpectators = 2
team.SetUp(eTeamPlayers, "Players", Color(200, 200, 200), true)
team.SetUp(eTeamSpectators, "Spectators", Color(255, 125, 0), true)
