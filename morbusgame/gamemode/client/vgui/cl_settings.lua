//Options/Settings menu

CreateClientConVar("morbus_hide_rolehint","0",true)
CreateClientConVar("morbus_hide_distortion","0",true)
CreateClientConVar("morbus_hide_rpnames", "0",true)
CreateClientConVar("morbus_disable_music", "0",true)
CreateClientConVar("morbus_alienhud_disable", "0",true)
CreateClientConVar("morbus_alienhud_purple", "0",true)

function CreateSettingsMenu()
	local pnl = vgui.Create("DFrame")
	pnl:SetSize(180,275)
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

	local s1b = vgui.Create("DCheckBoxLabel",pnl)
	s1b:SetPos(4,70)
	s1b:SetText("Hide RP Names")
	s1b:SetConVar("morbus_hide_rpnames")
	s1b:SetValue(GetConVar("morbus_hide_rpnames"):GetBool())
	s1b:SizeToContents()

	local s1c = vgui.Create("DCheckBoxLabel",pnl)
	s1c:SetPos(4,90)
	s1c:SetText("Disable Music")
	s1c:SetConVar("morbus_disable_music")
	s1c:SetValue(GetConVar("morbus_disable_music"):GetBool())
	s1c:SizeToContents()

	local s1d = vgui.Create("DCheckBoxLabel",pnl)
	s1d:SetPos(4,110)
	s1d:SetText("Disable Alien HUD")
	s1d:SetConVar("morbus_alienhud_disable")
	s1d:SetValue(GetConVar("morbus_alienhud_disable"):GetBool())
	s1d:SizeToContents()

	local s1f = vgui.Create("DCheckBoxLabel",pnl)
	s1f:SetPos(4,130)
	s1f:SetText("Purple Alien HUD")
	s1f:SetConVar("morbus_alienhud_purple")
	s1f:SetValue(GetConVar("morbus_alienhud_purple"):GetBool())
	s1f:SizeToContents()

	local s2 = vgui.Create("DButton",pnl)
	s2:SetPos(4,170)
	s2:SetText("Toggle Spectator Mode")
	s2:SetSize(120,20)
	function s2:DoClick()
		RunConsoleCommand("say", "/spec")
	end

	local s3 = vgui.Create("DLabel",pnl)
	s3:SetPos(4,205)
	s3:SetText("CONSOLE COMMANDS:")
	s3:SizeToContents()

	local s4 = vgui.Create("DLabel",pnl)
	s4:SetPos(4,215)
	s4:SetText("morbus_toggle_hud\nmorbus_toggle_chat\nmorbus_mute_status")
	s4:SizeToContents()

end
concommand.Add("morbus_settings",CreateSettingsMenu)