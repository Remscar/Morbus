/*----------------------------------------------------
WIN CHECKER
----------------------------------------------------*/
function WinChecker()
	if GetRoundState() == ROUND_ACTIVE then
		if CurTime() > GetGlobalFloat("morbus_round_end", 0) then
			if Evacuation_Map then
				StartEvacuation()
			else
				EndRound(WIN_HUMAN)
			end
		else
			local win = CheckForWin()
			if win != WIN_NONE then
				Msg(win.." Won @ "..CurTime().."\n")
				EndRound(win)
				return
			end
		end
	end
	if GetRoundState() == ROUND_EVAC then
		if CurTime() > GetGlobalFloat("morbus_round_end", 0) then
			if Human_Evacuated then
				EndRound(WIN_HUMAN)
			else
				EndRound(WIN_ALIEN)
			end
		else
			local win = CheckForWin()
			if win != WIN_NONE then
				if Human_Evacuated then
					Msg(WIN_HUMAN.." Won @ "..CurTime().."\n")
					EndRound(WIN_HUMAN)
					return
				end
				Msg(win.." Won @ "..CurTime().."\n")
				EndRound(win)
				return
			end
		end
	end
end

function CheckForWin()
	-- return WIN_NONE //Dubug

	local brood_alive = false
	local human_alive = false

	for k,v in pairs(player.GetAll()) do
		if v:Alive() then
			if v:IsBrood() then
				brood_alive = true -- if the are a brood and alive
			end
			if v:IsHuman() then
				human_alive = true -- if they are a human and alive
			end
		end

		if brood_alive and human_alive then
			return WIN_NONE -- Nobody is a winner yet
		end

	end -- end the loop

	if brood_alive and not human_alive then
		return WIN_ALIEN
	elseif not brood_alive and human_alive then
		return WIN_HUMAN
	elseif not human_alive then
		--If everyone is dead then the infeciton doesnt spread then humans win
		return WIN_HUMAN
	end


	return WIN_NONE
end