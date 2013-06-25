--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- Scoreboard player score row, based on sandbox version

include("sb_info.lua")

SB_ROW_HEIGHT = 24 --16
local contributors = {
	"STEAM_0:1:7305295", -- Soranon Warrior
	"STEAM_0:0:30843196", -- Chuck 'The Dev' Testa
	"STEAM_0:1:19539784", -- Rocket Scientist
}

local PANEL = {}

function PANEL:Init()
	-- cannot create info card until player state is known
	self.info = nil
	self.open = false
	self.cols = {}
	self.cols[1] = vgui.Create("DLabel", self)
	self.cols[1]:SetText("Ping")

	if true then
		self.cols[2] = vgui.Create("DLabel", self)
		self.cols[2]:SetText("Sanity")
	end
	for _, c in ipairs(self.cols) do
		c:SetMouseInputEnabled(false)
	end
	self.tag = vgui.Create("DLabel", self)
	self.tag:SetText("")
	self.tag:SetMouseInputEnabled(false)
	self.sresult = vgui.Create("DImage", self)
	self.sresult:SetSize(16,16)
	self.sresult:SetMouseInputEnabled(false)
	self.avatar = vgui.Create( "AvatarImage", self )
	self.avatar:SetSize(SB_ROW_HEIGHT, SB_ROW_HEIGHT)
	self.avatar:SetMouseInputEnabled(false)
	self.nick = vgui.Create("DLabel", self)
	self.nick:SetMouseInputEnabled(false)
	self.name = vgui.Create("DLabel", self)
	self.name:SetMouseInputEnabled(false)
	self:SetCursor( "hand" )
end

local namecolor = {
	default = Color(180, 150, 150, 255),
	admin = Color(220, 100, 0, 255),
	dev = Color(240, 160, 0, 255),
};

function GM:MScoreboardColorForPlayer(ply)
	if not IsValid(ply) then
		return namecolor.default
	end

	if ply:SteamID() == "STEAM_0:0:20749231" then -- Remscar
		return namecolor.dev
	elseif contributors[ply:SteamID()] then
		return namecolor.dev
	elseif ply:IsAdmin() and GetGlobalBool("mor_highlight_admins", true) then
		return namecolor.admin
	end
	return namecolor.default
end

local function ColorForPlayer(ply)
	if IsValid(ply) then
		local c = hook.Call("MScoreboardColorForPlayer", GAMEMODE, ply)

		-- verify that we got a proper color
		if c and type(c) == "table" and c.r and c.b and c.g and c.a then
			return c
		else
			ErrorNoHalt("MScoreboardColorForPlayer hook returned something that isn't a color!\n")
		end
	end
	return namecolor.default
end

function PANEL:Paint()
	if not IsValid(self.Player) then return end

	local ply = self.Player

	if ply:IsBrood() then
		surface.SetDrawColor(100, 0, 0, 180)
		surface.DrawRect(0, 0, self:GetWide(), SB_ROW_HEIGHT)
	elseif false then
		surface.SetDrawColor(200, 0, 0, 90)
		surface.DrawRect(0, 0, self:GetWide(), SB_ROW_HEIGHT)
	end
	if ply == LocalPlayer() then
		surface.SetDrawColor( 200, 200, 200, math.Clamp(math.sin(RealTime() * 2) * 50, 0, 100))
		surface.DrawRect(0, 0, self:GetWide(), SB_ROW_HEIGHT )
	end
	return true
end

function PANEL:SetPlayer(ply)
	self.Player = ply
	self.avatar:SetPlayer(ply)
	self.info = vgui.Create("MScorePlayerInfoTags", self)
	self.info:SetPlayer(ply)
	self:InvalidateLayout()
	self:UpdatePlayerData()
end

function PANEL:GetPlayer()
	return self.Player
end

function PANEL:UpdatePlayerData()
	if not IsValid(self.Player) then return end

	local ply = self.Player
	local ptag = ply.sb_tag

	self.cols[1]:SetText(ply:Ping())

	if self.cols[2] then
		self.cols[2]:SetText(math.Round(ply:GetBaseSanity()))
	end
	self.nick:SetText("("..ply:Nick()..")")
	self.nick:SizeToContents()
	self.nick:SetTextColor(ColorForPlayer(ply))
	if GetConVar("morbus_hide_rpnames"):GetBool() && GetGlobalBool("morbus_rpnames_optional",false) then
		self.name:SetText("")
	else
		self.name:SetText(ply:GetFName())
	end
	self.name:SizeToContents()
	self.name:SetTextColor(COLOR_WHITE)
	self.tag:SetText(ptag and ptag.txt or "")
	self.tag:SetTextColor(ptag and ptag.color or COLOR_WHITE)
	self:LayoutColumns() -- cols are likely to need re-centering
	if self.info then
		self.info:UpdatePlayerData()
	end
end

function PANEL:ApplySchemeSettings()
	local ptag = self.Player and self.Player.sb_tag

	for k,v in pairs(self.cols) do
		v:SetFont("treb_small")
		v:SetTextColor(COLOR_WHITE)
	end
	self.name:SetFont("treb_small")
	self.name:SetTextColor(COLOR_WHITE)
	self.nick:SetFont("treb_small")
	self.nick:SetTextColor(ColorForPlayer(self.Player))
	self.tag:SetTextColor(ptag and ptag.color or COLOR_WHITE)
	self.tag:SetFont("treb_small")
end

function PANEL:LayoutColumns()
	for k,v in ipairs(self.cols) do
		v:SizeToContents()
		v:SetPos(self:GetWide() - (50*k) - v:GetWide()/2, (SB_ROW_HEIGHT - v:GetTall()) / 2)
	end
	self.tag:SizeToContents()
	self.tag:SetPos(self:GetWide() - (50 * 4.2) - self.tag:GetWide()/2, (SB_ROW_HEIGHT - self.tag:GetTall()) / 2)
	self.sresult:SetPos(self:GetWide() - (50*6) - 8, (SB_ROW_HEIGHT - 16) / 2)
end

function PANEL:PerformLayout()
	self.avatar:SetPos(0,0)
	self.avatar:SetSize(SB_ROW_HEIGHT,SB_ROW_HEIGHT)

	if not self.open then
		self:SetSize(self:GetWide(), SB_ROW_HEIGHT)
		if self.info then self.info:SetVisible(false) end
	elseif self.info then
		self:SetSize(self:GetWide(), 100 + SB_ROW_HEIGHT)
		self.info:SetVisible(true)
		self.info:SetPos(5, SB_ROW_HEIGHT + 5)
		self.info:SetSize(self:GetWide(), 100)
		self.info:PerformLayout()
		self:SetSize(self:GetWide(), SB_ROW_HEIGHT + self.info:GetTall())
	end
	self.nick:SizeToContents()
	self.name:SizeToContents()
	self.nick:SetPos(SB_ROW_HEIGHT + 10, (SB_ROW_HEIGHT - self.nick:GetTall()) / 2)
	self.name:SetPos(SB_ROW_HEIGHT + 300, (SB_ROW_HEIGHT - self.nick:GetTall()) / 2)
	self:LayoutColumns()
end

function PANEL:DoClick(x, y)
	self:SetOpen(not self.open)
end

function PANEL:SetOpen(o)
	if self.open then
		surface.PlaySound("ui/buttonclickrelease.wav")
	else
		surface.PlaySound("ui/buttonclick.wav")
	end
	self.open = o
	self:PerformLayout()
	self:GetParent():PerformLayout()
	pScoreBoard:PerformLayout()
end

function PANEL:DoRightClick()
	-- Nothing?
end
vgui.Register( "MScorePlayerRow", PANEL, "Button" )
