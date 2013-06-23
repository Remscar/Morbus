/*Dear person who is reading this,
Unforunatley for me, source engine
and garrysmod are generally stupid.
I used to use SetGlobalInt, SetGlobalString,
SetGLobalFloat, like any other person
who wants to easily send a variables to
clients, yet still control it via server.
This worked most of the time, but for some
god awful stupid fucking reason, it doesnt
on some servers. So to prevent this ridiculously
retarded ass error where it does jack fucking shit
with global variables, i have to write my own
fucking library to make up for it. Fuck me.*/



function SetGlobalVar(name,value,type,synctime)
	if (!name || !value) then return end

	if GLOBAL_VARS[name] then
		GLOBAL_VARS[name].Value = value
		MsgN("Updated Global Variable: "..name.." to "..tostring(value))
		return
	end

	local var = {}
	var["Name"] = name
	var["Value"] = value
	var["Type"] = type or 2
	var["Sync"] = synctime or 30
	var["NextSync"] = 0

	GLOBAL_VARS[name] = var
	MsgN("Added Global Variable: "..name.." which is "..tostring(value))
	timer.Simple(2, function() SendGlobalVar(var) end)
end

function SendGlobalVar(tab)
	if !tab then return end
	umsg.Start("SendGlobal")
	umsg.String(tab.Name)
	umsg.Char(tab.Type)
	umsg.String(tab.Value)
	umsg.End()
end

function SendPlayerGlobalVar(tab,ply)
	if !tab then return end
	umsg.Start("SendGlobal",ply)
	umsg.String(tab.Name)
	umsg.Char(tab.Type)
	umsg.String(tab.Value)
	umsg.End()
end

function UpdateGlobalVars()
	for k,v in pairs(player.GetAll()) do
		RequestAllGlobals(v)
	end
end

function RequestAllGlobals(ply)
	if !ply then return end
	if #GLOBAL_VARS < 1 then return end

	for k,v in pairs(GLOBAL_VARS) do
		SendPlayerGlobalVar(v,ply)
	end
end
concommand.Add("sync_vars",RequestAllGlobals)


function GlobalVarUpdater()
	for k,v in pairs(GLOBAL_VARS) do
		if (v.NextSync < CurTime()) then
			SendGlobalVar(v)
			v.NextSync = CurTime() + v.Sync
		end
	end
end
hook.Add("Think","GlobalVarUpdater",GlobalVarUpdater)
