--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

if not Morbus.Comms then
  Morbus.Comms = {}
end

local Settings = Morbus.Settings
local Comms = Morbus.Comms

local function SendMsgType(msg, plyList, mType)
  if plyList then
    if type(plyList) == "table" then
      for k,v in pairs(plyList) do
        v:PrintMessage(mType, msg)
      end
      return
    end
    plyList:PrintMessage(mType, msg)
    return
  end
  PrintMessage(mType, msg)
end

function Comms:Msg(msg, plyList, mType)
  if not mType then mType = HUD_PRINTTALK end
  SendMsgType(msg, plyList, mType)
end

function Comms:GameMsg(msg, plyList, alien)
  self:Msg(msg, plyList, HUD_PRINTTALK)

  -- Other stuff
end

function Comms:AlienMsg(msg)
  comms:GameMsg(msg, Morbus.AlienList(), true)
end

local nameFuncTable = {
  function(ply) return ply:MorbusName(false) end,
  function(ply) return ply:MorbusName(true) end,
  function(ply) return ply:MorbusName(false) end,
  function(ply) return ply:Nick() end
}
function Comms:ChatName(ply, chatType)
  return nameFuncTable[chatType](ply)
end


local recipientFuncTable = {
  function(sender) return Morbus.ChatFilter(sender) end,
  function(sender) return nil end,
  function(sender) return Morbus.BroodFilter() end,
  function(sender) return Morbus.SpectatorFilter() end
}

function Comms:ChatSendList(ply, chatType)
  return recipientFuncTable[chatType](ply)
end


util.AddNetworkString("Morbus_ChatMsg")

function Comms:ChatMsg(ply, msg, chatType)
  net.Start("Morbus_ChatMsg")
  net.WriteString(self:ChatName(ply, chatType))
  net.WriteString(msg)
  net.Send(self:ChatSendList(ply, chatType))
end



function Comms:GlobalMute(b)
  self._GlobalMute = b
end