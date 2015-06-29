// Mutator system


Mutators = {}




function RegisterMutator(tab,name)
	tab.Active = false
	CreateConVar("morbus_mutator_"..string.lower(name), "0", FCVAR_NOTIFY)
	if !tab.Check then
		function tab:Check()

			if (GetConVar("morbus_mutator_"..string.lower(name)):GetBool() == true) then
				SetGlobalBool("mutator_"..string.lower(name), true)
				self.Active = true
			else
				SetGlobalBool("mutator_"..string.lower(name), false)
				self.Active = false
			end
		end
	end

	for k,v in pairs(tab.Hooks) do
		local func = function(...)
			if GetGlobalBool("mutator_"..string.lower(name), false) then
				v(...)
			end
		end
		hook.Add(k,name.."_"..k,func)	
	end

	Mutators[name] = tab
	Mutators[name]:Check()
end

// Mutator Control

function EnableMutator(name)
	if Mutators[name] then
		Mutators[name].Active = true
		SetGlobalBool("mutator_"..string.lower(name), Mutators[name].Active and true or false)
	end
end

function DisableMutator(name)
	if Mutators[name] then
		Mutators[name].Active = false
		SetGlobalBool("mutator_"..string.lower(name), Mutators[name].Active and true or false)
	end
end

function ToggleMutator(name)
	if Mutators[name] then
		Mutators[name].Active = !Mutators[name].Active
		SetGlobalBool("mutator_"..string.lower(name), Mutators[name].Active and true or false)
	end
end

function MutatorStatus(name)
	if Mutators[name] then
		return Mutators[name].Active
	end
	return false
end

// Mutator functions

function CheckMutators()
	for k,v in pairs(Mutators) do
		if v.Check then
			v:Check()
		end
	end
end

function PrepMutators()
	for k,v in pairs(Mutators) do
		if v.Prep && v.Active then
			v:Prep()
		end
	end
end

function StartMutators()
	for k,v in pairs(Mutators) do
		if v.Start && v.Active then
			v:Start()
		end
	end
end

function EndMutators()
	for k,v in pairs(Mutators) do
		if v.End && v.Active then
			v:End()
		end
	end
end