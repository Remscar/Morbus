--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- MISSION TEXT
Mission = {}
Mission = {
	{
		"None",
		"You have nothing to do right now".
	},
	{
		"Sleep",
		"If you don't sleep your going to passout",
		"Sleep is vital to your survival",
		"You need to sleep".
	},
	{
		"Eat",
		"If you don't eat your going to starve",
		"Your stromach is rumbling",
		"Your getting pretty hungry".
	},
	{
		"Clean",
		"Clean this shit off",
		"Your covered in shit",
		"You look like a mud monster".
	},
	{
		"Piss",
		"Your bowels yearn for a toilet",
		"The dam needs to be broken",
		"Brown bomb ready!".
	},
	{
		"Kill",
		"Hunt down the humans and infect or kill them".
	}
}
-- VGUI ELEMENTS
ICON_WEIGHT = surface.GetTextureID("vgui/poids")
RING = surface.GetTextureID( "redring" )
VEINS = surface.GetTextureID( "veins" )
ICON_KILL = surface.GetTextureID("vgui/killneed")
ICON_WASH = surface.GetTextureID("vgui/wash")
ICON_PISS = surface.GetTextureID("vgui/wc")
ICON_EAT = surface.GetTextureID("vgui/eat")
ICON_SLEEP = surface.GetTextureID("vgui/sleep")
ICON_WAIT = surface.GetTextureID("vgui/waitneed")
ICON_NEED = surface.GetTextureID("vgui/need_target")

MissionIcon = {
	ICON_WAIT,
	ICON_SLEEP,
	ICON_EAT,
	ICON_WASH,
	ICON_PISS,
	ICON_KILL,
}

surface.CreateFont( "DSMass", {
	font		=	"DeadSpaceTitleFont",
	size		=	64,
	weight		=	100,
	antialias	=	true,
})
surface.CreateFont( "DSHuge", {
	font		=	"DeadSpaceTitleFont",
	size		=	42,
	weight		=	100,
	antialias	=	true,
})
surface.CreateFont( "DSLarge", {
	font		=	"DeadSpaceTitleFont",
	size		=	30,
	weight		=	100,
	antialias	=	true,
})
surface.CreateFont( "DSSmall", {
	font		=	"DeadSpaceTitleFont",
	size		=	18,
	weight		=	100,
	antialias	=	true,
})

surface.CreateFont( "DSTiny2", {
	font		=	"DeadSpaceTitleFont",
	size		=	16,
	weight		=	100,
	antialias	=	true,
})
surface.CreateFont( "DSTiny", {
	font		=	"DeadSpaceTitleFont",
	size		=	12,
	weight		=	100,
	antialias	=	true,
})
surface.CreateFont( "DSMedium", {
	font		=	"DeadSpaceTitleFont",
	size		=	22,
	weight		=	100,
	antialias	=	true,
})
MUSIC = {
	"HL2_song8.mp3",
	"HL2_song19.mp3",
	"HL2_song33.mp3",
	"HL2_song30.mp3",
}
MUSIC_ALIEN_WIN = "Ravenholm_1.mp3"
MUSIC_HUMAN_WIN = "HL1_song11.mp3"

util.PrecacheSound("music/HL2_song8.mp3")
util.PrecacheSound("music/HL2_song19.mp3")
util.PrecacheSound("music/HL2_song33.mp3")
util.PrecacheSound("music/HL2_song30.mp3")

function GetMissionTitle(number)
	return Mission[number+1][1]
end

function GetMissionText(number)
	return Mission[number][math.random(2,table.Count(Mission))]
end
