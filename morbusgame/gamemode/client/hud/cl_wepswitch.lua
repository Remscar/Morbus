--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- WEAPON SWITCH INTERFACE
local round = math.Round
local tex = surface.GetTextureID("vgui/morbus/HPBar")
local delay = 0.075
local showtime = 3
local margin = 10
local width = 300
local height = 20
local COLORS_TEXT = {
	bg = Color(20, 20, 20, 255),
	text_empty = Color(200, 20, 20, 100),
	text = Color(255, 255, 255, 130),
	shadow = 100
}
WSWITCH = {}

WSWITCH.Show = false
WSWITCH.Selected = -1
WSWITCH.NextSwitch = -1
WSWITCH.WeaponCache = {}

surface.CreateFont( "SEL_WEPFONT", {
	font		= "Verdana",
	size		= ScreenScale(11),
	weight		= 400,
	antialias	= true
})
surface.CreateFont( "USEL_WEPFONT", {
	font		= "Tahoma",
	size		= ScreenScale(6),
	weight		= 400,
	antialias	= true
})

CreateClientConVar("mor_ignore_brood",0)

function WSWITCH:DrawBarBg(x, y, w, h, col)
	local rx = round(x - 4)
	local ry = round(y - (h / 2)-4)
	local rw = round(w + 9)
	local rh = round(h + 8)
	local b = 8 --bordersize
	local bh = b / 2
	c = col.bg

	surface.SetDrawColor(c.r, c.g, c.b, c.a)

	if (self.Selected == current) then
		surface.SetDrawColor(40, 230, 245,220)
		surface.SetTexture(tex)
		surface.DrawTexturedRect( rx+b+h-4, ry,  rw - (h - 4) - b*2,  rh)
	else
		surface.SetDrawColor(40, 220, 235,120)
		surface.SetTexture(tex)
		surface.DrawTexturedRect( rx+b+h-4, ry,  rw - (h - 4) - b*2,  rh)
	end
	draw.RoundedBox(0,x+28,ry+1,12,rh-2,Color(0,0,0,140))
end

function WSWITCH:DrawWeapon(x, y, c, wep, w, h)
	if not ValidEntity(wep) then return false end
	if !wep:Ammo1() then return false end

	local name = wep:GetPrintName() or wep.PrintName or "..."
	local cl1, am1 = wep:Clip1(), wep:Ammo1()
	local ammo = false

	-- Clip1 will be -1 if a melee weapon
	-- Ammo1 will be false if weapon has no owner (was just dropped)
	if cl1 != -1 and am1 != false then
		ammo = Format("%i / %0i", cl1, am1)
	end

	-- Slot
	local FONT = "SEL_WEPFONT"

	local spec = {text=wep.Slot+1, font= FONT, pos={x+28, y}, xalign=TEXT_ALIGN_LEFT, yalign=TEXT_ALIGN_CENTER, color=c.text}
	draw.TextShadow(spec, 1, c.shadow)

	-- Name
	spec.text  = name
	spec.font  = FONT
	spec.pos[1] = x + 46
	draw.Text(spec)

	if ammo then
		local col = c.text
		local rx = round(x - 4)
		local ry = round(y - (h / 2)-4)
		local rw = round(w + 9)
		local rh = round(h + 8)
		local b = 8 --bordersize
		local bh = b / 2

		if wep:Clip1() == 0 and wep:Ammo1() == 0 then
			col = c.text_empty
		end

		draw.RoundedBox(0, x + w - (w/4) - 4, ry+1, w/4 - 2, rh, Color(0,0,0,140))

		-- Ammo
		spec.text	= ammo
		spec.pos[1] = x + w - (w/4)
		spec.xalign = TEXT_ALIGN_LEFT
		spec.color  = col
		draw.Text(spec)
	end
	return true
end

function WSWITCH:Draw(client)
	if not self.Show then return end

	local weps = self.WeaponCache
	local x = ScrW() - width - margin*2
	local y = ScrH() - (#weps * (height + margin))
	local col = COLORS_TEXT

	for k, wep in pairs(weps) do
		current = k
		self:DrawBarBg(x, y, width, height, col)
		if not self:DrawWeapon(x, y, col, wep, width, height) then
			self:UpdateWeaponCache()
			return
		end
		y = y + height + margin
	end
end

local function SlotSort(a, b)
	return a and b and a.Slot and b.Slot and a.Slot < b.Slot
end

local function CopyVals(src, dest)
	table.Empty(dest)
	for k, v in pairs(src) do
		if ValidEntity(v) then
			table.insert(dest, v)
		end
	end
end

function WSWITCH:UpdateWeaponCache()
	self.WeaponCache = {}

	CopyVals(LocalPlayer():GetWeapons(), self.WeaponCache)
	table.sort(self.WeaponCache, SlotSort)
end

function WSWITCH:SetSelected(idx)
	self.Selected = idx

	self:UpdateWeaponCache()
end

function WSWITCH:SelectNext()
	if self.NextSwitch > CurTime() then return end

	local s = self.Selected + 1

	self:Enable()
	if s > #self.WeaponCache then
		s = 1
	end
	self:DoSelect(s,self.Selected)
	self.NextSwitch = CurTime() + delay
end

function WSWITCH:SelectPrev()
	if self.NextSwitch > CurTime() then return end

	local s = self.Selected - 1

	self:Enable()
	if s < 1 then
		s = #self.WeaponCache
	end
	self:DoSelect(s,self.Selected)
	self.NextSwitch = CurTime() + delay
end

-- Select by index
function WSWITCH:DoSelect(idx,old)
	self:SetSelected(idx)

	if GetConVar("hud_fastswitch"):GetBool() then
		if self.WeaponCache[self.Selected]:GetClass() != "weapon_mor_brood" then
			self:ConfirmSelection()
		else
			if GetConVar("mor_ignore_brood"):GetBool() then
				if idx > old && old != 1 then
					self:SelectNext()
				else
					self:DoSelect(#self.WeaponCache-1)
				end
			end
		end
	end
end

-- Numeric key access to direct slots
function WSWITCH:SelectSlot(slot)
	if not slot then return end

	slot = slot - 1

	self:Enable()
	self:UpdateWeaponCache()

	-- find which idx in the weapon table has the slot we want
	local toselect = self.Selected
	for k, w in pairs(self.WeaponCache) do
		if w.Slot == slot then
			toselect = k
			break
		end
	end
	self:SetSelected(toselect)
	self.NextSwitch = CurTime() + delay
end

-- Show the weapon switcher
function WSWITCH:Enable()
	if self.Show == false then
		self.Show = true
		local wep_active = LocalPlayer():GetActiveWeapon()

		self:UpdateWeaponCache()

		-- make our active weapon the initial selection
		local toselect = 1
		for k, w in pairs(self.WeaponCache) do
			if w == wep_active then
				toselect = k
				break
			end
		end
		self:SetSelected(toselect)
	end
end

-- Hide switcher
function WSWITCH:Disable()
	self.Show = false
end

-- Switch to the currently selected weapon
function WSWITCH:ConfirmSelection()
	self:Disable()

	for k, w in pairs(self.WeaponCache) do
		if k == self.Selected and ValidEntity(w) then
			RunConsoleCommand("wepswitch", w:GetClass())
			return
		end
	end
end

function WSWITCH:Think()
	if (not self.Show) then return end

	-- hide after period of inaction
	if self.NextSwitch < (CurTime() - showtime) then
		self:Disable()
	end
end

-- Instantly select a slot and switch to it, without spending time in menu
function WSWITCH:SelectAndConfirm(slot)
	if not slot then return end

	WSWITCH:SelectSlot(slot)
	WSWITCH:ConfirmSelection()
end

local function QuickSlot(ply, cmd, args)
	if (not IsValid(ply)) or (not args) or #args != 1 then return end

	local slot = tonumber(args[1])
	local wep = ply:GetActiveWeapon()

	if not slot then return end

	if IsValid(wep) then
		if wep.Slot == (slot - 1) then
			RunConsoleCommand("lastinv")
		else
			WSWITCH:SelectAndConfirm(slot)
		end
	end
end
concommand.Add("morbus_quickslot", QuickSlot)

local function SwitchToEquipment(ply, cmd, args)
	RunConsoleCommand("morbus_quickslot", tostring(7))
end
concommand.Add("morbus_equipswitch", SwitchToEquipment)
