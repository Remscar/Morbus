--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

--[[
	Nightmare Mode
	Disables all players flashlights.
]]
local MUTATOR = {}
MUTATOR.Hooks = {}

function MUTATOR:Prep()
	-- Nothing?
end

function MUTATOR:Start()
	GameMsg("This is your nightmare.")
end

function MUTATOR:End()
	-- Nothing?
end

RegisterMutator(MUTATOR,"Nightmare")

function ChangeNightmare(ply) // Chat Command
	if ply:IsAdmin() then
		if !Mutators.Nightmare.Active then
			SendAll("Nightmare mode is now on")
			RunConsoleCommand("morbus_mutator_nightmare","1")
		else
			SendAll("Nightmare mode is now off")
			RunConsoleCommand("morbus_mutator_nightmare","0")
		end
	end
end
