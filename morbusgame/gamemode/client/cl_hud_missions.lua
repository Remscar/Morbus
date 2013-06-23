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
/*-----------------------------
Mission notifiers on your hud
made at 5:24 AM
---------------------------*/

NEED_LOC = Vector(0,0,0)

function MissionLocation(ply) -- HOok into HUDDraw
	if Morbus.Mission == MISSION_KILL ||  Morbus.Mission == MISSION_NONE then return end
	if !ply:Alive() then return end

	local pos = GetGlobalVector(NEED_ENTS[Morbus.Mission][1])
	local distance = pos:Distance( ply:GetPos( ) )
	local size = math.Clamp(25 + 5*(32*180)/( distance + 31),25,100)
	local toscreen = BindToScreen(pos)
	
	surface.SetTexture(MissionIcon[Morbus.Mission+1])
	surface.SetDrawColor(255,255,255,200)
	surface.DrawTexturedRect( toscreen.x - size/2,toscreen.y - size/2, size, size )

end

function BindToScreen(vec)	
	local toscreen = vec:ToScreen()
	toscreen.x = math.Clamp(toscreen.x,0,ScrW())
	toscreen.y = math.Clamp(toscreen.y,0,ScrH())
	return toscreen
end
/*
timer.Create("Second4Impulse",4,0,function()
if (GetRoundState() != ROUND_ACTIVE) then return end
	if !MISSION_LOCS then -- I dont want to run this every time
		 -- Call the first time the round is active
		MISSION_LOCS = {}

		local buffer = {} -- speed
		for i=1,4 do	
			MISSION_LOCS[i] = {}
			MISSION_LOCS[i] = ents.FindByClass(NEED_ENTS[i][1])
			buffer = ents.FindByClass(NEED_ENTS[i][2])
			table.Add(MISSION_LOCS[i],buffer)
			buffer = {}
		end
	else
		for i=1,4 do
			local ent = MISSION_LOCS[i][math.random( 1,table.Count(MISSION_LOCS[i]) )]
			local need_min, need_max = ent:WorldSpaceAABB()
			local need_pos = need_max - ((need_max - need_min) / 2)
			NEED_LOC = need_pos
		end
	end
end)
*/