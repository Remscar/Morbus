include("sb_info.lua")

SB_ROW_HEIGHT = 24

local PANEL = {}

function PANEL:Init()

   self.info = nil
   self.stat = nil

   self.open = false

   self.cols = {}
   self.cols[1] = vgui.Create("DLabel", self)
   self.cols[1]:SetText("Ping")

   if true then
      self.cols[2] = vgui.Create("DLabel", self)
      self.cols[2]:SetText("Sanity")
   end

 --  self.cols[3] = vgui.Create("DLabel", self)
 --  self.cols[3]:SetText("Score")

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

   self.voice = vgui.Create("DImageButton", self)
   self.voice:SetSize(16,16)

   self:SetCursor( "hand" )
end


local namecolor = {
   default     = Color( 200, 200, 200, 255 )
}


function GM:MScoreboardColorForPlayer( ply )

   if not IsValid( ply ) then return namecolor.default end

   if ply:SteamID()     == "STEAM_0:0:20749231" then
      return Color( 255, 180, 0, 255 )
   end

  // elseif ply:GetUserGroup() == "admin" then
  //    return namecolor.admin

   //elseif ply:GetUserGroup() == "superadmin" then
   //   return namecolor.superadmin

   //elseif ply:GetUserGroup() == "owner" then
   //   return namecolor.owner

   return namecolor.default
end

local function ColorForPlayer( ply )

   if IsValid(ply) then
      local c = hook.Call( "MScoreboardColorForPlayer", GAMEMODE, ply )

      -- verify that we got a proper color
      if c and type(c) == "table" and c.r and c.b and c.g and c.a then
         return c
      else
         ErrorNoHalt( "MScoreboardColorForPlayer hook returned something that isn't a color!\n" )
      end
   end
   return namecolor.default
end

function PANEL:Paint()

   if not IsValid( self.Player ) then return end
   local ply = self.Player

   if ply:IsBrood() then
      if LocalPlayer():IsAlien() then
         if !GetConVar("morbus_alienhud_disable"):GetBool() then
            surface.SetDrawColor( 255, 0, 0, 90 )
         else
            surface.SetDrawColor( 200, 0, 0, 90 )
         end
      else
         surface.SetDrawColor( 200, 0, 0, 90 )
      end
      surface.DrawRect( 0, 0, self:GetWide(), SB_ROW_HEIGHT )
   elseif false then
      surface.SetDrawColor( 200, 0, 0, 90 )
      surface.DrawRect( 0, 0, self:GetWide(), SB_ROW_HEIGHT )
   end


   if ply == LocalPlayer() then
      surface.SetDrawColor( 200, 200, 200, math.Clamp( math.sin (RealTime() * 2 ) * 50, 0, 100 ) )
      surface.DrawRect( 0, 0, self:GetWide(), SB_ROW_HEIGHT )
   end

   return true
end

function PANEL:SetPlayer( ply )

   self.Player    = ply
   self.avatar:SetPlayer( ply )

   self.stat      = vgui.Create ("MScorePlayerStatTags", self )
   self.stat:SetPlayer( ply )

   self.info      = vgui.Create ("MScorePlayerInfoTags", self )
   self.info:SetPlayer( ply )

   self:InvalidateLayout()

   self.voice.DoClick = function()
      if IsValid( ply ) and ply != LocalPlayer() then
         ply:SetMuted( not ply:IsMuted() )
      end
   end
   self:UpdatePlayerData()
end

function PANEL:GetPlayer() return self.Player end

function PANEL:UpdatePlayerData()
   if not IsValid(self.Player) then return end

   local ply = self.Player
   self.cols[1]:SetText(ply:Ping())

   if self.cols[2] then
      self.cols[2]:SetText(math.Round(ply:GetBaseSanity()))
   end

 --  self.cols[3]:SetText(ply:Frags())

   self.nick:SetText( "(" .. ply:Nick() .. ")" )
   self.nick:SizeToContents()
   self.nick:SetTextColor( ColorForPlayer( ply ) )

   if GetConVar( "morbus_hide_rpnames" ):GetBool() && GetGlobalBool( "morbus_rpnames_optional", false ) then
      self.name:SetText("")
   else
      self.name:SetText( ply:GetFName() )
   end
   self.name:SizeToContents()

   local ptag = ply.sb_tag
   self.tag:SetText(ptag and ptag.txt or "")
   self.tag:SetTextColor(ptag and ptag.color or COLOR_WHITE)


   self:LayoutColumns()

   if self.info then
      self.info:UpdatePlayerData()
   end

   if self.Player != LocalPlayer() then
      local muted = self.Player:IsMuted()
      self.voice:SetImage(muted and "icon16/sound_mute.png" or "icon16/sound.png")
   else
      self.voice:Hide()
   end

end

function PANEL:ApplySchemeSettings()
   for k,v in pairs( self.cols ) do
      v:SetFont("treb_small")
      v:SetTextColor( COLOR_WHITE )
   end

   self.name:SetFont("treb_small")
   self.name:SetTextColor( COLOR_WHITE )

   self.nick:SetFont("treb_small")
   self.nick:SetTextColor( ColorForPlayer( self.Player ) )

   local ptag = self.Player and self.Player.sb_tag
   self.tag:SetTextColor( ptag and ptag.color or COLOR_WHITE )
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

      if self.info then 
         self.info:SetVisible(false) 
         self.stat:SetVisible(false) 
      end

   elseif self.info then
      self:SetSize(self:GetWide(), 100 + SB_ROW_HEIGHT)

      self.stat:SetVisible(true)
      self.stat:SetPos(5, SB_ROW_HEIGHT + 5)
      self.stat:SetSize(self:GetWide(), 100)
      self.stat:PerformLayout()

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

   self.voice:SetVisible(not self.open)
   self.voice:SetSize(16, 16)
   self.voice:DockMargin(4, 4, 4, 4)
   self.voice:Dock(RIGHT)
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
end

vgui.Register( "MScorePlayerRow", PANEL, "Button" )
