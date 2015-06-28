
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

vgui.Register("MScorePlayerInfoBase", PANEL, "Panel")

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


vgui.Register("MScorePlayerInfoSearch", PANEL, "MScorePlayerInfoBase")

--- Living player, tags etc

local tags = {
   {txt="Friend", color=COLOR_GREEN},
   {txt="Suspicious",   color=COLOR_YELLOW},
   {txt="Caution",  color=Color(255, 150, 0, 255)},
   {txt="Brood",   color=COLOR_RED},
   {txt="Swarm",   color=Color(200,50,50,255)},
};

local PANEL = {}

PANEL.T_Wide = 0

function PANEL:Init()
   self.TagButtons = {}

   for k, tag in ipairs(tags) do
      self.TagButtons[k] = vgui.Create("TagButton", self)
      self.TagButtons[k]:SetupTag(tag)
   end

   --self:SetMouseInputEnabled(false)
end

function PANEL:SetPlayer(ply)
   self.Player = ply

   for _, btn in pairs(self.TagButtons) do
      btn:SetPlayer(ply)
   end

   self:InvalidateLayout()
end

function PANEL:ApplySchemeSettings()

end

function PANEL:Paint()
   draw.RoundedBox(0, 0, 0, self.T_Wide - 2, 20, Color(20,20,20,100))
end

function PANEL:UpdateTag()
   self:GetParent():UpdatePlayerData()

   self:GetParent():SetOpen(false)
end

function PANEL:PerformLayout()
   self:SetSize(self:GetWide(), 30)

   local margin = 10
   local x = 300 --29
   local y = 0

   for k, btn in ipairs(self.TagButtons) do
      btn:SetPos(x, y)
      btn:SetCursor("hand")
      btn:SizeToContents()
      btn:PerformLayout()
      x = x + btn:GetWide() + margin
   end
   self.T_Wide = x
end

vgui.Register("MScorePlayerInfoTags", PANEL, "MScorePlayerInfoBase")

--- Tag button
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
   self:SetTextColor(self.Tag and self.Tag.color or COLOR_WHITE)
end

function PANEL:SetPlayer(ply)
   self.Player = ply
end

function PANEL:SetupTag(tag)
   self.Tag = tag

   self.Color = tag.color
   self.Text = tag.txt

   self:SetTextColor(self.Tag and self.Tag.color or COLOR_WHITE)
end

function PANEL:PerformLayout()
   self:SetText(self.Tag and self.Tag.txt or "")
   self:SizeToContents()
   self:SetContentAlignment(5)
   self:SetSize(self:GetWide() + 10, self:GetTall() + 3)
end

function PANEL:DoRightClick()
   if IsValid(self.Player) then
      self.Player.sb_tag = nil

      self:GetParent():UpdateTag()
   end
end

function PANEL:DoClick()
   if IsValid(self.Player) then
      if self.Player.sb_tag == self.Tag then
         self.Player.sb_tag = nil
      else
         self.Player.sb_tag = self.Tag
      end

      self:GetParent():UpdateTag()
   end
end


local select_color = Color(255, 200, 0, 255)
function PANEL:PaintOver()
   if self.Player and self.Player.sb_tag == self.Tag then
      surface.SetDrawColor(255,200,0,255)
      surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
   end
end

vgui.Register("TagButton", PANEL, "DButton")
