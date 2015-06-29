// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

local PANEL = {}

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
  self:SetWide(850)
  self:SetTall(750)
  self:Center()
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

  

  self.Tab = {}
  self.CurrentTab = 2
  self.Page = 1

  self.EB = vgui.Create("Button",self)
  self.EB:SetSize(140,26)
  self.EB:SetText("")
  self.EB:SetPos(4,4)
  self.EB.Paint = function()
    local amt = 100
    if self.EB.Hovered then amt = 150 end
    if self.CurrentTab == 2 then amt = 200 end
    draw.RoundedBox(0,0,0,self.EB:GetWide(),self.EB:GetTall(),Color(0,0,0,255))
    draw.RoundedBox(0,2,2,self.EB:GetWide()-4,self.EB:GetTall()-4,Color(0,amt,0,255))
    draw.SimpleText("Quick Guide","Trebuchet24",self.EB:GetWide()/2,self.EB:GetTall()/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end
  self.EB.OnMousePressed = function()
    self.CurrentTab = 2
    self.Tab[1]:SetVisible(false)
    self.Tab[2]:SetVisible(true)
  end

  self.HB = vgui.Create("Button",self)
  self.HB:SetSize(140,26)
  self.HB:SetText("")
  self.HB:SetPos(144,4)
  self.HB.Paint = function()
    local amt = 100
    if self.HB.Hovered then amt = 150 end
    if self.CurrentTab == 1 then amt = 180 end
    draw.RoundedBox(0,0,0,self.HB:GetWide(),self.HB:GetTall(),Color(0,0,0,255))
    draw.RoundedBox(0,2,2,self.HB:GetWide()-4,self.HB:GetTall()-4,Color(amt,amt,0,255))
    draw.SimpleText("Indepth Guide","Trebuchet24",self.HB:GetWide()/2,self.HB:GetTall()/2,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end
  self.HB.OnMousePressed = function()
    self.CurrentTab = 1
    self.Tab[2]:SetVisible(false)
    self.Tab[1]:SetVisible(true)
    self.Tab[1]:OpenURL("http://remscar.com/morbus/ingame/guide.html")
  end

  self.Tab[1] = vgui.Create("HTML",self)
  self.Tab[1]:SetPos(4,34)
  self.Tab[1]:SetSize(850-6,750-38)
  self.Tab[1]:OpenURL("http://remscar.com/morbus/ingame/guide.html")
  self.Tab[1]:SetVisible(false)

  
  self.Tab[2] = vgui.Create("HTML",self)
  self.Tab[2].Slide = 1
  self.Tab[2]:OpenURL("http://remscar.com/morbus/ingame/guide_mini.html")
  self.Tab[2]:SetPos(4,34)
  self.Tab[2]:SetSize(850-6,500-38)





end

function PANEL:Think()
  if self.CurrentTab == 2 then
    self:SetWide(850)
    self:SetTall(500)
    self:Center()
  else
    self:SetWide(850)
    self:SetTall(750)
    self:Center()
  end
  self.EXIT:SetPos(self:GetWide()-104,4)

end


vgui.Register( "HelpMenu", PANEL, "DFrame" )


function OPEN_HELPMENU()
  if !HELP_OBJ then
    HELP_OBJ = vgui.Create("HelpMenu")
  else
    HELP_OBJ:Remove()
    HELP_OBJ = vgui.Create("HelpMenu")
  end
end
concommand.Add("helpme",OPEN_HELPMENU)