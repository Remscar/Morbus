---------------------------------LOCALIZATION
 

local tex = surface.GetTextureID( "vgui/morbus/screen" )
local tex2 = surface.GetTextureID( "vgui/gradvr" )
---------------------------------------------
local PANEL = {}

PANEL.Trans = 0
PANEL.FTrans = 0
PANEL.MaxTrans = 170
PANEL.Status = false

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
  local tab = table.Count(player.GetAll())
  local max_x, max_y = ScrW(), ScrH()
  local des_x, des_y = 800,840
  local plc_x, plc_y = ScrW()/2 - des_x/2, ScrH()/2 - des_y/2
  if max_x < des_x then
    des_x = max_x - 20
    plc_x = 10
  end
  if max_y < des_y then
    des_y = max_y - 20
    plc_y = 10
  end


  self:SetWide(des_x)
  self:SetTall(des_y)
  self:SetPos(plc_x,plc_y)
end

SB_COLORS = {Color(55,255,55,255),Color(240,0,0,255),Color(180,0,0,255)}

function PANEL:Think()
  local tab = table.Count(player.GetAll())

  local status = self.Status
  local maxtrans = self.MaxTrans
  local trans = self.Trans

  if status && trans < maxtrans then
    trans = math.Clamp(trans+2,0,maxtrans)
  elseif status == false && trans > 0 then
    trans = math.Clamp(trans-2,0,maxtrans)
    if (trans < 1) then
      self:SetVisible(false)
      self.FTrans = 0
    end
  end
  self.Trans = trans

  local ftrans = 0
  local mul = math.sin(RealTime()*4)/8
  if trans > 0 then
    ftrans = math.Clamp(trans + (trans*(mul)),trans-30,trans+30)
  end

  self.FTrans = ftrans
end

function PANEL:Paint()

  local ftrans = self.FTrans
  local trans = self.Trans
  

  local ply = LocalPlayer()
  local BoxSize = 800;
  local Offset = BoxSize / 2;

  
  if trans > 0 then

    surface.SetDrawColor( 40, 220, 235, ftrans );
    surface.SetTexture( tex );
    surface.DrawTexturedRect(0,0, self:GetWide(),self:GetTall() );

    draw.SimpleTextOutlined(GAMEMODE.Name,"DSMass",self:GetWide()/2,60,Color(245,225,225,ftrans),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(0,0,0,ftrans))
    draw.SimpleTextOutlined("Name","DSLarge",60,80,Color(245,225,225,ftrans),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(0,0,0,ftrans))
    draw.SimpleTextOutlined("Status","DSLarge",self:GetWide()-200,80,Color(245,225,225,ftrans),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(0,0,0,ftrans))
    draw.SimpleTextOutlined("Ping","DSLarge",self:GetWide()-30,80,Color(245,225,225,ftrans),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,2,Color(0,0,0,ftrans))

    local i = 0

    local tab = player.GetAll()
    table.sort(tab,function(a,b)return (a:GetRole() or 1) > (b:GetRole() or 1) end)

    for k,v in pairs(tab) do

      for z=1,1 do

        if IsValid(v) then
          local col = Color(20,230,20,ftrans)
          if v:IsBrood() then col = Color(230,20,20,ftrans)
          elseif v:IsSwarm() then col = Color(180,20,20,ftrans)
          end

          if (i%2 == 0) then
            surface.SetDrawColor( 40, 220, 235, ftrans/3 );
            surface.SetTexture( tex2 );
            surface.DrawTexturedRect(10,98+(i*22)-16, self:GetWide()-20, 20 );
          end

          local pcol = SB_COLORS[v:GetNWInt("Donator",0)] or Color(255,255,255,255)

          if (v:SteamID() == "STEAM_0:0:20749231") then
            pcol = Color(255,155,50,255)
          end

          pcol.a = ftrans

          local font = "ChatFont"

          if (v:SteamID() == "STEAM_0:0:20749231") then --Please leave this in, it merely makes the original programmers name orange on the score board
                draw.SimpleTextOutlined(v:GetFName(true).." - {DEVELOPER}",font,14,100+(i*22),pcol,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(0,0,0,ftrans-20))
              else
                draw.SimpleTextOutlined(v:GetFName(true),font,14,100+(i*22),pcol,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(0,0,0,ftrans-20))
              end

          


          if v:Team() == TEAM_SPEC then
            draw.SimpleTextOutlined("SPECTATOR",font,570,100+(i*22),Color(255,255,0,ftrans),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,ftrans-20))
          else
            draw.SimpleTextOutlined(GetRoleName(v:GetRole()or 1),font,570,100+(i*22),col,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,ftrans-20))
          end
          draw.SimpleTextOutlined(v:Ping(),font,730,100+(i*22),Color(245,225,225,ftrans),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,2,Color(0,0,0,ftrans-20))

          i=i+1
        end
      end

    end


  end

    SB_trans = trans

end
vgui.Register( "ScoreBoard2", PANEL, "DPanel" )