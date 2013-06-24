--[[
	Morbus - morbus.remscar.com
	Developed by Remscar
	and the Morbus dev team
]]

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
end
