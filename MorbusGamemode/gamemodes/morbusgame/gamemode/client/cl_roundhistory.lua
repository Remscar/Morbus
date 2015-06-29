// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
local PANEL = {}

PANEL.TBARS = {}
PANEL.TBARS[1] = {"First Alien","First",Color(200,0,0,240),function(tab,obj,p)
  if (!p) then p=1 end
  p = tonumber(p)
  if obj then
    return tab[p]
  else
    if tab[p].GetFName then
      return tab[p]:GetFName(true)
    else
      return "disconnected"
    end
  end

  return "NONE"
end}
PANEL.TBARS[2] = {"Most Infections","Infect",Color(0,180,0,240),function(tab,obj)
local i = 0
local win = nil
for k,v in pairs(tab) do
  if v > i then
    i = v
    win = k
  end
end
if win then
  if obj then
    return win
  else
    if win && win.GetFName then
      return win:GetFName(true)..": "..i
    else
      return "disconnected"
    end
  end
end

  if obj then
    return false
  end

  return "NONE"

end}
PANEL.TBARS[3] = {"Most Kills","Kill",Color(220,180,0,240),function(tab,obj)
local i = 0
local win = nil
for k,v in pairs(tab) do
  if v > i then
    i = v
    win = k
  end
end
if win then
  if obj then
    return win
  else
    if win && win.GetFName then
      return win:GetFName(true)..": "..i
    else
      return "disconnected"
    end
  end
end
  
  if obj then
    return false
  end

  return "NONE"

end}

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
  self:SetWide(600)
  self:SetTall(600)
  self:Center()
  self:SetTitle("Round History")
  self:MakePopup()

  self.EXIT = vgui.Create("Button",self)
  self.EXIT:SetSize(100,26)
  self.EXIT:SetText("")
  self.EXIT:SetPos(self:GetWide()-104,4)
  self.EXIT.Paint = function()
    local amt = 100
    if self.EXIT.Hovered then amt = 200 end
    if self.EXIT.Depressed then amt = 250 end
    draw.RoundedBox(0,0,0,self.EXIT:GetWide(),self.EXIT:GetTall(),Color(0,0,0,255))
    draw.RoundedBox(0,2,2,self.EXIT:GetWide()-4,self.EXIT:GetTall()-4,Color(amt,0,0,255))
    draw.SimpleText("EXIT","Trebuchet24",self.EXIT:GetWide()/2,self.EXIT:GetTall()/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end
  self.EXIT.OnMousePressed = function()
    self:Remove()
  end

  self.Sheets = vgui.Create("DPropertySheet",self)
  self.Sheets:SetPos(4,35)
  self.Sheets:SetShowIcons(false)
  self.Sheets:SetSize(591,560)
  self.Sheets.Paint = function()
    surface.SetDrawColor( 90, 90, 90, 255 )
    surface.DrawRect( 0, 0, self.Sheets:GetWide(), self.Sheets:GetTall() )
  end

  self.Highlights = vgui.Create("panel",self.Sheets)
  self.Highlights:SetSize(600,600)
  self.Highlights:SetVisible(true)
  self.Highlights:SetPos(8,30)
  self.BARS = {}

  for i=1,3 do
    if (i==1) then
      for p=1,#RoundHistory["First"] do
        self.BARS["Alien"..p] = vgui.Create("panel",self.Highlights)
        self.BARS["Alien"..p]:SetSize(600-28,40)
        self.BARS["Alien"..p]:SetPos(0,((p-1)*45))
        self.BARS["Alien"..p].Icon = vgui.Create( "DButton", self.BARS["Alien"..p])
        self.BARS["Alien"..p].Icon:SetVisible( true )  
        self.BARS["Alien"..p].Icon:SetText("")
        self.BARS["Alien"..p].Icon:SetSize( 36, 36 )
        self.BARS["Alien"..p].Icon:SetZPos( 1000 )
        self.BARS["Alien"..p].Icon:SetPos( 2,2 )
        self.BARS["Alien"..p].Icon.BGColor = Color(100,100,100,255)
        self.BARS["Alien"..p].Icon.Paint = function()
          draw.RoundedBox(4, 0, 0, self.BARS["Alien"..p].Icon:GetWide(), self.BARS["Alien"..p].Icon:GetTall(), self.BARS["Alien"..p].Icon.BGColor)
        end

        self.BARS["Alien"..p].FallbackImage = vgui.Create( "DImage", self.BARS["Alien"..p].Icon )
        self.BARS["Alien"..p].FallbackImage:SetMouseInputEnabled( false )
        self.BARS["Alien"..p].FallbackImage:SetPos( 2, 2 )
        self.BARS["Alien"..p].FallbackImage:SetSize( 32, 32 )
        self.BARS["Alien"..p].FallbackImage:SetImage( "gui/silkicons/check_off" )
    
        self.BARS["Alien"..p].Image = vgui.Create( "AvatarImage", self.BARS["Alien"..p].FallbackImage )
        self.BARS["Alien"..p].Image:StretchToParent( 0, 0, 0, 0 )
        if self.TBARS[i][4](RoundHistory[self.TBARS[i][2]],true,p) then
          self.BARS["Alien"..p].Image:SetPlayer( self.TBARS[i][4](RoundHistory[self.TBARS[i][2]],true,p) )
        end
    
        self.BARS["Alien"..p].Paint = function()
          draw.RoundedBox(4,0,0,self.BARS["Alien"..p]:GetWide(),self.BARS["Alien"..p]:GetTall(),Color(30,30,30,240))
          draw.RoundedBox(4,2,2,self.BARS["Alien"..p]:GetWide()-4,self.BARS["Alien"..p]:GetTall()-4,self.TBARS[i][3])
          draw.SimpleTextOutlined(self.TBARS[i][1],"DSMedium",45,20,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2,Color(0,0,0,255))
          draw.SimpleTextOutlined(self.TBARS[i][4](RoundHistory[self.TBARS[i][2]],false,p),"MenuLarge",self.BARS["Alien"..p]:GetWide()-20,20,Color(255,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,205))
        end
      end
    else
      self.BARS[i] = vgui.Create("panel",self.Highlights)
        self.BARS[i]:SetSize(600-28,40)
        self.BARS[i]:SetPos(0,((i-2+#RoundHistory["First"])*45))
        self.BARS[i].Icon = vgui.Create( "DButton", self.BARS[i])
        self.BARS[i].Icon:SetVisible( true )  
        self.BARS[i].Icon:SetText("")
        self.BARS[i].Icon:SetSize( 36, 36 )
        self.BARS[i].Icon:SetZPos( 1000 )
        self.BARS[i].Icon:SetPos( 2,2 )
        self.BARS[i].Icon.BGColor = Color(100,100,100,255)
        self.BARS[i].Icon.Paint = function()
          draw.RoundedBox(4, 0, 0, self.BARS[i].Icon:GetWide(), self.BARS[i].Icon:GetTall(), self.BARS[i].Icon.BGColor)
        end

        self.BARS[i].FallbackImage = vgui.Create( "DImage", self.BARS[i].Icon )
        self.BARS[i].FallbackImage:SetMouseInputEnabled( false )
        self.BARS[i].FallbackImage:SetPos( 2, 2 )
        self.BARS[i].FallbackImage:SetSize( 32, 32 )
        self.BARS[i].FallbackImage:SetImage( "gui/silkicons/check_off" )
    
        self.BARS[i].Image = vgui.Create( "AvatarImage", self.BARS[i].FallbackImage )
        self.BARS[i].Image:StretchToParent( 0, 0, 0, 0 )
        if self.TBARS[i][4](RoundHistory[self.TBARS[i][2]],true) then
          self.BARS[i].Image:SetPlayer( self.TBARS[i][4](RoundHistory[self.TBARS[i][2]],true) )
        end
    
        self.BARS[i].Paint = function()
          draw.RoundedBox(4,0,0,self.BARS[i]:GetWide(),self.BARS[i]:GetTall(),Color(30,30,30,240))
          draw.RoundedBox(4,2,2,self.BARS[i]:GetWide()-4,self.BARS[i]:GetTall()-4,self.TBARS[i][3])
          draw.SimpleTextOutlined(self.TBARS[i][1],"DSMedium",45,20,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER,2,Color(0,0,0,255))
          draw.SimpleTextOutlined(self.TBARS[i][4](RoundHistory[self.TBARS[i][2]]),"MenuLarge",self.BARS[i]:GetWide()-20,20,Color(255,255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,205))
        end
      end
  end

  self.LogPanel = vgui.Create("panel",self.Sheets)
  self.LogList = vgui.Create("DListView",self.LogPanel)
  self.LogList:SetPos(0,0)
  self.LogList:SetSize(575,550)
  self.LogList:AddColumn("Time"):SetFixedWidth(50)
  self.LogList:AddColumn("Type"):SetFixedWidth(50)
  self.LogList:AddColumn("Event")

  for k,v in pairs(Round_Log) do
    self.LogList:AddLine(v.Time,v.Type,v.Text)
  end
  self.LogList:SetSize(575,560)



  self.Sheets:AddSheet("Highlights",self.Highlights,nil, false, false, "Round Highlights")
  self.Sheets:AddSheet("Log",self.LogPanel,nil, false, false, "Round Log")

end

function PANEL:Think()
end


vgui.Register( "RoundHistory", PANEL, "DFrame" )


function OPEN_RHISTORY()
  if !RHISTORY_OBJ then
    RHISTORY_OBJ = vgui.Create("RoundHistory")
  else
    RHISTORY_OBJ:Remove()
    RHISTORY_OBJ = vgui.Create("RoundHistory")
  end
end