// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
/*------------------------------------------------
PLAYER HUD
-------------------------------------------------*/

local trans = 0
local maxtrans = 140

local tex = surface.GetTextureID("vgui/morbus/HPBar")
local tex2 = surface.GetTextureID("vgui/morbus/HPBarCover")



function MainPlayerHud()
   if !HUD_DEBUG[2] then return end


   local ply = LocalPlayer()

   

   -- Scoreboard stuff

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

   --Positioning

   local HumanR,HumanG,HumanB = 40, 220, 235
   local AlienR,AlienG,AlienB = 255, 55, 55


          if !GetConVar("morbus_alienhud_purple"):GetBool() then
            AlienR = 255
            AlienG = 55
            AlienB = 55
          else
            AlienR = 215
            AlienG = 55
            AlienB = 255
          end


   local ang = EyeAngles()
   local pos = EyePos() + ang:Forward() * 50

   if trans > 0 then


      ang:RotateAroundAxis( ang:Right(), 90 )
      ang:RotateAroundAxis( ang:Up(), -90 )
      ang:RotateAroundAxis( ang:Right(), -20 )



      if !(ply:Team() == TEAM_SPEC) then

         cam.Start3D2D( pos, ang, 0.0585 )
         cam.IgnoreZ(true)
         

         //------------HP BAR

         local wt = 336
         local h = 34
         local x = -wt-130
         local y = 310
         if ply:IsAlien() then
            if !GetConVar("morbus_alienhud_disable"):GetBool() then
               surface.SetDrawColor( AlienR, AlienG, AlienB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, wt, h )
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, wt, h )
            end
         else
            surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
            surface.SetTexture( tex )
            surface.DrawTexturedRect( x,y, wt, h )
         end
         local hp = ply:Health()
         local ah = 0

         if ply:IsBrood() && ply:GetNWBool("alienform",false) then
            if Morbus.Upgrades[UPGRADE.HEALTH] then
               ah = Morbus.Upgrades[UPGRADE.HEALTH] or 0
            end
         end

         local hpmax = 100+( ah * UPGRADE.HEALTH_AMOUNT)
         local ratio = math.Clamp(hp/hpmax,0,1)

         surface.SetDrawColor( 0, 255, 0, ftrans+100 );
         surface.DrawRect(x+2,y+2,wt*ratio-4,h-4)

         if ply:IsAlien() then
            if !GetConVar("morbus_alienhud_disable"):GetBool() then
               surface.SetDrawColor( AlienR, AlienG, AlienB, 100 )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, wt, h )
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, 100 )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, wt, h )
            end
         else
            surface.SetDrawColor( HumanR, HumanG, HumanB, 100 )
            surface.SetTexture( tex2 )
            surface.DrawTexturedRect(x+1,y+1,wt-2,h-2)
         end

         wt = 336

         draw.SimpleTextOutlined(ply:GetFName() || "","DSMedium",x+(wt/2),y+(h/2)-2,Color(125,125,125, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(0,0,0,200))

         


         //------------STATUS BAR
         w = 336
         h = 34
         x,y = -w-130,345

         if ply:IsAlien() then
            if !GetConVar("morbus_alienhud_disable"):GetBool() then
               surface.SetDrawColor( AlienR, AlienG, AlienB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            end
         else
            surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
            surface.SetTexture( tex )
            surface.DrawTexturedRect( x,y, w, h )
         end

         if GetRoundState() == ROUND_WAIT then
            draw.SimpleTextOutlined("Deathmatch","DSHuge",x+(w/2),y+(h/2)-2,Color(200,55,55, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(95,50,50,255))
         else
            draw.SimpleTextOutlined(ply:GetRoleName(),"DSHuge",x+(w/2),y+(h/2)-2,Color(55,255,55, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50,255))
         end
         w = 240
         h = 22
         x,y = -w-190,285



         //------------ BATTERY

         if !GetGlobalBool("mutator_nightmare",false) && !ply:IsSwarm() then

            surface.SetDrawColor( 0, 240, 240, ftrans );
            surface.SetTexture( tex );
            surface.DrawTexturedRect( x,y, w, h );

         
            local ratio = math.Clamp(ply.Battery/LIGHT_BATTERY,0,1)

            surface.SetDrawColor( 200, 220, 35, ftrans );
            surface.SetTexture( tex );
            surface.DrawRect( x+2,y+2, ratio*w-4, h-4 );

            if ply:IsAlien() then
               if !GetConVar("morbus_alienhud_disable"):GetBool() then
                  surface.SetDrawColor( AlienR, AlienG, AlienB, ftrans )
                  surface.SetTexture( tex2 );
                  surface.DrawTexturedRect(x+1,y+1,w-2,h-2)
               else
                  surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
                  surface.SetTexture( tex2 );
                  surface.DrawTexturedRect(x+1,y+1,w-2,h-2)
               end
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans-20 )
               surface.SetTexture( tex2 );
               surface.DrawTexturedRect(x+1,y+1,w-2,h-2)
            end
         end

         
         cam.End3D2D()
      end

   

      local ang = EyeAngles()
      local pos = EyePos() + ang:Forward() * 50

      ang:RotateAroundAxis( ang:Right(), 110 )
      ang:RotateAroundAxis( ang:Up(), -90 )
      
      cam.Start3D2D(pos,ang,0.0585)
      cam.IgnoreZ(true)


      w = 180
      h = 34
      x,y = -90,-414

      if ply:IsAlien() then
            if !GetConVar("morbus_alienhud_disable"):GetBool() then
               surface.SetDrawColor( AlienR, AlienG, AlienB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            end
      else
         surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
         surface.SetTexture( tex )
         surface.DrawTexturedRect( x,y, w, h )
      end
      local rawend = GetGlobalFloat("morbus_round_end", 0)
      local roundend = string.FormattedTime(rawend - CurTime(), "%02i:%02i")
      if !rawend or ( rawend and rawend <= CurTime()) then roundend = "00:00" end

      draw.SimpleTextOutlined(roundend,"DSHuge",x+(w/2),y+(h/2)-2,Color(200,200,200, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50,trans))


      w = 128
      h = 16
      x,y = -64,-379

      if ply:IsAlien() then
            if !GetConVar("morbus_alienhud_disable"):GetBool() then
               surface.SetDrawColor( AlienR, AlienG, AlienB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            end
      else
         surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
         surface.SetTexture( tex )
         surface.DrawTexturedRect( x,y, w, h )
      end
      draw.SimpleTextOutlined(ROUND_TEXT[GetRoundState()],"DSTiny",x+(w/2),y+(h/2)-1,Color(200,200,200, trans),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,Color(50,50,50, trans))


      if !(ply:Team() == TEAM_SPEC) && !(ply:IsSwarm()) then
         // MISSION BAR @ TOP
         w = 220
         h = 34

         x,y = -400,-414

      if ply:IsAlien() then
            if !GetConVar("morbus_alienhud_disable"):GetBool() then
               surface.SetDrawColor( AlienR, AlienG, AlienB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            end
      else
         surface.SetDrawColor( HumanR, HumanG, HumanB, ftrans )
         surface.SetTexture( tex )
         surface.DrawTexturedRect( x,y, w, h )
      end

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


      if ply:IsAlien() then
            if !GetConVar("morbus_alienhud_disable"):GetBool() then
               surface.SetDrawColor( AlienR, AlienG, AlienB, trans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            else
               surface.SetDrawColor( HumanR, HumanG, HumanB, trans )
               surface.SetTexture( tex )
               surface.DrawTexturedRect( x,y, w, h )
            end
      else
         surface.SetDrawColor( HumanR, HumanG, HumanB, trans )
         surface.SetTexture( tex )
         surface.DrawTexturedRect( x,y, w, h )
      end
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

hook.Add("PostDrawTranslucentRenderables","HoloHud",MainPlayerHud)
