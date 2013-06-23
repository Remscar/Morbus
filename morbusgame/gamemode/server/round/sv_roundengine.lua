
// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team


function SetRoundState(state)
	GAMEMODE.Round_State = state

	SendRoundState(state)
end


function GetRoundState()
	return GAMEMODE.Round_State
end

/*----------------------------------------------------
TIMERS
----------------------------------------------------*/


function StopRoundTimers()
   timer.Stop("wait2prep")
   timer.Stop("prep2begin")
   timer.Stop("end2begin")
   timer.Stop("winchecker")
end

function StartWinChecks()
	if not timer.Start("winchecker") then
		timer.Create("winchecker", 1, 0, WinChecker)
	end
end

function StopWinChecks()
	timer.Stop("winchecker")
end

/*----------------------------------------------------
PLAYER CHECKER
----------------------------------------------------*/

function EnoughPlayers()
	local ready = 0
	local needed = 2 -- 2 normally

	for _, ply in pairs(player.GetAll()) do
		if IsValid(ply) && ply:IsGame() then
			ready = ready + 1
		end
	end

	if ready > needed then return true else return false end

end



function WaitingForPlayersChecker()
	if GetRoundState() == ROUND_WAIT then
		if EnoughPlayers() then
			timer.Create("wait2prep", 1, 1, PrepareRound)
			timer.Stop("waitingforply")
		end
	end
end


function WaitForPlayers()
	SetRoundState(ROUND_WAIT)

	if not timer.Start("waitingforply") then
		timer.Create("waitingforply",2,0, WaitingForPlayersChecker)
	end
end

function CheckForAbort()

	if GAMEMODE.STOP then return true end
	
	if not EnoughPlayers() then
		StopRoundTimers()
		WaitForPlayers()
		return true
	end

	return false
end


/*----------------------------------------------------
MISC
----------------------------------------------------*/


local function ForceRoundRestart(ply, command, args)
   if (not IsValid(ply)) or ply:IsAdmin() or ply:IsSuperAdmin() then
      StopRoundTimers()
      PrepareRound()
   else
      ply:PrintMessage(HUD_PRINTCONSOLE, "You must be a GMod Admin or SuperAdmin on the server to use this command")
   end
end
concommand.Add("morbus_roundrestart", ForceRoundRestart)

function GM:AcceptStream(ply, handler, id)
   return false
end
