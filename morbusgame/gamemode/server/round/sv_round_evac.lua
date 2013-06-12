/*----------------------------------------------------
EVACUATION ROUND
----------------------------------------------------*/

function StartEvacuation()

	GameMsg("Evacuate the area!")

	Human_Evacuated = false
	SetRoundState(ROUND_EVAC)

	local endtime = CurTime() + (GetConVar("morbus_evactime"):GetInt() * 60)
	SetRoundEnd(endtime)

end