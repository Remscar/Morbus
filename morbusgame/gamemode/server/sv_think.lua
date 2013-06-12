// eh

// to be done later

GMNextThink = 0
function GM:Think()
	if GMNextThink <= CurTime() then
		CheckAlien() -- Found in sv_brood.lua
		CheckMission() -- sv_missions.lua
		CheckMovement() -- below
		GMNextThink = CurTime() + 0.08
	end
end

function CheckMovement()
	for k,v in pairs(player.GetAll()) do
		if v:KeyDown(IN_FORWARD) || v:KeyDown(IN_BACK) || v:KeyDown(IN_JUMP) || v:KeyDown(IN_LEFT) || v:KeyDown(IN_RIGHT) || v:KeyDown(IN_ATTACK) || (v.OldPos != v:GetPos()) then
			v.Moving = true
			v.Moved = true -- for motion sensor thingy
			v.OldPos = v:GetPos()
			if v:GetNWBool("alienform") then Cancel_Cloak(v) end
		elseif v:OnGround() then
			v.Moving = false
			v.OldPos = v:GetPos()
		end
	end
end