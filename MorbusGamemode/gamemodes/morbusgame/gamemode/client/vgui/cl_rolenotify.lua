-- Little notification + hint at the start of the round

ROLEHELP = {}
ROLEHELP[ROLE_HUMAN] = {}
ROLEHELP[ROLE_BROOD] = {}
ROLEHELP[ROLE_SWARM] = {}

ROLEHELP[ROLE_HUMAN].Title = "You are a Human"
ROLEHELP[ROLE_HUMAN].Bullets = {"There is an Alien among you. Find it and kill it.", "You are stronger with others, but be careful who you trust.", "You will have to satisfy certain needs occasionaly or you will slowly die!","These needs are eating, sleeping, bathing, and pissing.", "Weapons slow you down, so choose your loadout carefully."}

ROLEHELP[ROLE_BROOD].Title = "You are a Brood Alien"
ROLEHELP[ROLE_BROOD].Bullets = {"Kill humans using your \"Alien Form\" weapon to turn them into Brood Aliens.", "You do reduced damage with firearms!", "Take out humans which are alone first, they are the easiest targets.", "You are disguised as a human when you use any other weapon except your Alien Form", "Press C {Context Menu} to open your upgrade menu!","If all Brood Aliens die, Humans win."}

ROLEHELP[ROLE_SWARM].Title = "You are a Swarm Alien"
ROLEHELP[ROLE_SWARM].Bullets = {"Attack the humans!", "You are very weak alone so attack with other Swarm Aliens.", "You have limited respawns so be careful!","You gain respawns for each Brood Alien created!"}

surface.CreateFont("hint_font", {font = "Verdana",
                                size = 21,
                                weight = 400,
                                outline = true
                              	})
surface.CreateFont("hint_font_small", {font = "Verdana",
                                size = 18,
                                weight = 400,
                                outline = true
                              	})

function CreateRoleHelp(role)
	if GetConVar("morbus_hide_rolehint"):GetBool() then return end
	local pnl = vgui.Create("Panel")
	pnl:SetSize(ScrW(),700)
	pnl:Center()
	pnl.DieTime = CurTime() + 30
	function pnl:Think()
		if self.DieTime < CurTime() then
			self:Remove()
		end
	end
	pnl:SetMouseInputEnabled(false)

	local ttl = vgui.Create("DLabel",pnl)
	ttl:SetText(ROLEHELP[role].Title)
	ttl:SetFont("DSHuge")
	ttl:SizeToContents()
	ttl:SetColor(Color(255,255,255,180))
	surface.SetFont("DSHuge")
	local w = surface.GetTextSize(ROLEHELP[role].Title)
	ttl:SetPos(pnl:GetWide()/2 - w/2,20)
	ttl:SetMouseInputEnabled(false)
	
	for i=1, #ROLEHELP[role].Bullets do
		local blt = vgui.Create("DLabel",pnl)
		blt:SetText(ROLEHELP[role].Bullets[i])
		blt:SetFont("hint_font")
		blt:SizeToContents()
		blt:SetColor(Color(255,255,255,180))
		surface.SetFont("hint_font")
		blt:SetMouseInputEnabled(false)
		local w = surface.GetTextSize(ROLEHELP[role].Bullets[i])
		blt:SetPos(pnl:GetWide()/2 - w/2,40 + 25*i)
	end

	local blt = vgui.Create("DLabel",pnl)
	blt:SetText("Read the guide in F1 for more help!")
	blt:SetFont("hint_font_small")
	blt:SizeToContents()
	blt:SetColor(Color(255,255,255,180))
	surface.SetFont("hint_font_small")
	local w = surface.GetTextSize("Read the guide in F1 for more help!")
	blt:SetPos(pnl:GetWide()/2 - w/2,65 + 25*#ROLEHELP[role].Bullets)
	blt:SetMouseInputEnabled(false)

end