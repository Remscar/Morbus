
---- Player info panel, based on sandbox scoreboard's infocard

local vgui = vgui



--- Base stuff
local PANEL = {}

function PANEL:Init()
   self.Player = nil

   --self:SetMouseInputEnabled(false)
end

function PANEL:SetPlayer(ply)
   self.Player = ply
   self:UpdatePlayerData()
end

function PANEL:UpdatePlayerData()
   -- override me
end

function PANEL:Paint()
   return true
end

vgui.Register("MScorePlayerStatBase", PANEL, "Panel")

--- Dead player search results

local PANEL = {}

function PANEL:Init() 
end

function PANEL:PerformLayout()
   self:SetSize(self:GetWide(), 75)

   
end

function PANEL:UpdatePlayerData()
   if not IsValid(self.Player) then return end
   self:PerformLayout()
end


vgui.Register("MScorePlayerStatSearch", PANEL, "MScorePlayerStatBase")

local stats = {
   {txt="Alien Kills", color=Color(255, 150, 55, 255)},
   {txt="Infections",   color=Color(115, 255, 55, 255)},
   {txt="RDMs",  color=Color(255, 95, 95, 255)},
};

local PANEL = {}

PANEL.T_Wide = 0

function PANEL:Init()
   self.StatButtons = {}

   for k, stat in ipairs(stats) do
      self.StatButtons[k] = vgui.Create("StatButton", self)
      self.StatButtons[k]:SetupStat(stat)
   end

   --self:SetMouseInputEnabled(false)
end

function PANEL:SetPlayer(ply)
   self.Player = ply

   for _, btn in pairs(self.StatButtons) do
      btn:SetPlayer(ply)
   end

   self:InvalidateLayout()
end

function PANEL:ApplySchemeSettings()

end

function PANEL:Paint()
   draw.RoundedBox(0, 0, 0, self.T_Wide - 2, 20, Color(0,20,0,35))
end

function PANEL:UpdateStat()
   self:GetParent():UpdatePlayerData()

   self:GetParent():SetOpen(false)
end

function PANEL:PerformLayout()
   self:SetSize(self:GetWide(), 30)

   local margin = 10
   local x = 5 --29
   local y = 0

   for k, btn in ipairs(self.StatButtons) do
      btn:SetPos(x, y)
      btn:SetCursor("hand")
      btn:SizeToContents()
      btn:PerformLayout()
      x = x + btn:GetWide() + margin
   end
   self.T_Wide = x
end

vgui.Register("MScorePlayerStatTags", PANEL, "MScorePlayerStatBase")

local PANEL = {}

function PANEL:Init()
   self.Player = nil

   self:SetText("")
   self:SetMouseInputEnabled(true)
   self:SetKeyboardInputEnabled(false)

   self:SetTall(20)

   self:SetPaintBackgroundEnabled(false)
   self:SetPaintBorderEnabled(false)

   self:SetDrawBackground(false)
   self:SetDrawBorder(false)

   self:SetFont("treb_small")
   self:SetTextColor(self.Stat and self.Stat.color or COLOR_WHITE)
end

function PANEL:SetPlayer(ply)
   self.Player = ply
end

function PANEL:SetupStat(stat)
   self.Stat = stat

   self.Color = stat.color
   self.Text = stat.txt

   self:SetTextColor(self.Stat and self.Stat.color or COLOR_WHITE)
end

function PANEL:PerformLayout()
   if self.Stat.txt == "Alien Kills" then
      self:SetText(self.Stat and self.Stat.txt .. " : " .. tostring( self.Player:GetAlienKills() ) or "")
   elseif self.Stat.txt == "Infections" then
      self:SetText(self.Stat and self.Stat.txt .. " : " .. tostring( self.Player:GetInfections() ) or "")
   elseif self.Stat.txt == "RDMs" then
      self:SetText(self.Stat and self.Stat.txt .. " : " .. tostring( self.Player:GetRDMScore() ) or "")
   else
      self:SetText(self.Stat and self.Stat.txt or "")
   end
   self:SizeToContents()
   self:SetContentAlignment(5)
   self:SetSize(self:GetWide() + 10, self:GetTall() + 3)
end

local select_color = Color(255, 200, 0, 255)
function PANEL:PaintOver()
   if self.Player and self.Player.sb_stat == self.Stat then
      surface.SetDrawColor(255,200,0,255)
      surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
   end
end

vgui.Register("StatButton", PANEL, "DButton")
