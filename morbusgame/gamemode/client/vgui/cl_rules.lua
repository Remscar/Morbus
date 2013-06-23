// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

local PANEL = {}
PANEL.Tab_Names = {"Rules","Credits"}
PANEL.CurrentTab = 1

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
  self.Tab[1] = vgui.Create("HTML",self)
  self.Tab[1]:SetPos(4,34)
  self.Tab[1]:SetSize(850-8,750-38)
  self.Tab[1]:OpenURL("http://www.remscar.com/morbus/ingame/rules.html")
  self.Tab[1].URL = "http://www.remscar.com/morbus/ingame/rules.html"

  self.Tab[2] = vgui.Create("HTML",self)
  self.Tab[2]:SetPos(4,34)
  self.Tab[2]:SetSize(850-8,750-38)
  self.Tab[2]:OpenURL("http://www.remscar.com/morbus/ingame/credits.html")
  self.Tab[2]:SetVisible(false)
  self.Tab[2].URL = "http://www.remscar.com/morbus/ingame/credits.html"

  self.Slt = {}
  for i=1,2 do
    self.Slt[i] = vgui.Create("Button",self)
    self.Slt[i]:SetSize(100,26)
    self.Slt[i]:SetPos(8 + ((i-1)*104),4)
    self.Slt[i]:SetText("")
    self.Slt[i].Paint = function()
      local amt = Color(180,160,10,230)
      if (self.Slt[i].Hovered) then amt = Color(190,190,10,240) end
      if (self.Slt[i].Depressed) then amt = Color(240,10,10,240) end
      if (self.CurrentTab == i) then amt = Color(180,10,10,230) end
      draw.RoundedBox(0,0,0,self.Slt[i]:GetWide(),self.Slt[i]:GetTall(),Color(0,0,0,240))
      draw.RoundedBox(0,2,2,self.Slt[i]:GetWide()-4,self.Slt[i]:GetTall()-4,amt)
      draw.SimpleTextOutlined(self.Tab_Names[i],"Trebuchet22",self.Slt[i]:GetWide()/2,self.Slt[i]:GetTall()/2,Color(255,255,255,220),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,200))
    end
    self.Slt[i].OnMousePressed = function()
      if self.CurrentTab == i then return end
      self.Tab[i]:SetVisible(true)
      self.Tab[self.CurrentTab]:SetVisible(false)
      self.Tab[i]:OpenURL(self.Tab[i].URL)
      self.CurrentTab = i
    end
    
  end
end



vgui.Register( "RuleMenu", PANEL, "DFrame" )


function OPEN_HELPMENU()
  if !RULE_OBJ then
    RULE_OBJ = vgui.Create("RuleMenu")
    RULE_OBJ.Tab[1]:OpenURL("http://www.remscar.com/morbus/ingame/rules.html")
  else
    RULE_OBJ:Remove()
    RULE_OBJ = vgui.Create("RuleMenu")
    RULE_OBJ.Tab[1]:OpenURL("http://www.remscar.com/morbus/ingame/rules.html")
  end
end
concommand.Add("show_rules",OPEN_HELPMENU)