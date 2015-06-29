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

function CreateSwarmShop()
	if !LocalPlayer():IsSwarm() then return end
	if pSwarmShop then
		if pSwarmShop:IsValid() then pSwarmShop:Remove() end
	end

	base = vgui.Create("DFrame")
	base:SetSize(800, 500)
	base:SetPos(ScrW()/2-400,150)
	base:SetVisible(true)
	base:MakePopup()
	base:SetTitle("")
	function base:Paint()
		draw.RoundedBox( 8, 0, 0, base:GetWide(), base:GetTall(), Color( 95, 15, 25, 100 ) )
		draw.SimpleTextOutlined("Swarm Points: "..LocalPlayer():GetSwarmPoints(),"DefaultLarge",base:GetWide()/2,20,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	end
	UpdateSwarmShop()
end

-- self:GetUserGroup()
-- 0 = anyone
-- 1 = donator



-- 0 = normal, 1 = chemical bomb, 7 = unstable bore, 6 = flash burst, 
-- 2 = nitro core, 3 = shock spit, 8 = remote charge, 9 = spikes, 5 = enhanced spit, 4 = demon flare
function UpdateSwarmShop()
local SelectTextSec 	= "-[ Nothing Selected ]-"
local SelectionSec 		= -1
local SpitIconSelect 	= "VGUI/morbus/swarm/icon_normal.png"
local SpitPrice 		= 0
local SpitDonator		= 0

local soundInvalid		= Sound( "buttons/button8.wav" )
local soundValid		= Sound( "buttons/blip1.wav" )

local colorDonator		= Color( 255, 215, 55, 195 )
local colorNormal		= Color( 0, 255, 0, 195 )
local colorDisabled		= Color( 255, 0, 0, 195 )


local bSizeX,bSizeY		= 64, 64

-- Margins
local Margin1x,Margin1y 	= 40, 20
local Margin2x,Margin2y 	= 160, 20
local Margin3x,Margin3y 	= 280, 20
local Margin4x,Margin4y 	= 400, 20
local Margin5x,Margin5y 	= 510, 20
local Margin6x,Margin6y 	= 620, 20

local Margin7x,Margin7y 	= 40, 120
local Margin8x,Margin8y 	= 160, 120
local Margin9x,Margin9y 	= 280, 120
local Margin10x,Margin10y 	= 400, 120
local Margin11x,Margin11y 	= 510, 120
local Margin12x,Margin12y 	= 620, 120

local Margin13x,Margin13y 	= 40, 220
local Margin14x,Margin14y 	= 160, 220
local Margin15x,Margin15y 	= 280, 220
local Margin16x,Margin16y 	= 400, 220
local Margin17x,Margin17y 	= 510, 220
local Margin18x,Margin18y 	= 620, 220


local textMarginOffset1		= 90
local textMarginOffset2		= 190
local textMarginOffset3		= 290







--
local sm_Spit9name 		= "Spikes"
local sm_Spit9desc 		= "Launches a shotgun of spikes."
local sm_Spit9icon 		= "VGUI/morbus/swarm/icon_spikes.png"
local sm_Spit9type 		= 9
--

-- 
local sm_Spit10name 	= "Swarm Haste"
local sm_Spit10desc 	= "1.5x faster Swarm speed."
local sm_Spit10icon 	= "VGUI/morbus/swarm/icon_swarmhaste.png"
local sm_Spit10type 	= 5
--

--
local sm_Spit11name 	= "Leap"
local sm_Spit11desc 	= "A hardy leap to get up high places."
local sm_Spit11icon 	= "VGUI/morbus/swarm/icon_leap.png"
local sm_Spit11type 	= 10
--

--
local sm_Spit12name 	= "Self Destruct"
local sm_Spit12desc 	= "3 second self-detonation that deals massive damage to enemies around you."
local sm_Spit12icon 	= "VGUI/morbus/swarm/icon_selfdestruct.png"
local sm_Spit12type 	= 11
--

--
local sm_Spit13name 	= "Acid Sac"
local sm_Spit13desc 	= "Spit releases acid on impact, damaging nearby humans."
local sm_Spit13icon 	= "VGUI/morbus/swarm/icon_acidspit.png"
local sm_Spit13type 	= 12
--

--
local sm_Spit14name 	= "Magma Clot"
local sm_Spit14desc 	= "Sticky cluster fire bomb."
local sm_Spit14icon 	= "VGUI/morbus/swarm/icon_magmaclot.png"
local sm_Spit14type 	= 13
--





local SShopBase = vgui.Create( "DPropertySheet", base )
SShopBase:SetPos( 30, 30 )
SShopBase:SetSize( 750, 450 )
SShopBase.Paint = function()
    surface.SetDrawColor( 90, 5, 5, 175 )
    surface.DrawRect( 0, 0, SShopBase:GetWide(), SShopBase:GetTall() )
end


--[[||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
Swarm Spit Modifiers
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||]]--
local SShop2 = vgui.Create( "DPanel" , SShop2a )
SShop2:SetText( "Secondary Mods" )
SShop2:SizeToContents()
function SShop2:Paint()
	draw.RoundedBox( 8, 0, 0, base:GetWide(), base:GetTall(), Color( 55, 5, 5, 175 ) )
end


-- Normal Spit
--
--------------------------------------------------------------------------------------------------
local Spit1 = vgui.Create( "DImageButton", SShop2 )
Spit1:SetMaterial( "VGUI/morbus/swarm/icon_normal.png" )
Spit1:SetPos( Margin1x,Margin1y )
Spit1:SetSize( bSizeX, bSizeY )
Spit1.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ Normal Spit ]- A normal spit attack that deals splash damage."
	 	SpitIconSelect 		= "VGUI/morbus/swarm/icon_normal.png"
	 	SelectionSec 		= 0
	 	SpitSelectionName 	= "Normal Spit"
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText1 = vgui.Create( "DLabel", SShop2 )
SpitText1:SetText( "[ RESET ]" )
SpitText1:SetTextColor( Color( 255, 255, 0, 255 ) )
SpitText1:SetPos( Margin1x + 10, textMarginOffset1 )
SpitText1:SizeToContents()
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------


-- Unstable Bore
--
--------------------------------------------------------------------------------------------------
local Spit3 = vgui.Create( "DImageButton", SShop2 )
Spit3:SetMaterial( "VGUI/morbus/swarm/icon_unstablebore.png" )
Spit3:SetPos( Margin2x,Margin1y )
Spit3:SetSize( bSizeX, bSizeY )
Spit3.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ Unstable Bore ]- Timed bouncy bomb.."
	 	SpitIconSelect 		= "VGUI/morbus/swarm/icon_unstablebore.png"
	 	SelectionSec 		= 7
	 	SpitSelectionName 	= "Unstable Bore"
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText3 = vgui.Create( "DLabel", SShop2 )
SpitText3:SetText( "( 5 ) Unstable Bore" )
SpitText3:SetTextColor( colorNormal )
SpitText3:SetPos( Margin2x - 20, textMarginOffset1 )
SpitText3:SizeToContents()
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


-- Nitro Core
--
--------------------------------------------------------------------------------------------------
local Spit5 = vgui.Create( "DImageButton", SShop2 )
Spit5:SetMaterial( "VGUI/morbus/swarm/icon_nitrocore.png" )
Spit5:SetPos( Margin3x,Margin1y )
Spit5:SetSize( bSizeX, bSizeY )
Spit5.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ Nitro Core ]- Weaker attack but slows humans on contact."
	 	SpitIconSelect 		= "VGUI/morbus/swarm/icon_nitrocore.png"
	 	SelectionSec 		= 2
	 	SpitSelectionName 	= "Nitro Core"
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText5 = vgui.Create( "DLabel", SShop2 )
SpitText5:SetText( "( 10 ) Nitro Core" )
SpitText5:SetTextColor( colorNormal )
SpitText5:SetPos( Margin3x - 10, textMarginOffset1 )
SpitText5:SizeToContents()
--------------------------------------------------------------------------------------------------


-- Shock Spit
--
--------------------------------------------------------------------------------------------------
local Spit6 = vgui.Create( "DImageButton", SShop2 )
Spit6:SetMaterial( "VGUI/morbus/swarm/icon_shockspit.png" )
Spit6:SetPos( Margin4x,Margin1y )
Spit6:SetSize( bSizeX, bSizeY )
Spit6.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ Shock Spit ]- Electric spit with a larger radius of damage."
	 	SpitIconSelect 		= "VGUI/morbus/swarm/icon_shockspit.png"
	 	SelectionSec 		= 3
	 	SpitSelectionName 	= "Shock Spit"
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText6 = vgui.Create( "DLabel", SShop2 )
SpitText6:SetText( "( 10 ) Shock Spit" )
SpitText6:SetTextColor( colorNormal )
SpitText6:SetPos( Margin4x - 10, textMarginOffset1 )
SpitText6:SizeToContents()
--------------------------------------------------------------------------------------------------


-- Remote Charge
--
--------------------------------------------------------------------------------------------------
local Spit7 = vgui.Create( "DImageButton", SShop2 )
Spit7:SetMaterial( "VGUI/morbus/swarm/icon_remotespit.png" )
Spit7:SetPos( Margin5x,Margin1y )
Spit7:SetSize( bSizeX, bSizeY )
Spit7.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ Remote Charge ]- Sticky remote detonated spit ball. (Hit reload while firing to explode or when 5 are placed)"
	 	SpitIconSelect 		= "VGUI/morbus/swarm/icon_remotespit.png"
	 	SelectionSec 		= 8
	 	SpitSelectionName 	= "Remote Charge"
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText7 = vgui.Create( "DLabel", SShop2 )
SpitText7:SetText( "( 10 ) Remote Charge" )
SpitText7:SetTextColor( colorNormal )
SpitText7:SetPos( Margin5x - 20, textMarginOffset1 )
SpitText7:SizeToContents()
--------------------------------------------------------------------------------------------------



-- Swarm Haste
local Spit10 = vgui.Create( "DImageButton", SShop2 )
Spit10:SetMaterial( sm_Spit10icon )
Spit10:SetPos( Margin6x,Margin1y )
Spit10:SetSize( bSizeX, bSizeY )
Spit10.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ ".. sm_Spit10name .." ]- " .. sm_Spit10desc .. "."
	 	SpitIconSelect 		= sm_Spit10icon
	 	SelectionSec 		= sm_Spit10type
	 	SpitSelectionName 	= sm_Spit10name
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText10 = vgui.Create( "DLabel", SShop2 )
SpitText10:SetText( "( 5 ) " .. sm_Spit10name )
SpitText10:SetTextColor( colorNormal )
SpitText10:SetPos( Margin6x - 15, textMarginOffset1 )
SpitText10:SizeToContents()


-- Leap
local Spit11 = vgui.Create( "DImageButton", SShop2 )
Spit11:SetMaterial( sm_Spit11icon )
Spit11:SetPos( Margin7x ,Margin7y )
Spit11:SetSize( bSizeX, bSizeY )
Spit11.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ ".. sm_Spit11name .." ]- " .. sm_Spit11desc .. "."
	 	SpitIconSelect 		= sm_Spit11icon
	 	SelectionSec 		= sm_Spit11type
	 	SpitSelectionName 	= sm_Spit11name
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText11 = vgui.Create( "DLabel", SShop2 )
SpitText11:SetText( "( 5 ) " .. sm_Spit11name )
SpitText11:SetTextColor( colorNormal )
SpitText11:SetPos( Margin7x + 5, textMarginOffset2 )
SpitText11:SizeToContents()


-- Acid Sac
local Spit13 = vgui.Create( "DImageButton", SShop2 )
Spit13:SetMaterial( sm_Spit13icon )
Spit13:SetPos( Margin8x,Margin7y )
Spit13:SetSize( bSizeX, bSizeY )
Spit13.DoClick = function()
	if LocalPlayer():IsSwarm() then
	 	surface.PlaySound( soundValid )
	 	SelectTextSec 		= " -[ ".. sm_Spit13name .." ]- " .. sm_Spit13desc .. "."
	 	SpitIconSelect 		= sm_Spit13icon
	 	SelectionSec 		= sm_Spit13type
	 	SpitSelectionName 	= sm_Spit13name
	else
	 	surface.PlaySound( soundInvalid )
	 	LocalPlayer():PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You are not a Swarm alien!" )
	end
end
local SpitText13 = vgui.Create( "DLabel", SShop2 )
SpitText13:SetText( "( 10 ) " .. sm_Spit13name )
SpitText13:SetTextColor( colorNormal )
SpitText13:SetPos( Margin8x, textMarginOffset2 )
SpitText13:SizeToContents()





local SpitSelect = vgui.Create( "DImageButton", SShop2 )
SpitSelect:SetMaterial( SpitIconSelect )
SpitSelect:SetPos( 20, 335 )
SpitSelect:SetSize( 64, 64 )
SpitSelect.Think = function()
	SpitSelect:SetMaterial( SpitIconSelect )
end
local SpitSelectText = vgui.Create( "DLabel", SShop2 )
SpitSelectText:SetText( "Selected: " )
SpitSelectText:SetTextColor( Color( 0, 255, 0, 255 ) )
SpitSelectText:SetPos( 20, 315 )
SpitSelectText:SizeToContents()

local SpitSelectText2 = vgui.Create( "DLabel", SShop2 )
SpitSelectText2:SetText( SelectTextSec )
SpitSelectText2:SetTextColor( Color( 0, 255, 0, 255 ) )
SpitSelectText2:SetPos( 65, 315 )
SpitSelectText2:SizeToContents()
SpitSelectText2.Think = function( self )
	self:SetText( SelectTextSec )
	self:SizeToContents()
end






local SpitBuyButton = vgui.Create( "DButton", SShop2 )
SpitBuyButton:SetSize( 100, 60 )
SpitBuyButton:SetPos( 620, 345 )
SpitBuyButton:SetText( "Buy and Equip" )
SpitBuyButton.Paint = function()
	draw.RoundedBox( 8, 0, 0, SpitBuyButton:GetWide(), SpitBuyButton:GetTall(), Color( 0, 0, 0, 255 ) )
end
SpitBuyButton.DoClick = function()
local Player = LocalPlayer()
local Weapon = Player:GetActiveWeapon()

	if Player:IsSwarm() then

		if SelectionSec == -1 then
			surface.PlaySound( Sound( "buttons/button8.wav" ) )
			Player:PrintMessage( HUD_PRINTTALK, "[Swarm Shop] You need to make a selection first!" )
		return end

		print( SelectionSec )
	 	surface.PlaySound( Sound( "buttons/blip1.wav" ) )
		RunConsoleCommand( "SwarmBuyMod", SelectionSec, SpitSelectionName )

	end
end


-- Icons
SShopBase:AddSheet( "Swarm Shop", SShop2, "icon16/transmit.png", false, false, "Swarm Spit modifiers" )
end
