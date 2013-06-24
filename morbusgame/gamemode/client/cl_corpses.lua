--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

-- Player Bodies
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

	if ply.sb_tag and ply.sb_tag.txt != "Alien" then -- no more beep spam
		ply.sb_tag = {}
		ply.sb_tag.txt = "Alien"
		ply.sb_tag.color = COLOR_RED
		surface.PlaySound("ui/buttonclick.wav")
	end
end
net.Receive("ReceivedBody",FoundBody)
