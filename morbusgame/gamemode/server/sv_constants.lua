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
/*---------------------------------
SOUNDS
-------------------------------------*/

Tuants = {}
Tuants.Female = {
"vo/npc/male01/thehacks01.wav",
"vo/npc/female01/question01.wav",
"vo/npc/female01/question02.wav",
"vo/npc/female01/question03.wav",
"vo/npc/female01/question04.wav",
"vo/npc/female01/question05.wav",
"vo/npc/female01/question06.wav",
"vo/npc/female01/question07.wav",
"vo/npc/female01/question08.wav",
"vo/npc/female01/question09.wav",
"vo/npc/female01/question10.wav",
"vo/npc/female01/question11.wav",
"vo/npc/female01/question12.wav",
"vo/npc/female01/question13.wav",
"vo/npc/female01/question14.wav",
"vo/npc/female01/question15.wav",
"vo/npc/female01/question16.wav",
"vo/npc/female01/question17.wav",
"vo/npc/female01/question18.wav",
"vo/npc/female01/question19.wav",
"vo/npc/female01/question20.wav",
"vo/npc/female01/question21.wav",
"vo/npc/female01/question22.wav",
"vo/npc/female01/question23.wav",
"vo/npc/female01/question24.wav",
"vo/npc/female01/question25.wav",
"vo/npc/female01/vanswer01.wav",
"vo/npc/female01/vanswer02.wav",
"vo/npc/female01/vanswer03.wav",
"vo/npc/female01/vanswer04.wav",
"vo/npc/female01/vanswer05.wav",
"vo/npc/female01/vanswer06.wav",
"vo/npc/female01/vanswer07.wav",
"vo/npc/female01/vanswer08.wav",
"vo/npc/female01/vanswer09.wav",
"vo/npc/female01/vanswer10.wav",
"vo/npc/female01/vanswer11.wav",
"vo/npc/female01/vanswer12.wav",
"vo/npc/female01/vanswer13.wav",
"vo/npc/female01/vanswer14.wav"
}
Tuants.Male = {
"vo/npc/male01/thehacks01.wav",
"vo/npc/male01/abouttime01.wav",
"vo/npc/male01/abouttime02.wav",
"vo/npc/male01/busy02.wav",
"vo/npc/male01/behindyou01.wav",
"vo/npc/male01/behindyou02.wav",
"vo/npc/male01/question01.wav",
"vo/npc/male01/question02.wav",
"vo/npc/male01/question03.wav",
"vo/npc/male01/question04.wav",
"vo/npc/male01/question05.wav",
"vo/npc/male01/question06.wav",
"vo/npc/male01/question07.wav",
"vo/npc/male01/question08.wav",
"vo/npc/male01/question09.wav",
"vo/npc/male01/question10.wav",
"vo/npc/male01/question11.wav",
"vo/npc/male01/question12.wav",
"vo/npc/male01/question13.wav",
"vo/npc/male01/question14.wav",
"vo/npc/male01/question15.wav",
"vo/npc/male01/question16.wav",
"vo/npc/male01/question17.wav",
"vo/npc/male01/question18.wav",
"vo/npc/male01/question19.wav",
"vo/npc/male01/question20.wav",
"vo/npc/male01/question21.wav",
"vo/npc/male01/question22.wav",
"vo/npc/male01/question23.wav",
"vo/npc/male01/vanswer01.wav",
"vo/npc/male01/vanswer02.wav",
"vo/npc/male01/vanswer03.wav",
"vo/npc/male01/vanswer04.wav",
"vo/npc/male01/vanswer05.wav",
"vo/npc/male01/vanswer06.wav",
"vo/npc/male01/vanswer07.wav",
"vo/npc/male01/vanswer08.wav",
"vo/npc/male01/vanswer09.wav",
"vo/npc/male01/vanswer10.wav",
"vo/npc/male01/vanswer11.wav",
"vo/npc/male01/vanswer12.wav",
"vo/npc/male01/vanswer13.wav",
"vo/npc/male01/vanswer14.wav"
}

/*------------------------------------------------
VOICE RESPONSES
-------------------------------------------------*/
Response = {}
Response.Male = {}
Response.Female = {}
Response.Male.Yes = {
"vo/npc/male01/fantastic01.wav",
"vo/npc/male01/yeah02.wav",
"vo/npc/male01/gordead_ques16.wav",
"vo/npc/male01/okimready01.wav",
"vo/npc/male01/nice.wav",
"vo/npc/male01/answer01.wav",
"vo/npc/male01/answer02.wav",
"vo/npc/male01/answer03.wav",
"vo/npc/male01/answer04.wav",
"vo/npc/male01/answer05.wav",
"vo/npc/male01/answer06.wav",
"vo/npc/male01/answer07.wav",
"vo/npc/male01/answer08.wav",
"vo/npc/male01/answer09.wav",
"vo/npc/male01/answer10.wav",
"vo/npc/male01/answer11.wav",
"vo/npc/male01/answer12.wav",
"vo/npc/male01/answer13.wav",
"vo/npc/male01/answer14.wav",
"vo/npc/male01/answer15.wav",
"vo/npc/male01/answer16.wav",
"vo/npc/male01/answer17.wav",
"vo/npc/male01/answer18.wav",
"vo/npc/male01/answer19.wav",
"vo/npc/male01/answer20.wav",
"vo/npc/male01/answer21.wav",
"vo/npc/male01/answer22.wav",
"vo/npc/male01/answer23.wav",
"vo/npc/male01/answer24.wav",
"vo/npc/male01/answer25.wav",
"vo/npc/male01/answer26.wav",
"vo/npc/male01/answer27.wav",
"vo/npc/male01/answer28.wav",
"vo/npc/male01/answer29.wav",
"vo/npc/male01/answer30.wav",
"vo/npc/male01/answer31.wav",
"vo/npc/male01/answer32.wav",
"vo/npc/male01/answer33.wav",
"vo/npc/male01/answer34.wav",
"vo/npc/male01/answer35.wav",
"vo/npc/male01/answer36.wav",
"vo/npc/male01/answer37.wav",
"vo/npc/male01/answer38.wav",
"vo/npc/male01/answer39.wav",
"vo/npc/male01/answer40.wav"

}
Response.Female.Yes = {
"vo/npc/female01/fantastic01.wav",
"vo/npc/female01/yeah02.wav",
"vo/npc/female01/gordead_ques16.wav",
"vo/npc/female01/okimready01.wav",
"vo/npc/female01/nice02.wav",
"vo/npc/female01/finally.wav",
"vo/npc/female01/gordead_ans15.wav",
"vo/npc/female01/answer01.wav",
"vo/npc/female01/answer02.wav",
"vo/npc/female01/answer03.wav",
"vo/npc/female01/answer04.wav",
"vo/npc/female01/answer05.wav",
"vo/npc/female01/answer06.wav",
"vo/npc/female01/answer07.wav",
"vo/npc/female01/answer08.wav",
"vo/npc/female01/answer09.wav",
"vo/npc/female01/answer10.wav",
"vo/npc/female01/answer11.wav",
"vo/npc/female01/answer12.wav",
"vo/npc/female01/answer13.wav",
"vo/npc/female01/answer14.wav",
"vo/npc/female01/answer15.wav",
"vo/npc/female01/answer16.wav",
"vo/npc/female01/answer17.wav",
"vo/npc/female01/answer18.wav",
"vo/npc/female01/answer19.wav",
"vo/npc/female01/answer20.wav",
"vo/npc/female01/answer21.wav",
"vo/npc/female01/answer22.wav",
"vo/npc/female01/answer23.wav",
"vo/npc/female01/answer24.wav",
"vo/npc/female01/answer25.wav",
"vo/npc/female01/answer26.wav",
"vo/npc/female01/answer27.wav",
"vo/npc/female01/answer28.wav",
"vo/npc/female01/answer29.wav",
"vo/npc/female01/answer30.wav",
"vo/npc/female01/answer31.wav",
"vo/npc/female01/answer32.wav",
"vo/npc/female01/answer33.wav",
"vo/npc/female01/answer34.wav",
"vo/npc/female01/answer35.wav",
"vo/npc/female01/answer36.wav",
"vo/npc/female01/answer37.wav",
"vo/npc/female01/answer38.wav",
"vo/npc/female01/answer39.wav",
"vo/npc/female01/answer40.wav"
}
Response.Female.KillAlien = {
"vo/npc/female01/yeah02.wav",
"vo/npc/female01/wetrustedyou01.wav",
"vo/npc/female01/thislldonicely01.wav",
"vo/npc/female01/likethat.wav",
"vo/npc/female01/gotone01.wav",
"vo/npc/female01/gotone02.wav",
"vo/npc/female01/answer40.wav",
}

Response.Male.KillAlien = {
"vo/npc/male01/yeah02.wav",
"vo/npc/male01/nice.wav",
"vo/npc/male01/wetrustedyou01.wav",
"vo/npc/male01/likethat.wav",
"vo/npc/male01/gotone01.wav",
"vo/npc/male01/gotone02.wav",
"vo/npc/male01/vanswer04.wav",
"vo/npc/male01/answer39.wav",
"vo/npc/male01/answer40.wav",
}

/*-------------------------------------------------
ALIEN SOUNDS
-----------------------------------------*/
Sounds = {}

sound.Add({
    name =          "need.sleeping",
    channel =       CHAN_STATIC,
    volume =        1.0,
    sound =             "morbus/sleeping.wav"
})
sound.Add({
    name =          "need.eating",
    channel =       CHAN_STATIC,
    volume =        1.0,
    sound =             "morbus/eating.wav"
})
sound.Add({
    name =          "need.shower",
    channel =       CHAN_STATIC,
    volume =        1.0,
    sound =             "morbus/shower.wav"
})
sound.Add({
    name =          "need.peeing",
    channel =       CHAN_STATIC,
    volume =        1.0,
    sound =             "morbus/peeing.wav"
})

Sounds.Mission = {Sound("need.sleeping"),Sound("need.eating"),Sound("need.shower"),Sound("need.peeing")}
//1= sleep 2= eat 3= shower 4=pee

Sounds.Male = {}
Sounds.Male.Pain = {
}

local mpain = {
	"vo/npc/male01/imhurt01.wav",
	"vo/npc/male01/imhurt02.wav",
	"vo/npc/male01/ow01.wav",
	"vo/npc/male01/ow02.wav",
	"vo/npc/male01/pain01.wav",
	"vo/npc/male01/pain02.wav",
	"vo/npc/male01/pain03.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/male01/pain05.wav",
	"vo/npc/male01/pain06.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav"}

for k,v in pairs(mpain) do
	sound.Add({
    name =          "male_pain"..k,
    channel =       CHAN_USER_BASE+10,
    volume =        0.7,
    sound =             v
	})
	table.insert(Sounds.Male.Pain,Sound("male_pain"..k))
end

local fpain = {
	"vo/npc/female01/imhurt01.wav",
	"vo/npc/female01/imhurt02.wav",
	"vo/npc/female01/ow01.wav",
	"vo/npc/female01/ow02.wav",
	"vo/npc/female01/pain01.wav",
	"vo/npc/female01/pain02.wav",
	"vo/npc/female01/pain03.wav",
	"vo/npc/female01/pain04.wav",
	"vo/npc/female01/pain05.wav",
	"vo/npc/female01/pain06.wav",
	"vo/npc/female01/pain07.wav",
	"vo/npc/female01/pain08.wav",
	"vo/npc/female01/pain09.wav",
}

Sounds.Female = {}
Sounds.Female.Pain = {
}

for k,v in pairs(fpain) do
	sound.Add({
    name =          "female_pain"..k,
    channel =       CHAN_USER_BASE+10,
    volume =        0.7,
    sound =             v
	})
	table.insert(Sounds.Female.Pain,Sound("female_pain"..k))
end

local anorm = {
"pinky/sight22.wav",
"pinky/sight23.wav",
}

Sounds.Alien = {}
Sounds.Alien.Normal = {}

for k,v in pairs(anorm) do
	sound.Add({
    name =          "alien_norm"..k,
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             v
	})
	table.insert(Sounds.Alien.Normal,Sound("alien_norm"..k))
end

local apain = {
	"horror/pain1.wav",
	"horror/pain2.wav",
	"horror/pain3.wav",
	"horror/pain4.wav",
}


Sounds.Alien.Pain = {}

for k,v in pairs(apain) do
	sound.Add({
    name =          "alien_pain"..k,
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             v
	})
	table.insert(Sounds.Alien.Pain,Sound("alien_pain"..k))
end

sound.Add({
    name =          "alien.transform2",
    channel =       CHAN_STATIC,
    volume =        1.0,
    sound =             "npc/stalker/go_alert2a.wav"
	})

Sounds.Brood = {}
Sounds.Brood.Transform = Sound("alien.transform2")
Sounds.Brood.Breath = {}

local bbreath = {
"pinky/idle1.wav",
"pinky/idle2.wav",
"pinky/idle3.wav",
"pinky/idle4.wav"
}

for k,v in pairs(bbreath) do
	sound.Add({
    name =          "alien_breath"..k,
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             v
	})
	table.insert(Sounds.Brood.Breath,Sound("alien_breath"..k))
end

Sounds.Brood.Pain = {}

local bpain = {
	"horror/pain1.wav",
	"horror/pain2.wav",
	"horror/pain3.wav",
	"horror/pain4.wav",
}

for k,v in pairs(bpain) do
	sound.Add({
    name =          "alien_pain"..k,
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             v
	})
	table.insert(Sounds.Brood.Pain,Sound("alien_pain"..k))
end

Sounds.Pickup = { --unused atm
	"morbus/pickup1.wav",
	"morbus/pickup2.wav",
	"morbus/pickup3.wav"
}

function GetRoleName(role)
	if (role == 1) then return "HUMAN"
	elseif (role == 2) then return "BROOD ALIEN"
	elseif (role == 3) then return "SWARM ALIEN" end

	return "HUMAN"
end