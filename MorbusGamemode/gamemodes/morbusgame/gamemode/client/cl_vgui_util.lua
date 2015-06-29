// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
function CreateDescriptionBox(obj)
	local checktable = "Upgrades"
	brank = false
	
	if pDescriptionBox and pDescriptionBox:IsValid() then
		pDescriptionBox:Remove()
		pDescriptionBox = nil
	end
	
	local bx,by = pUpgradesMenu:GetPos()
	local xpos,ypos = obj:GetPos()
	
	xpos,ypos = (xpos+(UPGRADE_SIZE_MENU*0.85))+bx,(ypos+(UPGRADE_SIZE_MENU*0.65))+by -- Since Panel:GetPos() refers position relative to parent, I have to add the parent's position to it
	
	local desc = vgui.Create("DPanel")
	desc:SetPos(xpos-(ScrW() * 0.25)/2,ypos+UPGRADE_SIZE_MENU/2)
	desc:SetSize(ScrW() * 0.25,ScrH() * 0.125)
	desc:MakePopup()
	function desc:Paint()
		draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(0,25,0,235))
	end
	function desc:OnCursorEntered()
		if !pUpgradesMenu then self:Remove() pDescriptionBox = nil return end
		pUpgradesMenu.HoverDesc = true
	end
	
	function desc:OnCursorExited()
		if !pUpgradesMenu then self:Remove() pDescriptionBox = nil return end
		pUpgradesMenu.HoverDesc = false
					
		if (not pUpgradesMenu.HoverBox) and (not pUpgradesMenu.HoverDesc) then
			self:Remove()
			
			pDescriptionBox = nil
		end
	end
	
	-- Fill in all the information
	local short = UPGRADES[obj.Upgrade]
	
		-- Name and Tier
	local ox,oy = 5,5
	local cx,cy = ox,oy
	local lab = vgui.Create("DLabel",desc)
	lab:SetPos(cx,cy)
	lab:SetFont("TargetID")
	lab:SetTextColor(Color(255,255,255,255))
	lab:SetText(short.Title)
	lab:SizeToContents()
	cx = cx + (lab:GetWide()*1.1)
	
	if not Morbus.Upgrades then Morbus.Upgrades = {} end
	local lvl = Morbus.Upgrades[obj.Upgrade] or 0
	
	local lab = vgui.Create("DLabel",desc)
	lab:SetPos(cx,cy)
	lab:SetFont("TargetID")
	lab:SetTextColor(Color(0,255,0,255))
	lab:SetText("(Level "..tostring(lvl).." / "..short.MaxLevel..")")
	lab:SizeToContents()	
	cx = ox
	cy = cy + (FontHeight("TargetID")*1.2)
	
		-- Requirement
	if obj.Tier>1 then
		local clr = Color(255,0,0,255)
		if LocalPlayer():GetTierPoints(obj.Tree,obj.Tier-1)>=UPGRADE_TIER_REQUIREMENT then
			clr = Color(0,255,0,255)
		end
		
		local lab = vgui.Create("DLabel",desc)
		lab:SetPos(cx,cy)
		lab:SetFont("DefaultSmall")
		lab:SetTextColor(clr)
		lab:SetText("Requires "..UPGRADE_TIER_REQUIREMENT.." points in "..UPGRADE_TREES[obj.Tree].." Tier "..(obj.Tier-1))
		lab:SizeToContents()
	end
	
	cy = cy + (FontHeight("DefaultSmall")*1.5)
	
		-- Description
	local mup = markup.Parse(short.Desc,desc:GetWide()*0.9)
	
	local lab = vgui.Create("DLabel",desc)
	lab:SetPos(cx,cy)
	lab:SetFont("Default")
	lab:SetTextColor(Color(220,220,220,255))
	lab:SetText(short.Desc)
	lab:SetSize(desc:GetWide()*0.95,mup:GetHeight())
	lab:SetWrap(true)
	
	cy = cy + lab:GetTall() + (FontHeight("Default")*0.5)
	
	desc:SetSize(desc:GetWide(),cy)
	pDescriptionBox = desc
end

function CreateSimpleControl(title,text,ctrls,w,h)
	if not w then w = ScrW() * 0.2 end
	if not h then h = ScrH() * 0.1 end
	
	local base = vgui.Create("DFrame")
	base:SetTitle(title)
	base:SetSize(w,h)
	base:SetVisible(true)
	base:SetDraggable(false)
	base:MakePopup()
	base:SetDeleteOnClose(true)
	base:SetKeyboardInputEnabled(false)
	base:ShowCloseButton(false)
	base:SetMouseInputEnabled(true)
	base:Center()
	
	-- Title
	local mup = markup.Parse(text,base:GetWide()*0.9)
	
	local lab = vgui.Create("DLabel",base)
	lab:SetPos(5,30)
	lab:SetSize(base:GetWide()*0.95,mup:GetHeight())
	lab:SetWrap(true)
	lab:SetText(text)
	
	local padding = 5
	
	local per_button = (base:GetWide()-(padding*(2+#ctrls))) / #ctrls
	
	local buthei = FontHeight("Default")*2
	local cx = padding
	-- Controls
	for k,ctrl in pairs(ctrls) do
		local but = vgui.Create("DButton",base)
		but:SetPos(cx,base:GetTall() - (buthei + padding))
		but:SetSize(per_button,buthei)
		but:SetText(ctrl.Text)
		but.Control = ctrl
		function but:OnMousePressed()
			surface.PlaySound(Sound("buttons/blip1.wav"))
			
			self.Control.Recall()
			
			self:GetParent():Remove()
		end
		
		cx = cx + per_button + padding
	end
	function base:Think()
		self:MakePopup()
	end
end