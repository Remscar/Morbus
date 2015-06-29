// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
UPGRADE_SIZE_MENU = 64
UPGRADE_MENU_PADDING = 14
local base

--for k,v in pairs(player.GetAll()) do MsgN(v:Nick()..": "..v.Evo_Points) end


function CreateUpgradesMenu()
	if pUpgradesMenu then
		if pUpgradesMenu:IsValid() then pUpgradesMenu:Remove() end
	end

	base = vgui.Create("DFrame")
	base:SetSize(800, 350)
	base:SetPos(ScrW()/2-400,300)
	base:SetVisible(true)
	base:MakePopup()
	base:SetTitle("Evolution Menu")
	function base:Paint()
		derma.SkinHook( "Paint", "Frame", self, 800, 350 )
		draw.RoundedBox( 8, 0, 0, base:GetWide(), base:GetTall(), Color( 55, 85, 55, 185 ) )
		draw.SimpleTextOutlined("Upgrade Points: "..Morbus.Evo_Points,"DefaultLarge",base:GetWide()/2,20,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	end

	pUpgradesMenu = base
	pUpgradesMenu["UPS"] = {}
	pUpgradesMenu["UPS2"] = {}

	UpdateUpgradesMenu()

end

function UpdateUpgradesMenu()

	local up = {}
	for k,v in pairs(UPGRADE_TREES) do

		if pUpgradesMenu["UPS"][k] then
			for i,b	in pairs(pUpgradesMenu["UPS"][k]) do
				b:Remove()
			end
			for i,b	in pairs(pUpgradesMenu["UPS2"][k]) do
				b:Remove()
			end
		end

		pUpgradesMenu["UPS"][k] = {}
		pUpgradesMenu["UPS2"][k] = {}

		up[k] = {}
		up[k].Width = 0
		up[k].ByTier = {}
		
	end
	
	local tiers={}
	for k,v in pairs(UPGRADES) do

		if !up[v.Tree].ByTier[v.Tier] then up[v.Tree].ByTier[v.Tier] = {} end
		if !tiers[v.Tree] then tiers[v.Tree] = {} end
		if !tiers[v.Tree][v.Tier] then tiers[v.Tree][v.Tier] = 0 end
			
		table.insert(up[v.Tree].ByTier[v.Tier],k)
			
		tiers[v.Tree][v.Tier] = tiers[v.Tree][v.Tier] + UPGRADE_SIZE_MENU + UPGRADE_MENU_PADDING
		if tiers[v.Tree][v.Tier] > up[v.Tree].Width then
			up[v.Tree].Width = tiers[v.Tree][v.Tier]
		end

	end
	

	-- DIVIDERS
	local curx,cury=(UPGRADE_MENU_PADDING*2),30
	for tree,t in pairs(up) do

		curx = curx + t.Width
		
		if tree != 3 then
			local div = vgui.Create("DPanel",base)
			div:SetPos(curx,cury)
			div:SetSize(1,(base:GetTall()*0.9)-cury)
		end
		
		up[tree].StartX = curx
		
		curx = curx + (UPGRADE_MENU_PADDING*2)
	end

	for tree,info in pairs(up) do
		--local tree = info.Tree

		local cury = 30
		-- Label
		local start,wid = info.StartX,info.Width
		
		local column_center = (wid*0.5)+(start-wid)

		local tw,th = util.StringSize("Trebuchet24",UPGRADE_TREES[tree])
		
		local lab = vgui.Create("DLabel",base)
		lab:SetPos(column_center-(tw*0.5),cury)
		lab:SetFont("Trebuchet24")
		lab:SetTextColor(Color(255,255,255,255))
		lab:SetText(UPGRADE_TREES[tree])
		lab:SizeToContents()
		
		cury = cury + (th*1.5)
		-- Fill
		local mtiers = #info.ByTier
		
		for i=1,mtiers do
			local ups = table.Count(info.ByTier[i]) -- How many upgrades are in this tier
			
			local tiersize = (UPGRADE_MENU_PADDING + UPGRADE_SIZE_MENU) * ups -- How much space this tier takes up
			
			local tier_start = column_center - (UPGRADE_SIZE_MENU*(ups/2)) - (UPGRADE_MENU_PADDING*(ups/2))
			
			local curx = tier_start
			for j=1,ups do
				local obj = vgui.Create("DPanel",base)
				obj:SetPos(curx,cury)
				obj:SetSize(UPGRADE_SIZE_MENU,UPGRADE_SIZE_MENU)
				obj.Tree = tree
				obj.Upgrade = info.ByTier[i][j]
				obj.Tier = i
				function obj:Paint()
					if not _TEX then _TEX = {} end
					if not _TEX[UPGRADES[self.Upgrade].Icon] then _TEX[UPGRADES[self.Upgrade].Icon] = Material(UPGRADES[self.Upgrade].Icon) end
					
					surface.SetMaterial(_TEX[UPGRADES[self.Upgrade].Icon])
					surface.SetDrawColor(255,255,255,255)
					surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
					
					if (self.Tier!=1) and (LocalPlayer():GetTierPoints(self.Tree,self.Tier-1)<UPGRADE_TIER_REQUIREMENT) then
						surface.SetMaterial(Material("vgui/morbus/brood/icon_brood_locked2.png"))
						surface.SetDrawColor(255,255,255,255)
						surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
					end
				end
				function obj:OnCursorEntered()
					if self.DescriptionBox then return end
					if pUpgradesMenu.Supress then return end
					CreateDescriptionBox(self)
					
					pUpgradesMenu.HoverBox = true
				end
				function obj:OnCursorExited()
					pUpgradesMenu.HoverBox = false
					if not pDescriptionBox then return end
					if not pDescriptionBox:IsValid() then return end
					
					timer.Simple(0.1,function()
						if (not pUpgradesMenu.HoverBox) and (not pUpgradesMenu.HoverDesc) then
							if pDescriptionBox and pDescriptionBox:IsValid() then
								pDescriptionBox:Remove()
							end
							pDescriptionBox = nil
						end
					end)
				end
				function obj:OnMousePressed()
					if (Morbus.Upgrades[self.Upgrade] == UPGRADES[self.Upgrade].MaxLevel) then return end
					if ((self.Tier==1) or (LocalPlayer():GetTierPoints(self.Tree,self.Tier-1)>=UPGRADE_TIER_REQUIREMENT)) then
						local pts = Morbus.Evo_Points
						
						if pts>0 then
							--pUpgradesMenu.Supress = true
							surface.PlaySound(Sound("weapons/demon/a-build" .. math.random( 1, 2 ) .. ".wav"))
							
							local short = UPGRADES[self.Upgrade]
							-- We can put a point into this; create a confirmation window
							--CreateSimpleControl("Increase Upgrade","Are you certain you wish to increase the level of upgrade '"..short.Title.."'?",{{Text="Yes",Recall=function()
								
								--RunConsoleCommand("alien_increase_level_upgrade",self.Upgrade,num)
							RunConsoleCommand("morbus_upgrade",self.Upgrade)

							Morbus.Upgrades[self.Upgrade] = (Morbus.Upgrades[self.Upgrade] or 0) + 1
								
							--pUpgradesMenu:Remove()
							if pDescriptionBox then
								--pDescriptionBox:Remove()
							end
							
							UpdateUpgradesMenu()
							
							
						else
							surface.PlaySound(Sound("buttons/button8.wav"))
							
							LocalPlayer():PrintMessage(3,"You do not have sufficient points to increase this upgrade.")
						end
					else
						surface.PlaySound(Sound("buttons/button2.wav")) -- It's not unlocked!
						
						LocalPlayer():PrintMessage(3,"You need more points in the previous tier to unlock this upgrade.")
					end
				end
				
				local oldy = cury
				cury = cury + UPGRADE_SIZE_MENU + (UPGRADE_MENU_PADDING*0)
				
				-- Make the thing underneath saying how much points we have in this skill
				local tw = 24 --TextWidth("DefaultSmall","(X / X)")
				
				if not Morbus.Upgrades then Morbus.Upgrades = {} end
				local lvl = Morbus.Upgrades[obj.Upgrade] or 0
				
				local lab = vgui.Create("DLabel",base)
				lab:SetFont("DefaultSmall")
				lab:SetText("("..lvl.." / "..UPGRADES[obj.Upgrade].MaxLevel..")")
				lab:SetPos(curx + (UPGRADE_SIZE_MENU/2) - (tw/2),cury)
				
				cury = oldy
				
				curx = curx + UPGRADE_SIZE_MENU + UPGRADE_MENU_PADDING
				pUpgradesMenu["UPS"][tree][info.ByTier[i][j]] = obj
				pUpgradesMenu["UPS2"][tree][info.ByTier[i][j]] = lab
			end
			
			cury = cury + UPGRADE_SIZE_MENU + (UPGRADE_MENU_PADDING*4)
		end
	end


end
