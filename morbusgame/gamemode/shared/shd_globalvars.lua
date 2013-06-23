GLOBAL_VARS = {} -- Table that stores all the variables
--table structure {"Name","Value",Type,SyncTime}

TYPE_NUMBER = 1
TYPE_STRING = 2

if CLIENT then

	function RecieveGlobal(data)
		local name = data:ReadString()
		local type = data:ReadChar()
		local value = data:ReadString()

		if type == 1 then
			value = tonumber(value)
		end

		if GLOBAL_VARS[name] then
			GLOBAL_VARS[name].Value = value
			return
		end

		local tab = {}
		tab["Name"] = name
		tab["Value"] = value
		tab["Type"] = type -- unneeded but i like consistency
		GLOBAL_VARS[name] = tab
	end
	usermessage.Hook("SendGlobal",RecieveGlobal)

end

function GetGlobalVar(name,default)
	if !name then return end
	local def = default or 0

	if !GLOBAL_VARS[name] then
		return def
	end

	return GLOBAL_VARS[name].Value
end
