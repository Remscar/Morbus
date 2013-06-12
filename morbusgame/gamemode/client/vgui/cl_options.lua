//Options/Settings menu

CreateClientConVar("morbus_hide_rolehint","0",true)
CreateClientConVar("morbus_hide_distortion","0",true)

function CreateSettingsMenu()
	local pnl = vgui.Create("DFrame")
	pnl:SetSize(180,180)
	pnl:Center()
	pnl:MakePopup()
	pnl:SetTitle("Settings")

	local s1 = vgui.Create("DCheckBoxLabel",pnl)
	s1:SetPos(4,30)
	s1:SetText("Hide Role Hints")
	s1:SetConVar("morbus_hide_rolehint")
	s1:SetValue(GetConVar("morbus_hide_rolehint"):GetBool())
	s1:SizeToContents()

	local s1a = vgui.Create("DCheckBoxLabel",pnl)
	s1a:SetPos(4,50)
	s1a:SetText("Hide Alien Distortion")
	s1a:SetConVar("morbus_hide_distortion")
	s1a:SetValue(GetConVar("morbus_hide_distortion"):GetBool())
	s1a:SizeToContents()

	local s2 = vgui.Create("DButton",pnl)
	s2:SetPos(4,70)
	s2:SetText("Toggle Spectator Mode")
	s2:SetSize(120,20)
	function s2:DoClick()
		RunConsoleCommand("say", "/spec")
	end

	local s3 = vgui.Create("DLabel",pnl)
	s3:SetPos(4,95)
	s3:SetText("CONSOLE COMMANDS:")
	s3:SizeToContents()

	local s4 = vgui.Create("DLabel",pnl)
	s4:SetPos(4,110)
	s4:SetText("morbus_toggle_hud\nmorbus_toggle_chat\nmorbus_mute_status")
	s4:SizeToContents()

end
concommand.Add("morbus_settings",CreateSettingsMenu)