/*--------------------------------------------
MORBUS MESSAGE SYSTEM
--------------------------------------------*/

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


/*--------------------------------------------
SEND MESSAGE
---------------------------------------------*/

function GameMsg(str)

	umsg.Start("game_msg")
	umsg.String(str)
	umsg.Bool(false)
	umsg.End()
end

function ColorMsg(filter, str, clr)
	clr = clr or Color(255,255,255,255)

	umsg.Start("game_msg_color", filter)
	umsg.String(str)
	umsg.Short(clr.r)
	umsg.Short(clr.g)
	umsg.Short(clr.b)
	umsg.End()
end

function PlayerMsg(filter,str,alien)

	umsg.Start("game_msg", filter)
	umsg.String(str)
	umsg.Bool(alien)
	umsg.End()
end

function AlienMsg(filter,str)
	PlayerMsg(filter,str,true)
end




