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
/*--------------------------------------------
MORBUS CLIENT KEY AND BIND HANDLING
--------------------------------------------*/

function CheckBody()
	if !LocalPlayer():IsGame() || LocalPlayer():IsSwarm() then return end

	local tr = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
	local trace = util.TraceLine( tr )
	if !trace.Hit || !trace.HitNonWorld then return end

	if trace.Entity:GetClass() == "prop_ragdoll"  then
		local ent = trace.Entity
		local distance = trace.HitPos:Distance(trace.StartPos)

		if ent:GetNWBool("HumanBody",false) && distance < 140 then
			local ply = ent:GetNWEntity("Player",nil)
			if !ply || !IsValid(ply) then return end
			if ply == LocalPlayer() then return end
			
			net.Start("FoundBody")
			net.WriteVector(ent:GetPos())
			net.WriteEntity(ply)
			net.SendToServer()

		end


	end

end

function FoundBody()
	local ply = net.ReadEntity()
	if ply == LocalPlayer() then return end
	ply.sb_tag = {}
	ply.sb_tag.txt = "Alien"
	ply.sb_tag.color = COLOR_RED
	surface.PlaySound("ui/buttonclick.wav")
end
net.Receive("ReceivedBody",FoundBody)


local function SendWeaponDrop()
   RunConsoleCommand("morbus_dropweapon")

   --WSWITCH:Disable()
end

function GM:OnSpawnMenuOpen()
   SendWeaponDrop()
end

function GM:PlayerBindPress(ply,bind,pressed)
	if not ValidEntity(ply) then return end

	if bind == "invnext" and pressed then
		WSWITCH:SelectNext()
		return true
	elseif bind == "invprev" and pressed then
		WSWITCH:SelectPrev()
		return true
	elseif bind == "+attack" then
		if WSWITCH.Show then
			if not pressed then
				WSWITCH:ConfirmSelection()
			end
			return true
		end
	elseif bind == "+zoom" then
      -- set voice type here just in case shift is no longer down when the
      -- PlayerStartVoice hook runs, which might be the case when switching to
      -- steam overlay
      --MsgN("HOOK")
      --ply.alien_voice = false
      --RunConsoleCommand("morbus_alien_voice", "0")
      --return true
    -- elseif bind == "lastinv" then
    -- 	return true
	elseif bind == "+use" then
		CheckBody()
		RunConsoleCommand("morbus_use")
	elseif string.sub(bind, 1, 4) == "slot" and pressed then
		local idx = tonumber(string.sub(bind, 5, -1)) or 1
		WSWITCH:SelectSlot(idx)
		return true
	elseif bind == "noclip" and pressed then
		if not GetConVar("sv_cheats"):GetBool() then
			RunConsoleCommand("morbus_equipswitch")
			return true
		end
	elseif (bind == "gmod_undo" or bind == "undo") and pressed then
		RunConsoleCommand("morbus_dropammo")
		return true
	end
end


function GM:KeyPress(ply, key)
   if not IsFirstTimePredicted() then return end
   if not ValidEntity(ply) or ply != LocalPlayer() then return end

   if key == IN_ZOOM and ply:IsActiveAlien() then
      timer.Simple(0.05, function() RunConsoleCommand("+voicerecord") end)
   end
end

function GM:KeyRelease(ply, key)
   if not IsFirstTimePredicted() then return end
   if not ValidEntity(ply) or ply != LocalPlayer() then return end

   if key == IN_ZOOM and ply:IsActiveAlien() then
      timer.Simple(0.05, function() RunConsoleCommand("-voicerecord") end)
   end
end