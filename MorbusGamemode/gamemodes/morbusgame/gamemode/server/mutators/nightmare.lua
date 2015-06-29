/*===============================================

				Nightmare Mode
	Disables all players flashlights.

===============================================*/


local MUTATOR = {}
MUTATOR.Hooks = {}

SetGlobalBool("mutator_nightmare", false)

function MUTATOR:Prep()
end

function MUTATOR:Start()
	GameMsg("This is your nightmare.")
end

function MUTATOR:End()
end

RegisterMutator(MUTATOR,"Nightmare")


function ChangeNightmare(ply) // Chat Command
	if ply:IsAdmin() then
		if !GetConVar("morbus_mutator_nightmare"):GetBool() then
			SendAll("Nightmare mode is now on")
			RunConsoleCommand("morbus_mutator_nightmare","1")
		else
			SendAll("Nightmare mode is now off")
			RunConsoleCommand("morbus_mutator_nightmare","0")
		end
	end
end