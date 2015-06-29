// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/*--------------------------------------------
MORBUS COMMUNICATION SYSTEM
--------------------------------------------*/

function ChangeMuteState(ply,cmd,args)
  if #args < 1 then
    SendMsg(ply,"0-None 1-Alive Only 2-Spectators Only 3-No Spectators 4-No Alien Chat + Alive Only")
    return
  end

  local n = tonumber(args[1])
  ply:SetNWInt("Mute_Status",n)

end
concommand.Add("morbus_mute_status",ChangeMuteState)

ISLOCALCHAT = true
NO_OOCCHAT = false
/*--------------------------------------------------
CHAT FUNCTIONS
---------------------------------------------------*/

function SendOOCChat(ply,text)
  if NO_OOCCHAT && (GetRoundState() == ROUND_ACTIVE) then
    SendMsg( ply, "OOC Chat is disabled!")
    return
  end
  umsg.Start("SendOOCChat")
  umsg.String(ply:Nick())
  umsg.String(ply:GetFName())
  umsg.String(text)
  umsg.End()
end

function SendLocalChat(ply,text)
  local filter = RecipientFilter()
  for k,v in pairs(player.GetAll()) do
    if (v:GetShootPos():Distance(ply:GetShootPos()) < 800) then
      filter:AddPlayer(v)
    end
  end
  umsg.Start("SendLocalChat",filter)
  umsg.String(ply:GetFName())
  umsg.String(text)
  umsg.End()
end

function SendSpecChat(ply,text)
  local filter = RecipientFilter()
  for k,v in pairs(player.GetAll()) do
    if v:Team() == TEAM_SPEC then
      filter:AddPlayer(v)
    end
  end
  umsg.Start("SendSpecChat",filter)
  umsg.String(ply:GetFName())
  umsg.String(text)
  umsg.End()
end



function GM:PlayerSay(ply, text, to_all) -- Shitty chat shit 
  --ToDo: REDO THIS
   if not ValidEntity(ply) then return end
   if ply.Gagged then return "" end -- for later use

   to_all = !to_all

   if not to_all and GetRoundState() == ROUND_ACTIVE then
      if ply:IsAlien() && ply:Team() != TEAM_SPEC then
         AlienChatMsg(ply, text)
      else
         
      end

      return ""
   end

   if ply:Alive() != true then
     if string.sub(text,0,2) == "//" then
      SendOOCChat(ply,string.sub(text,3))
      return ""
     end

     

    if text == "/rtv" then
      RTV(ply)
      return ""
    end

    if text == "/spec" then
      ToggleSpec(ply)
      return ""
    end

    if text == "/light" then
      GAMEMODE:PlayerSwitchFlashlight(ply,true)
      return ""
    end

    if text == "/version" then
      ShowVersion(ply)
      return ""
    end

    if text == "/forcertv" then
      ForceMap(ply)
      return ""
    end

    if text == "/remscar" then
      WhoIsRemscar()
      return ""
    end

    if text == "/nightmare" then
      ChangeNightmare(ply)
      return ""
    end

    if GetRoundState() != ROUND_ACTIVE then
      SendOOCChat(ply," "..text)
      return ""
    end

    if !(ply:Team() == TEAM_SPEC) then
    else
      SendSpecChat(ply," "..text)
      return ""
    end

     SendMsg( ply, "You can't talk when your dead!") 
     return "" 
   end

   if !ply:IsSwarm() && !ply:GetNWBool("alienform",false) then
    if text == "/yes" then
      if ply.Gender == GENDER_FEMALE then
        ply:EmitSound(table.Random(Response.Female.Yes),100,100)
      else
        ply:EmitSound(table.Random(Response.Male.Yes),100,100)
      end
      return ""
    elseif text == "/taunt" then
      if ply.Gender == GENDER_FEMALE then
        ply:EmitSound(table.Random(Tuants.Female),100,100)
      else
        ply:EmitSound(table.Random(Tuants.Male),100,100)
      end
      return ""
    end
  end

  if text == "/version" then
    ShowVersion(ply)
    return ""
  end

  if text == "/spec" then
    ToggleSpec(ply)
    return ""
  end

  if text == "/light" then
    GAMEMODE:PlayerSwitchFlashlight(ply,true)
    return ""
  end

  if text == "/forcertv" then
    ForceMap(ply)
    return ""
  end

  if text == "/remscar" then
    WhoIsRemscar()
    return ""
  end

  if text == "/nightmare" then
    ChangeNightmare(ply)
    return ""
  end

  if string.sub(text,0,2) == "//" then
    SendOOCChat(ply,string.sub(text,3))
    return ""
  end

  if (GetRoundState() != ROUND_ACTIVE) then
    SendOOCChat(ply," "..text)
    return ""
  end

  if !(ply:Team() == TEAM_SPEC) then
    SendLocalChat(ply," "..text)
  else
    SendSpecChat(ply," "..text)
  end
  return ""

end

local mute_all = false
function MuteForRestart(state)
  mute_all = state
end

function GM:PlayerCanHearPlayersVoice(listener, speaker)
 
  if mute_all then
    return false,false
  end
 
  if (speaker:Team() == TEAM_SPEC && listener:Team() == TEAM_SPEC) && ((listener:GetNWInt("Mute_Status",0) == 0 || listener:GetNWInt("Mute_Status",0) == 2)) then
    return true,false
  end
 
  if !listener:Alive() then
    if !listener:IsSwarm() && GetRoundState() == ROUND_ACTIVE && listener:IsGame() then
      return false,false
    end
  end
 
  if speaker:IsAlien() && (speaker.alien_voice==false) then
    if listener:IsAlien() && (listener:GetNWInt("Mute_Status",0) == 0 || listener:GetNWInt("Mute_Status",0) == 3 || listener:GetNWInt("Mute_Status",0) == 1) then
      return true,false
    else
      return false,false
    end
  end
 
  if (listener:GetShootPos():Distance(speaker:GetShootPos()) < 2000) && (listener:Team() == TEAM_SPEC) && (GetRoundState() == ROUND_ACTIVE) && (ISLOCALCHAT == true) && ((listener:GetNWInt("Mute_Status",0) == 0 || listener:GetNWInt("Mute_Status",0) == 1 || listener:GetNWInt("Mute_Status",0) == 4)) then
    return true,true
  end
 
  if (listener:GetShootPos():Distance(speaker:GetShootPos()) < 750) && (speaker:Team() != TEAM_SPEC) && (GetRoundState() == ROUND_ACTIVE) && (ISLOCALCHAT == true) && ((listener:GetNWInt("Mute_Status",0) == 0 || listener:GetNWInt("Mute_Status",0) == 1 || listener:GetNWInt("Mute_Status",0) == 4)) then
    return true,true
  end
 
  if (ISLOCALCHAT == false) then
    return true,false
  end
 
  if (GetRoundState() != ROUND_ACTIVE) then
    return true,false
  end
 
  return false,false
end

function ShowVersion(ply)
  SendMsg(ply,"Morbus "..GM_VERSION.." by R".."e".."m".."s".."c".."a".."r")
end

local function SwitchVoice(ply)
  if ply:IsSuperAdmin() then
    ISLOCALCHAT = !ISLOCALCHAT
    SendAll("OOC Voice Chat Disabled: "..tostring(ISLOCALCHAT))
  end
end
concommand.Add("Switch_Voice",SwitchVoice)

local function SwitchChat(ply)
  if ply:IsSuperAdmin() then
    NO_OOCCHAT = !NO_OOCCHAT
    SendAll("OOC Text Chat Disabled: "..tostring(NO_OOCCHAT))
  end
end
concommand.Add("Switch_Chat",SwitchChat)

local function SendAlienVoiceState(speaker, state)
  local rf = AlienFilter()

  umsg.Start("avstate", rf)
  umsg.Short(speaker:EntIndex())
  umsg.Bool(state)
  umsg.End()
end

function SetAlienVoiceState(ply, cmd, args)
  if not ValidEntity(ply) or not ply:IsActiveAlien() then return end
  if not #args == 1 then return end
  local state = tonumber(args[1])

  ply.alien_voice = (state == 1)

  SendAlienVoiceState(ply, ply.alien_voice)
end
concommand.Add("morbus_alien_voice", SetAlienVoiceState)


function AlienChatMsg(sender,str)

  umsg.Start("alien_chat", AlienFilter())
  umsg.Entity(sender)
  umsg.String(str)
  umsg.End()
end


function ToggleSpec(ply)
  ply.WantsSpec = !ply.WantsSpec
  local msg = "You will now remain a spectator"

  if !ply.WantsSpec then
    msg = "You can now respawn"
  end
  ply:SetRole(ROLE_SWARM)
  SendMsg(ply,msg)
  ply:MakeSpec()
  ply:Kill()
end

function TestSpec(ply)
  ply:SetRole(ROLE_SWARM)
  ply:MakeSpec(true)
  ply:Kill()
end
/*--------------------------------------------
UTILITY FILTERS
---------------------------------------------*/


function GetPlayerFilter(req)
  local filter = RecipientFilter()
  for k,v in pairs(player.GetAll()) do
    if ValidEntity(v) and req(v) then
      filter:AddPlayer(v)
    end
  end
  return filter
end




