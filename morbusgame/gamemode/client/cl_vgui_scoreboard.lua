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
local PANEL = {}

PANEL.Colors = {
  Color(255,255,255,255),
  Color(50,255,50,255),
  Color(250,150,0,255)
}
/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
  local tab = table.Count(player.GetAll())
  self:SetWide(600)
  self:SetTall(100)
  self:SetPos(ScrW()/2-300,100)
end

PANEL.COLORS = {Color(55,255,55,255),Color(240,0,0,255),Color(180,0,0,255)}

function PANEL:Think()
  local tab = table.Count(player.GetAll())
  self:SetTall(120 + (tab*23))
end

function PANEL:Paint()
  
  draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color( 80,80,80, 235 ) )
  draw.RoundedBox( 0, 4, 4, self:GetWide()-8, self:GetTall()-8, Color( 10,10,10, 205 ) )
  --draw.RoundedBox( 0, 0, 0, self:GetWide(), 80, Color( 50,50,50, 205 ) )
  --draw.BlackOut(-1, -1, self:GetWide()+2, self:GetTall()+2) 
    

  draw.SimpleTextOutlined( GAMEMODE.Name ,"DSHuge",self:GetWide()*0.5, 10,Color(200,0,0,255),1,3,3,Color(0,0,0,255))

  local tall = 55
  draw.SimpleTextOutlined("Name","DefaultBold", 12,tall,Color(255,255,255,255),TEXT_ALIGN_LEFT,3,2,Color(20,20,20,255) )
  draw.SimpleTextOutlined("Ping","DefaultBold", self:GetWide() - 50,tall,Color(255,255,255,255),1,3,2,Color(20,20,20,255) )
  draw.SimpleTextOutlined("Status","DefaultBold", self:GetWide() - 50*3, tall,Color(255,255,255,255),1,3,2,Color(20,20,20,255) )

  local tab = player.GetAll()
  table.sort(tab,function(a,b)return (a:GetRole() or 1) > (b:GetRole() or 1) end)

  for _,ply in pairs(tab) do 
      

      tall = tall + 23
      local Shade = Color(20,20,20,255)

      --draw.RoundedBox(0,4,tall,self:GetWide()-8,20,Color(50,50,50,255))
      draw.RoundedBox(8,4,tall,self:GetWide()-8,20,Shade)
      if (ply:SteamID() == "STEAM_0:0:20749231") then --Please leave this in, it merely makes the original programmers name orange on the score board
        draw.SimpleText(ply:GetFName(true),"TabLarge", 12,tall+3,Color(255,100,0))
      else
        draw.SimpleText(ply:GetFName(true),"TabLarge", 12,tall+3,self.COLORS[ply:GetNWInt("Donator",0)])
      end
      if ply:Team() == TEAM_SPEC then
        draw.SimpleText("SPECTATOR","TabLarge", self:GetWide() - 50*3, tall+3,Color(255,255,0,255),1,3,2,Color(80,80,80,255))
      else
        draw.SimpleText(GetRoleName(ply:GetRole()or 1),"TabLarge", self:GetWide() - 50*3, tall+3,self.COLORS[ply:GetRole() or 1],1,3,2,Color(80,80,80,255))
      end
      draw.SimpleText(ply:Ping(),"TabLarge", self:GetWide() - 50, tall+3,Color(255,255,255,255),1,3,2,Color(20,20,20,255))
      
  end

  draw.SimpleText("Developed by Remscar - Remscar@live.com","DefaultBold",self:GetWide()/2,self:GetTall()-22,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)

end
vgui.Register( "ScoreBoard", PANEL, "DPanel" )