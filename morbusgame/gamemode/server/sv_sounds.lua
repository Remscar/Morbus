--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- SOUNDS
sound.Add({
	name    = "need.sleeping",
	channel = CHAN_STATIC,
	volume  = 1.0,
	sound   = "morbus/sleeping.wav",
})
sound.Add({
	name    = "need.eating",
	channel = CHAN_STATIC,
	volume  = 1.0,
	sound   = "morbus/eating.wav",
})
sound.Add({
	name    = "need.shower",
	channel = CHAN_STATIC,
	volume  = 1.0,
	sound   = "morbus/shower.wav",
})
sound.Add({
	name    = "need.peeing",
	channel = CHAN_STATIC,
	volume  = 1.0,
	sound   = "morbus/peeing.wav",
})
sound.Add({
	name    = "brood.transform",
	channel = CHAN_STATIC,
	volume  = 1.0,
	sound   = "npc/stalker/go_alert2a.wav",
})

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
	"vo/npc/female01/vanswer14.wav",
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
	"vo/npc/male01/vanswer14.wav",
}
Response = {}
Response.Male = {}
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
	"vo/npc/male01/answer40.wav",
}
Response.Female = {}
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
	"vo/npc/female01/answer40.wav",
}
Sounds = {}
Sounds.Mission = {
	Sound("need.sleeping"),
	Sound("need.eating"),
	Sound("need.shower"),
	Sound("need.peeing"),
}
Sounds.Male = {}
Sounds.Male.Pain = {}
Sounds.Male.KillAlien = {}
Sounds.Male.Death = {}
Sounds.Female = {}
Sounds.Female.Pain = {}
Sounds.Female.KillAlien = {}
Sounds.Female.Death = {}
Sounds.Swarm = {}
Sounds.Swarm.Normal = {}
Sounds.Swarm.Pain = {}
Sounds.Swarm.Death = {}
Sounds.Brood = {}
Sounds.Brood.Transform = Sound("brood.transform")
Sounds.Brood.Breath = {}
Sounds.Brood.Pain = {}
Sounds.Brood.Death = {}

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
	"vo/npc/male01/pain09.wav",
}
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
local apain = {
	"horror/pain1.wav",
	"horror/pain2.wav",
	"horror/pain3.wav",
	"horror/pain4.wav",
}
local bpain = {
	"horror/pain1.wav",
	"horror/pain2.wav",
	"horror/pain3.wav",
	"horror/pain4.wav",
}
local mkalien = {
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
local fkalien = {
	"vo/npc/female01/yeah02.wav",
	"vo/npc/female01/wetrustedyou01.wav",
	"vo/npc/female01/thislldonicely01.wav",
	"vo/npc/female01/likethat.wav",
	"vo/npc/female01/gotone01.wav",
	"vo/npc/female01/gotone02.wav",
	"vo/npc/female01/answer40.wav",
}
local dmale = {
	"player/death1.wav",
	"player/death2.wav",
	"player/death3.wav",
	"player/death4.wav",
	"player/death5.wav",
	"player/death6.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav",
	"vo/npc/male01/pain04.wav",
	"vo/npc/Barney/ba_pain06.wav",
	"vo/npc/Barney/ba_pain07.wav",
	"vo/npc/Barney/ba_pain09.wav",
	"vo/npc/Barney/ba_ohshit03.wav", --heh
	"vo/npc/Barney/ba_no01.wav",
	"vo/npc/male01/no02.wav",
	"hostage/hpain/hpain1.wav",
	"hostage/hpain/hpain2.wav",
	"hostage/hpain/hpain3.wav",
	"hostage/hpain/hpain4.wav",
	"hostage/hpain/hpain5.wav",
	"hostage/hpain/hpain6.wav",
}
local dfale ={
	"vo/npc/female01/pain01",
	"vo/npc/female01/pain02",
	"vo/npc/female01/pain03",
	"vo/npc/female01/pain04",
	"vo/npc/female01/pain05",
	"vo/npc/female01/pain06",
	"vo/npc/female01/pain07",
	"vo/npc/female01/pain08",
	"vo/npc/female01/pain09",
}
local dbrood = {
	"npc/zombie_poison/pz_die2.wav",
	"npc/zombie/zombie_pain2.wav",
	"npc/zombie/zombie_pain6.wav",
	"npc/headcrab_fast/die2.wav",
}
local dswarm = {
	"horror/die1.wav",
}
local anorm = {
	"pinky/sight22.wav",
	"pinky/sight23.wav",
}
local bbreath = {
	"pinky/idle1.wav",
	"pinky/idle2.wav",
	"pinky/idle3.wav",
	"pinky/idle4.wav",
}

for k,v in pairs(mpain) do
	sound.Add({
		name    = "male_pain"..k,
		channel = CHAN_USER_BASE+10,
		volume  = 0.7,
		sound   = v
	})
	table.insert(Sounds.Male.Pain,Sound("male_pain"..k))
end
for k,v in pairs(fpain) do -- FEMALE PAIN
	sound.Add({
		name    = "female_pain"..k,
		channel = CHAN_USER_BASE+10,
		volume  = 0.7,
		sound   = v
	})
	table.insert(Sounds.Female.Pain,Sound("female_pain"..k))
end
for k,v in pairs(apain) do -- SWARM ALIEN PAIN
	sound.Add({
		name    = "swarm_pain"..k,
		channel = CHAN_USER_BASE+2,
		volume  = 1.0,
		sound   = v
	})
	table.insert(Sounds.Swarm.Pain,Sound("swarm_pain"..k))
end
for k,v in pairs(bpain) do -- BROOD ALIN PAIN
	sound.Add({
		name    = "brood_pain"..k,
		channel = CHAN_USER_BASE+1,
		volume  = 1.0,
		sound   = v
	})
	table.insert(Sounds.Brood.Pain,Sound("brood_pain"..k))
end
for k,v in pairs(mkalien) do -- MALE KILL ALIEN
	sound.Add({
		name    = "male_kill_alien."..k,
		channel = CHAN_USER_BASE+2,
		volume  = 0.7,
		sound   = v
	})
	table.insert(Sounds.Male.KillAlien,Sound("male_kill_alien."..k))
end
for k,v in pairs(fkalien) do -- FEMALE KILL ALIEN
	sound.Add({
		name    = "female_kill_alien."..k,
		channel = CHAN_USER_BASE+2,
		volume  = 0.7,
		sound   = v
	})
	table.insert(Sounds.Female.KillAlien,Sound("female_kill_alien."..k))
end
for k,v in pairs(dmale) do -- MALE DEATH
   sound.Add({
		name    = "male_death."..k,
		channel = CHAN_USER_BASE+1,
		volume  = 1.0,
		sound   = v
   })
   table.insert(Sounds.Male.Death,Sound("male_death."..k))
end
for k,v in pairs(dfale) do -- FEMALE DEATH
   sound.Add({
		name    = "female_death."..k,
		channel = CHAN_USER_BASE+1,
		volume  = 1.0,
		sound   = v
   })
   table.insert(Sounds.Female.Death,Sound("female_death."..k))
end
for k,v in pairs(dswarm) do -- SWARM ALIEN DEATH
   sound.Add({
		name    = "swarm_death."..k,
		channel = CHAN_USER_BASE+1,
		volume  = 1.0,
		sound   = v
   })
   table.insert(Sounds.Swarm.Death,Sound("swarm_death."..k))
end
for k,v in pairs(dbrood) do -- BROOD ALIN DEATH
   sound.Add({
		name    = "brood_death."..k,
		channel = CHAN_USER_BASE+1,
		volume  = 1.0,
		sound   = v
   })
   table.insert(Sounds.Brood.Death,Sound("brood_death."..k))
end

for k,v in pairs(anorm) do -- SWARM ALIEN GROAN
	sound.Add({
		name    = "salien_norm"..k,
		channel = CHAN_USER_BASE+3,
		volume  = 1.0,
		sound   = v
	})
	table.insert(Sounds.Swarm.Normal,Sound("salien_norm"..k))
end
for k,v in pairs(bbreath) do -- BROOD ALIN BREATHING
	sound.Add({
		name    = "brood_breath"..k,
		channel = CHAN_USER_BASE+1,
		volume  = 1.0,
		sound   = v
	})
	table.insert(Sounds.Brood.Breath,Sound("brood_breath"..k))
end
