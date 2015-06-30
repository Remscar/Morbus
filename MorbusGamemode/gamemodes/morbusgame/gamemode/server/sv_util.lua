
//Utility

function SendAll( msg )
	for k, v in pairs( player.GetAll() ) do
		v:PrintMessage( 3, msg )
	end
end

function SendMsg( ply, msg)
	ply:PrintMessage(3,msg)
end

function SendMsgCenter(ply, msg)
	ply:PrintMessage(4, msg)
end


function WhoIsPlayer(name)
	if !name then return end
	local match = nil
	for k,v in pairs(player.GetAll()) do
		if (v:GetFName() == name) then
			return match
		end
	end
	if !match then return false end
end

function util.AverageSanity()
	local cnt = #player.GetAll()
	local sanity = 0
	for k,v in pairs(player.GetAll()) do
		sanity = sanity + v:GetBaseSanity()
	end
	return sanity / cnt
end