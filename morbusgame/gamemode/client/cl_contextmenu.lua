// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
--It didn't fit in any other file imp


function GM:OnContextMenuOpen( )
	if GetRoundState() == ROUND_WAIT then return end
	if (GetRoundState() != ROUND_ACTIVE) && (RoundHistory["First"] != nil) then
		OPEN_RHISTORY()
		return
	end

	if LocalPlayer():IsBrood() then
		if pUpgradesMenu && pUpgradesMenu:IsValid() then 
			pUpgradesMenu:Remove()
		end
		if pDescriptionBox then
			pDescriptionBox:Remove()
		end
		CreateUpgradesMenu()
	end

	-- Swarm Alien Shop
	if LocalPlayer():IsSwarm() then
		if pSwarmShop && pSwarmShop:IsValid() then 
			pSwarmShop:Remove()
		end
		if pDescriptionBox then
			pDescriptionBox:Remove()
		end

		CreateSwarmShop()
	end

end


