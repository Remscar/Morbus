// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
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
