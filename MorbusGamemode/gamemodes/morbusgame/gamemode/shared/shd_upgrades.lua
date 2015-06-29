/*------------------------------------------------
SO MANY UPGRADES BITCHES
-------------------------------------------------*/


UPGRADE = {} --To be used as ENUM
UPGRADES = {} -- Used to store upgrade data
UPGRADE_TREES = {} -- Used to store upgrade tree

-- I do it this way cause it looks nicer to me
UPGRADE_TREES[1] = "Offense"
UPGRADE_TREES[2] = "Defense"
UPGRADE_TREES[3] = "Utility"

-- The tree will be refrenced via number or enum
TREE_OFFENSE = 1
TREE_DEFENSE = 2
TREE_UTILITY = 3

-- The upgrades
-- Upgrade Icons created by: Demonkush
UPGRADE.CLAWS = 1
UPGRADE.CLAW_AMOUNT = 1
UPGRADES[1] = {
	Title="Sharp Claws",
	Tree=TREE_OFFENSE,
	Desc="Increases attack damage by "..UPGRADE.CLAW_AMOUNT.." per level",
	Icon= "vgui/morbus/brood/icon_brood_claws.png",
	MaxLevel=8,
	Tier=1
}


UPGRADE.CARAPACE = 2
UPGRADE.CARAPACE_AMOUNT = 6
UPGRADES[2] = {
	Title="Hardened Carapace",
	Tree=TREE_DEFENSE,
	Desc="Decreases damage taken by "..UPGRADE.CARAPACE_AMOUNT.."% per level",
	Icon="vgui/morbus/brood/icon_brood_carapace.png",
	MaxLevel=5,
	Tier=1
}


UPGRADE.SPRINT = 3
UPGRADE.SPRINT_AMOUNT = 18
UPGRADES[3] = {
	Title="Adrenaline Glands",
	Tree=TREE_UTILITY,
	Desc="Increases the speed of your sprint by "..UPGRADE.SPRINT_AMOUNT.." per level",
	Icon="vgui/morbus/brood/icon_brood_adrenaline.png",
	MaxLevel=5,
	Tier=1
}


UPGRADE.EXHAUST = 4
UPGRADE.EXHAUST_AMOUNT = 45
UPGRADES[4] = {
	Title="Exhuastion",
	Tree=TREE_OFFENSE,
	Desc="Decreases the time a human has to complete their need by "..UPGRADE.EXHAUST_AMOUNT.." seconds every attack, per level.",
	Icon="vgui/morbus/brood/icon_brood_exhaust.png",
	MaxLevel=3,
	Tier=1
}


UPGRADE.SDEFENSE = 5
UPGRADE.SDEFENSE_AMOUNT = 30
UPGRADES[5] = {
	Title="Enforced Scales",
	Tree=TREE_DEFENSE,
	Desc="Reduces damage from pistols and SMGs by "..UPGRADE.SDEFENSE_AMOUNT.."%",
	Icon="vgui/morbus/brood/icon_brood_scales.png",
	MaxLevel=1,
	Tier=1
}


UPGRADE.FALL = 6
UPGRADE.FALL_AMOUNT = 33
UPGRADES[6] = {
	Title="Shock Absorbing Tissue",
	Tree=TREE_UTILITY,
	Desc="Decreases fall damage by "..UPGRADE.FALL_AMOUNT.."% per level",
	Icon="vgui/morbus/brood/icon_brood_shock.png",
	MaxLevel=3,
	Tier=1
}


UPGRADE.ATKSPEED = 7
UPGRADE.ATKSPEED_AMOUNT = 10
UPGRADES[7] = {
	Title="Relentless Attack",
	Tree=TREE_OFFENSE,
	Desc="Your attack speed increaes by "..UPGRADE.ATKSPEED_AMOUNT.."% per level",
	Icon="vgui/morbus/brood/icon_brood_relentless.png",
	MaxLevel=4,
	Tier=2
}


UPGRADE.REGEN = 8
UPGRADE.REGEN_AMOUNT = 1
UPGRADES[8] = {
	Title="Regenerative Tissue",
	Tree=TREE_DEFENSE,
	Desc="Restores "..UPGRADE.REGEN_AMOUNT.."*(LEVEL) health per second when in alien form",
	Icon="vgui/morbus/brood/icon_brood_regen2.png",
	MaxLevel=4,
	Tier=1
}


UPGRADE.JUMP = 9
UPGRADE.JUMP_AMOUNT = 110
UPGRADES[9] = {
	Title="Strengthened Legs",
	Tree=TREE_UTILITY,
	Desc="Increases jump power by "..UPGRADE.JUMP_AMOUNT.." per level",
	Icon="vgui/morbus/brood/icon_brood_jump.png",
	MaxLevel=2,
	Tier=2
}


UPGRADE.LIFESTEAL = 10
UPGRADE.LIFESTEAL_AMOUNT = 5
UPGRADES[10] = {
	Title="Blood Thirst",
	Tree=TREE_OFFENSE,
	Desc="Regenerates "..UPGRADE.LIFESTEAL_AMOUNT.."*(LEVEL) HP everytime you attack a human",
	Icon="vgui/morbus/brood/icon_brood_blood.png",
	MaxLevel=3,
	Tier=2
}


UPGRADE.HDEFENSE = 11
UPGRADE.HDEFENSE_AMOUNT = 25
UPGRADES[11] = {
	Title="Enforced Skeleton",
	Tree=TREE_DEFENSE,
	Desc="Reduces damage from Rifles and Shotguns by "..UPGRADE.HDEFENSE_AMOUNT.."%",
	Icon="vgui/morbus/brood/icon_brood_enforced.png",
	MaxLevel=1,
	Tier=2
}


UPGRADE.BREATH = 12
UPGRADES[12] = {
	Title="Softened Breath",
	Tree=TREE_UTILITY,
	Desc="Mutes the sound of your breathing",
	Icon="vgui/morbus/brood/icon_brood_mute.png",
	MaxLevel=1,
	Tier=2
}


UPGRADE.SMELLRANGE = 13
UPGRADE.SMELLRANGE_AMOUNT = 1000
UPGRADES[13] = {
	Title="Enhanced Smell",
	Tree=TREE_OFFENSE,
	Desc="Increases the range from which you can smell humans by "..UPGRADE.SMELLRANGE_AMOUNT.." units per level",
	Icon="vgui/morbus/brood/icon_brood_smell.png",
	MaxLevel=2,
	Tier=2
}


UPGRADE.HEALTH = 14
UPGRADE.HEALTH_AMOUNT = 40
UPGRADES[14] = {
	Title="Endurance",
	Tree=TREE_DEFENSE,
	Desc="Increases maximum health by "..UPGRADE.HEALTH_AMOUNT.." per level",
	Icon="vgui/morbus/brood/icon_brood_regen.png",
	MaxLevel=3,
	Tier=2
}


UPGRADE.INVISIBLE = 15
UPGRADES[15] = {
	Title="Adaptive Carapace",
	Tree=TREE_UTILITY,
	Desc="When you stand still for 6-(LEVEL) seconds you become invisible.",
	Icon="vgui/morbus/brood/icon_brood_question.png",
	MaxLevel=3,
	Tier=2
}

UPGRADE.SCREAM = 16
UPGRADES[16] = {
	Title="Upgraded Screech",
	Tree=TREE_OFFENSE,
	Desc="When you transform into alien form, blinds and blurs nearby humans vision.",
	Icon="vgui/morbus/brood/icon_brood_screech.png",
	MaxLevel=1,
	Tier=1
}