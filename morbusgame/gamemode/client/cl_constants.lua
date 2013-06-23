---------------------------------LOCALIZATION
local math = math
local table = table
local umsg = umsg
local player = player
local timer = timer
local pairs = pairs
local umsg = umsg
local usermessage = usermessage
local file = file
---------------------------------------------


/*------------------------------------------------
MISSION TEXT
-------------------------------------------------*/

Mission = {}
Mission = {
{
	"None",
	"You have nothing to do right now"
},
{
	"Sleep",
	"If you don't sleep your going to passout",
	"Sleep is vital to your survival",
	"You need to sleep"
},
{
	"Eat",
	"If you don't eat your going to starve",
	"Your stromach is rumbling",
	"Your getting pretty hungry"
},
{
	"Clean",
	"Clean this shit off",
	"Your covered in shit",
	"You look like a mud monster"
},
{
	"Piss",
	"Your bowels yearn for a toilet",
	"The dam needs to be broken",
	"Brown bomb ready!"
},
{
	"Kill",
	"Hunt down the humans and infect or kill them"
}
}

function GetMissionTitle(number)
	return Mission[number+1][1]
end

function GetMissionText(number)
	return Mission[number][math.random(2,table.Count(Mission))]
end

/*------------------------------------------------
VGUI ELEMENTS
-------------------------------------------------*/




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
	ICON_WAIT, ICON_SLEEP, ICON_EAT, ICON_WASH, ICON_PISS, ICON_KILL
}

surface.CreateFont( "DSMass", {
	font 		= "DeadSpaceTitleFont",
	size 		= 64,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 64, 100, true, false, "DSMass")

surface.CreateFont( "DSHuge", {
	font 		= "DeadSpaceTitleFont",
	size 		= 42,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 42, 100, true, false, "DSHuge")

surface.CreateFont( "DSLarge", {
	font 		= "DeadSpaceTitleFont",
	size 		= 30,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 30, 100, true, false, "DSLarge")

surface.CreateFont( "DSSmall", {
	font 		= "DeadSpaceTitleFont",
	size 		= 18,
	weight 		= 100,
	antialias	= true
})

surface.CreateFont( "DSTiny2", {
	font 		= "DeadSpaceTitleFont",
	size 		= 16,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 18, 100, true, false, "DSSmall")

surface.CreateFont( "DSTiny", {
	font 		= "DeadSpaceTitleFont",
	size 		= 12,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 12, 100, true, false, "DSTiny")

surface.CreateFont( "DSMedium", {
	font 		= "DeadSpaceTitleFont",
	size 		= 22,
	weight 		= 100,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 22, 100, true, false, "DSMedium")

util.PrecacheSound("music/HL2_song8.mp3")
util.PrecacheSound("music/HL2_song19.mp3")
util.PrecacheSound("music/HL2_song33.mp3")
util.PrecacheSound("music/HL2_song30.mp3")

MUSIC = {"HL2_song8.mp3","HL2_song19.mp3","HL2_song33.mp3","HL2_song30.mp3"}
MUSIC_ALIEN_WIN = "Ravenholm_1.mp3"
MUSIC_HUMAN_WIN = "HL1_song11.mp3"

local healthcolors = {
  healthy = Color(0,255,0,255),
  hurt    = Color(170,230,10,255),
  wounded = Color(230,215,10,255),
  badwound= Color(255,140,0,255),
  death   = Color(255,0,0,255)
}

function util.HealthToString(health)
  if health > 90 then
     return "Healthy", healthcolors.healthy
  elseif health > 70 then
     return "Slightly Hurt", healthcolors.hurt
  elseif health > 45 then
     return "Wounded", healthcolors.wounded
  elseif health > 20 then
     return "Badly Wounded", healthcolors.badwound
  else
     return "Near Death", healthcolors.death
  end
end

local sanitycolors = {
  max  = Color(255,255,255,255),
  high = Color(255,240,135,255),
  med  = Color(245,220,60,255),
  low  = Color(255,170,0,255),
  min  = Color(255,120,0,255),
}

function util.SanityToString(sanity)
  if sanity > 890 then
     return "Perfectly Sane", sanitycolors.max
  elseif sanity > 800 then
     return "Mildy Psychotic", sanitycolors.high
  elseif sanity > 650 then
     return "Psychotic", sanitycolors.med
  elseif sanity > 500 then
     return "Insane", sanitycolors.low
  else
     return "Bat Shit Crazy", sanitycolors.min
  end
end