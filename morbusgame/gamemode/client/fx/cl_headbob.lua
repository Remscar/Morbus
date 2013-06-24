--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

local HBAP = 0
local HBAY = 0
local HBAR = 0
local HBPX = 0
local HBPY = 0
local HBPZ = 0
local HEADBOB_ON = true

function HeadBob(pl, pos, ang, fov)
	local v = {}

	v.pos = pos
	v.ang = ang
	v.fov = fov

	if pl:IsOnGround() && HEADBOB_ON then
		if pl:KeyDown(IN_FORWARD) || pl:KeyDown(IN_BACK) || pl:KeyDown(IN_MOVELEFT) || pl:KeyDown(IN_MOVERIGHT) then
			HBPZ = HBPZ + (10 / 1) * FrameTime()
		end
		if pl:KeyDown(IN_FORWARD) then
			if HBAP < 1.5 then
				HBAP = HBAP + 0.05 * 1
			end
		else
			if HBAP > 0 then
				HBAP = HBAP - 0.05 * 1
			end
		end
		if pl:KeyDown(IN_BACK) then
			if HBAP > -1.5 then
				HBAP = HBAP - 0.05 * 1
			end
		else
			if HBAP < 0 then
				HBAP = HBAP + 0.05 * 1
			end
		end
		if pl:KeyDown(IN_MOVELEFT) then
			if HBAR > -1.5 then
				HBAR = HBAR - 0.07 * 1
			end
		else
			if HBAR < 0 then
				HBAR = HBAR + 0.07 * 1
			end
		end
		if pl:KeyDown(IN_MOVERIGHT) then
			if HBAR < 1.5 then
				HBAR = HBAR + 0.07 * 1
			end
		else
			if HBAR > 0 then
				HBAR = HBAR - 0.07 * 1
			end
		end
	end

	pl.OLDANG = v.ang
	pl.OLDPOS = v.pos
	v.ang.pitch = v.ang.pitch + HBAP * 1
	v.ang.roll = v.ang.roll + HBAR * 1
	v.pos.z = v.pos.z - math.cos(HBPZ * 1)
	return GAMEMODE:CalcView(pl, v.pos, v.ang, v.fov)
end
hook.Add("CalcView", "DasHeadBob", HeadBob)

function H_ON(ply)
	HEADBOB_ON = !HEADBOB_ON
	MsgN("Headbob: "..tostring(HEADBOB_ON))
end
concommand.Add("toggle_HBOB",H_ON)
