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
/*------------------------------------------------
PLAYER HUD
-------------------------------------------------*/

local trans = 0
local maxtrans = 140

local tex = surface.GetTextureID("vgui/morbus/HPBar")
local tex2 = surface.GetTextureID("vgui/morbus/HPBarCover")

HUDPOS = nil
HUDANG = nil

function MainPlayerHud(nspc)
   if !HUD_DEBUG[2] then return end


   local ply = LocalPlayer()



   if ply:IsGame() && !ply:GetNWBool("alienform",false) then
      DrawDistortion()
   end

   if nspc != true then
      HUDPOS = ply.OLDPOS
      HUDANG = ply.OLDANG
      -- if ply:IsSwarm() then
      --    return
      -- end
   end

   local status = !SB_status


   if status && trans < maxtrans then
      trans = math.Clamp(trans+9,0,maxtrans)
   elseif status == false && trans > 0 then
      trans = math.Clamp(trans-9,0,maxtrans)
   end

   local ftrans = 0
   local mul = math.sin(RealTime())/6 + math.cos(RealTime())/6
   if trans > 0 then
      ftrans = math.Clamp(trans + (trans*(mul)),trans-50,trans+50)
   end

   local BoxSize = 512
   local Offset = BoxSize / 2;

   local ang = Angle((HUDANG.p),(HUDANG.y),0)
   local pos = HUDPOS
   pos = pos + ang:Forward() * 50



   if trans > 0 then


      ang:RotateAroundAxis( ang:Right(), 90 )
      ang:RotateAroundAxis( ang:Up(), -90 )
      ang:RotateAroundAxis( ang:Right(), -20 )
      --ang:RotateAroundAxis( ang:Forward(), -10 )



      if !(ply:Team() == TEAM_SPEC) then

         cam.Start3D2D( pos, ang, 0.0465 )

         cam.IgnoreZ(true)
         

         //------------HP BAR
         local sw,sy = ScrW(),ScrH()
         local xf = sw/sy
         local yf
         if xf == 1.25 then
            xf = 9.8
            yf = 3.3
         elseif xf == (1+1/3) then
            xf = 5.3
            yf = 2.6
         elseif xf == 1.6 then
            xf = 4.9
            yf = 2.8
         else
            xf = 4.1
            yf = 2.7
         end

         local wt = 336
         local h = 34
         local x = -wt-130
         local y = 310


         surface.SetDrawColor( 40, 220, 235, ftrans );
         surface.SetTexture( tex );
         surface.DrawTexturedRect( x,y, wt, h );

         local hp = ply:Health()
         local ah = 0
         if ply:IsBrood() && ply:GetNWBool("alienform",false) then
            if Morbus.Upgrades[UPGRADE.HEALTH] then
               ah = Morbus.Upgrades[UPGRADE.HEALTH] or 0
            end
         end
         local hpmax = 100+( ah * UPGRADE.HEALTH_AMOUNT)
         local ratio = math.Clamp(hp/hpmax,0,1)

         surface.SetDrawColor( 20, 220, 35, ftrans+50 );
         surface.DrawRect(x+2,y+2,wt*ratio-4,h-4)

         surface.SetDrawColor( 40, 220, 235, 100 );
         surface.SetTexture( tex2 );
         surface.DrawTexturedRect(x+1,y+1,wt-2,h-2)

         wt = 336

         draw.SimpleTextOutlined(ply:GetFName() || "","DSMedium",x+(wt/2),y+(h/2)-2,Color(125,125,125, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,200))

         
         //STATUS BAR
         w = 336
         h = 34
         x,y = -w-130,345

         surface.SetDrawColor( 40, 220, 235, ftrans );
         surface.SetTexture( tex );
         surface.DrawTexturedRect( x,y, w, h );

         draw.SimpleTextOutlined(ply:GetRoleName(),"DSHuge",x+(w/2),y+(h/2)-2,Color(55,255,55, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50,255))

         w = 240
         h = 22
         x,y = -w-190,285

         if GetGlobalInt("nightmare",0) == 0 && !ply:IsSwarm() then

            surface.SetDrawColor( 0, 240, 240, ftrans );
            surface.SetTexture( tex );
            surface.DrawTexturedRect( x,y, w, h );

         
            local ratio = math.Clamp(ply.Battery/LIGHT_BATTERY,0,1)

            surface.SetDrawColor( 200, 220, 35, ftrans );
            surface.SetTexture( tex );
            surface.DrawRect( x+2,y+2, ratio*w-4, h-4 );

            surface.SetDrawColor( 40, 220, 235, ftrans-20 );
            surface.SetTexture( tex2 );
            surface.DrawTexturedRect(x+1,y+1,w-2,h-2)
         end

         
         cam.End3D2D()
      end

      

      local ang = Angle((HUDANG.p),(HUDANG.y),0)
      local pos = HUDPOS
      pos = HUDPOS + ang:Forward() * 50

      if LocalPlayer():IsSpec() then
         pos = pos + ang:Forward() * 20
      end


      ang:RotateAroundAxis( ang:Right(), 110 )
      ang:RotateAroundAxis( ang:Up(), -90 )
      --ang:RotateAroundAxis( ang:Right(), -20 )

      cam.Start3D2D( pos, ang, 0.0465)
      cam.IgnoreZ(true)


      w = 180
      h = 34
      x,y = -90,-414


      surface.SetDrawColor( 40, 220, 235, ftrans );
      surface.SetTexture( tex );
      surface.DrawTexturedRect( x,y, w, h );

      local rawend = GetGlobalFloat("morbus_round_end", 0)
      local roundend = string.FormattedTime(rawend - CurTime(), "%02i:%02i")
      if !rawend or ( rawend and rawend <= CurTime()) then roundend = "00:00" end

      draw.SimpleTextOutlined(roundend,"DSHuge",x+(w/2),y+(h/2)-2,Color(200,200,200, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50,trans))


      w = 128
      h = 16
      x,y = -64,-379


      surface.SetDrawColor( 40, 220, 235, ftrans );
      surface.SetTexture( tex );
      surface.DrawTexturedRect( x,y, w, h );

      draw.SimpleTextOutlined(ROUND_TEXT[GetRoundState()],"DSTiny",x+(w/2),y+(h/2)-1,Color(200,200,200, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50, trans))


      if !(ply:Team() == TEAM_SPEC) && !(ply:IsSwarm()) then
         // MISSION BAR @ TOP
         w = 220
         h = 34

         x,y = -400,-414


         surface.SetDrawColor( 40, 220, 235, ftrans );
         surface.SetTexture( tex );
         surface.DrawTexturedRect( x,y, w, h );

         local Mission_End = Morbus.Mission_End - CurTime()
         local Mission_Color = Color(255,255,255, trans)
         if Mission_End < 0 && Morbus.Mission != MISSION_NONE && Morbus.Mission != MISSION_KILL then Mission_Color = Color(255,20,20,255) 
         end

         draw.SimpleTextOutlined(GetMissionTitle(Morbus.Mission),"DSLarge",x+(w*1.2/3),y+(h/2)-1,Mission_Color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50,255))

         Mission_End = math.ceil(Mission_End)
         if Mission_End < 0 then Mission_End = "" else Mission_End = math.abs(Mission_End) end
         if Morbus.Mission == 0 then Mission_End = "" end
         if ply:GetRole() != ROLE_HUMAN then Mission_End = "" end

         draw.SimpleTextOutlined(Mission_End,"DSMedium",x+(w*4/5),y+(h/2)-1,Color(200,200,200, ftrans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50, trans))

         if (ply:IsBrood()) then
            local respawns = tostring(GetGlobalInt("morbus_swarm_spawns",0))

            draw.SimpleTextOutlined(respawns,"DSMedium",x+(w*4/5),y+(h/2)-1,Color(200,200,200, ftrans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50, trans))
         end

         w = 32
         h = 31
         x,y = -400+4,-412

         if !ply:IsBrood() || (ply:IsBrood() && Morbus.CanTransform) then
            surface.SetDrawColor( 255, 255, 255, ftrans );
            surface.SetTexture( MissionIcon[Morbus.Mission+1]);
            surface.DrawTexturedRect( x,y, w, h );
         end

      else
         w = 220
         h = 34

         x,y = -400,-414


         surface.SetDrawColor( 40, 220, 235, trans );
         surface.SetTexture( tex );
         surface.DrawTexturedRect( x,y, w, h );

         draw.SimpleTextOutlined("LIVES:","DSLarge",x+(w*1.2/3),y+(h/2)-1,Mission_Color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50,255))

         local respawns = tostring(GetGlobalInt("morbus_swarm_spawns",0))

         draw.SimpleTextOutlined(respawns,"DSMedium",x+(w*4/5),y+(h/2)-1,Color(200,200,200, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50, ftrans))

         w = 32
         h = 31
         x,y = -400+4,-412

         surface.SetDrawColor( 255, 255, 255, ftrans );
         surface.SetTexture( MissionIcon[6]);
         surface.DrawTexturedRect( x,y, w, h );
      end


      cam.IgnoreZ(false)
      cam.End3D2D()

   end
end

hook.Add("PostDrawViewModel","HoloHud",MainPlayerHud)
--hook.Remove("PostDrawViewModel", "HoloHud")

--"PostDrawOpaqueRenderables"s


/*

function MainPlayerHud(ply)

   local h = 50
   local w = 620
   local x = ScrW()/2 - w/2
   local margin = 2
   local w2 = 140
   local x2 = ScrW()/2 - w2/2
   local h2 = 70
   local x3 = x+h-margin*2
   local x4 = x+h*3.5
   local x5 = ScrW()/2 + h*3.55
   local PlayerWeight = ply:GetWeight()

   ---------------TOP BARS
   draw.RoundedBox(4,x,-4,w,h,Color(0,0,0,255))
   draw.RoundedBox(4,x+margin*2,-4,w-margin*4,h-margin*2,Color(80,80,80,255))
   draw.RoundedBox(4,x2,-4,w2,h2,Color(0,0,0,255))
   draw.RoundedBox(4,x2+margin*2,-4,w2-margin*4,h2-margin*2,Color(80,80,80,255))

   
   ----------------MISSION DISPLAY
   draw.RoundedBox(2,x+margin*4,margin*2,h-margin*8,h-margin*8,Color(0,0,0,255))
   surface.SetTexture(MissionIcon[Morbus.Mission+1])
   surface.SetDrawColor(255,255,255,255)
   surface.DrawTexturedRect(x+margin*5, margin*3,h-margin*10,h-margin*10)
   local Mission_End = Morbus.Mission_End - CurTime()
   local Mission_Color = Color(255,255,255,255)
   if Mission_End < 0 && Morbus.Mission != MISSION_NONE && Morbus.Mission != MISSION_KILL then Mission_Color = Color(255,20,20,255) end
   draw.SimpleTextOutlined(GetMissionTitle(Morbus.Mission),"DSLarge",x3,margin*2,Mission_Color, 0, 0,1,Color(0,0,0,255))
   
   Mission_End = math.ceil(Mission_End)
   if Mission_End < 0 then Mission_End = "" else Mission_End = math.abs(Mission_End) end
   if Morbus.Mission == 0 then Mission_End = "" end
   if ply:GetRole() != ROLE_HUMAN then Mission_End = "" end
   draw.SimpleTextOutlined(Mission_End,"DSLarge",x4+margin*4,margin*2,Color(205,55,55,255), 0, 0,1,Color(0,0,0,255))

   --------------------ROLE DISPLAY
   draw.SimpleTextOutlined(ply:GetRoleName(),"DSLarge",x5+margin*4,margin*2,Color(55,255,55,255), 1, 0,1,Color(0,0,0,255))

   --------------------CENTER TIMER
   draw.SimpleTextOutlined(ROUND_TEXT[GetRoundState()],"DSSmall",ScrW()/2,margin,Color(255,255,255,255), 1, 0,1,Color(0,0,0,255))
   local rawend = GetGlobalFloat("morbus_round_end", 0)
   local roundend = string.FormattedTime(rawend - CurTime(), "%02i:%02i")
   if !rawend or ( rawend and rawend <= CurTime()) then roundend = "00:00" end
   draw.SimpleTextOutlined(roundend,"DSHuge",ScrW()/2,margin*8,Color(255,255,255,255), 1, 0,1,Color(0,0,0,255))
   


   --------------------BOTTOM BAR

   h = 31
   h2 = 50
   w = 620
   x = ScrW()/2 - w/2
   w2 = 60
   x2 = ScrW()/2 - w2/2
   local y = ScrH()- h
   local y2 = ScrH() - h2
   local ch = ScrH() + 4
   local w3 = h-margin*6
   local w4 = w/2-w2/2-margin*10




   draw.RoundedBox(4,x,y,w/2-w2/2,y,Color(0,0,0,255))
   draw.RoundedBox(4,x+margin*2,y+margin*2,w/2-margin*4-w2/2,h+margin*2,Color(80,80,80,255))
   draw.RoundedBox(4,x+w/2+w2/2,y,w/2-w2/2,y,Color(0,0,0,255))
   draw.RoundedBox(4,x+w/2+w2/2+margin*2,y+margin*2,w/2-margin*4-w2/2,h+margin*2,Color(80,80,80,255))

   draw.RoundedBox(4,x2-margin*2,y2,w2+margin*4,h2+margin*2,Color(0,0,0,255))
   draw.RoundedBox(4,x2,y2+margin*2,w2,h2+margin*2,Color(80,80,80,255))

   draw.RoundedBox(0,x+margin*4,y+margin*4,w/2-w2/2-margin*8,w3,Color(0,0,0,255))

   surface.SetTexture(ICON_WEIGHT)
   surface.SetDrawColor(2*ply:GetWeight(),255-(2.5*ply:GetWeight()),0,255)
   surface.DrawTexturedRect(x2+margin*5,y2+margin*4,w2-margin*10,w2-margin*10)

   local HMax = 100 //Max Health, soon to change X:
   local HP = ply:Health()
   local ratio = HP/HMax
   local length = w4 * ratio

   draw.RoundedBox(0,x+margin*5,y+margin*5,w4,w3-margin*2,Color(90,0,0,255))
   draw.RoundedBox(0,x+margin*5,y+margin*5,w4,w3-margin*6,Color(120,0,0,255))
   draw.RoundedBox(0,x+margin*5,y+margin*5,length,w3-margin*2,Color(0,180,0,255))
   draw.RoundedBox(0,x+margin*5,y+margin*5,length,w3-margin*6,Color(0,205,0,255))

   x = ScrW()/2 + w2/2

   draw.RoundedBox(0,x+margin*4,y+margin*4,w/2-w2/2-margin*8,w3,Color(0,0,0,255))
   local hide_text = true
   local Extra,Amax,Ammo
   ratio = 1

if (ply:GetActiveWeapon()) && (ply:GetActiveWeapon().Primary) then
   if ply:GetActiveWeapon().Primary.ClipSize > 0 then
      AMax = ply:GetActiveWeapon().Primary.ClipSize or 1
      Ammo = ply:GetActiveWeapon():Clip1() or 1
      Extra = ply:GetActiveWeapon():Ammo1() or 1
      ratio = Ammo/AMax
      hide_text = false
   end
end

   length = w4 * ratio

   draw.RoundedBox(0,x+margin*5,y+margin*5,w4,w3-margin*2,Color(40,40,40,255))
   draw.RoundedBox(0,x+margin*5,y+margin*5,w4,w3-margin*6,Color(60,60,60,255))
   draw.RoundedBox(0,x+margin*5+(w4 - length),y+margin*5,length,w3-margin*2,Color(140,140,140,255))
   draw.RoundedBox(0,x+margin*5+(w4 - length),y+margin*5,length,w3-margin*6,Color(160,160,160,255))

   x = ScrW()/2 + w2*5 - margin
   if !hide_text then
      draw.SimpleTextOutlined(Ammo.." + "..Extra, "DSMedium",x,ScrH()-margin*7 - 1,Color(255,155,0,255),2,1,1,Color(0,0,0,255) )
   end

end

*/