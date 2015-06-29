// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team
surface.CreateFont( "PrAmmoFont", {
	font 		= "DeadSpaceTitleFont",
	size 		= 24,
	weight 		= 700,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 24, 700, true, false, "PrAmmoFont")

surface.CreateFont( "TotalAmmoFont", {
	font 		= "DeadSpaceTitleFont",
	size 		= 32,
	weight 		= 700,
	antialias	= true
})
--surface.CreateFont("DeadSpaceTitleFont", 32, 700, true, false, "TotalAmmoFont")

local matsettings = {
	["$basetexture"] = "ds_gunhud/ds_mainscreen",
	["$ignorez"] = 0,
	["$additive"] = 1,
	["$vertexcolor"] = 1,
	["$vertexalpha"] = 1,
	["$nolod"] = 1
}
local ds_gunhud = CreateMaterial("ds_gunhud", "UnlitGeneric", matsettings)

local TEX_WIDTH = 128
local TEX_HEIGHT = 64
local ScreenTexture = GetRenderTarget( "GunScreen", TEX_WIDTH, TEX_HEIGHT )

local OutlineTexture = surface.GetTextureID("ds_gunhud/ds_mainscreen")
local ScanlineTexture = surface.GetTextureID("ds_gunhud/ds_scanlines")
local NoiseTexture = surface.GetTextureID("ds_gunhud/ds_screen_noise")

local DefaultGunHud = {height = 1.5, width = 3, attachmentpoint = "2", enabled = true}
local GunHud = DefaultGunHud

local DefaultScreenColor = Color(51, 204, 204, 0)
local ScreenColor = DefaultScreenColor

function DrawAmmoScreen()
	local ply = LocalPlayer()
	if Morbus.Blinded then return end
	if ply:Alive() then
		local weapon = ply:GetActiveWeapon()
		local vmodel = ply:GetViewModel()
		
		if weapon and weapon:IsValid() and vmodel and vmodel:IsValid() then
			--Get ammo info
			local ammo = weapon:Clip1()
			--RPG reports -1, physcannon reports 0
			if (ammo > 0 && weapon:GetClass() != "weapon_glowstick" && weapon:GetClass() != "weapon_glowstick_special") then
				GunHud = weapon.GunHud or DefaultGunHud
				GunHud.height = 1.5
				GunHud.width = 3
				if GunHud.enabled then		
					local ironsight = vmodel:GetAttachment(tostring(GunHud.attachmentpoint)) or vmodel:GetAttachment("1")
					if ironsight || weapon:GetClass() == "weapon_mor_medkit" then

						local ang = ply:EyeAngles()
						local pos = ply:EyePos() + ang:Forward()*10 + ang:Up()*-3

						if weapon:GetClass() != "weapon_mor_medkit" then
							ang = ironsight.Ang
							pos = ironsight.Pos
						end


								
						--Render quad on gun
						cam.Start3D(EyePos(), EyeAngles())
							render.SetMaterial(ds_gunhud)
							render.DrawQuadEasy(pos, EyeVector()*-1, tonumber(GunHud.width), tonumber(GunHud.height), nil, 180)
						cam.End3D()
					end
				end
			end
		end
	end
end
hook.Add("HUDPaint", "DrawAmmoScreen", DrawAmmoScreen)

function DrawAmmoScreenTexture()
	local ply = LocalPlayer()
	if Morbus.Blinded then return end
	if !HUD_DEBUG[6] then return end
	if ply:Alive() then
		local weapon = ply:GetActiveWeapon()
		local vmodel = ply:GetViewModel()
		
		if weapon and weapon:IsValid() and vmodel and vmodel:IsValid() then
			--Get ammo info
			local ammo = weapon:Clip1() or -1
			local totalammo = ply:GetAmmoCount(weapon:GetPrimaryAmmoType()) or 0
		
			if (ammo > 0 && weapon:GetClass() != "weapon_glowstick" && weapon:GetClass() != "weapon_glowstick_special") then
				
				local PrimaryAmmo = tostring(ammo)
				local TotalAmmo = tostring(totalammo)
				
				
				--Render screen texture
				local NewRT = ScreenTexture
				ds_gunhud:SetTexture("$basetexture", NewRT)
				local OldRT = render.GetRenderTarget()

				--"scan lines" texture position
				local linetexpos = math.floor((CurTime()*40)%TEX_WIDTH)
				
				render.SetRenderTarget(NewRT)
				render.SetViewPort(0,0,TEX_WIDTH,TEX_HEIGHT) --can't do this in HUDPaint or it will also change the size of the HUD
				
				local bgscale = 0.7
				cam.Start2D()
					render.Clear(0,0,0,255)
					
					--Screen noise
					surface.SetDrawColor(math.floor(ScreenColor.r*bgscale),math.floor(ScreenColor.g*bgscale),math.floor(ScreenColor.b*bgscale),64)
					surface.SetTexture(NoiseTexture)
					surface.DrawTexturedRect(0, 2, TEX_WIDTH, TEX_HEIGHT-5)
					
					--Scanlines
					surface.SetDrawColor(math.floor(ScreenColor.r*bgscale),math.floor(ScreenColor.g*bgscale),math.floor(ScreenColor.b*bgscale),250)
					surface.SetTexture(ScanlineTexture)
					while linetexpos > TEX_WIDTH*-1 do
						surface.DrawTexturedRect(linetexpos, 2, TEX_WIDTH, TEX_HEIGHT-5)
						linetexpos = linetexpos - TEX_WIDTH
					end
					
					--Screen outline
					surface.SetDrawColor(ScreenColor.r, ScreenColor.g, ScreenColor.b, 250)
					surface.SetTexture(OutlineTexture)
					surface.DrawTexturedRect(0,0,TEX_WIDTH,TEX_HEIGHT)
				
					--Text stuff
					surface.SetTextColor(Color(ScreenColor.r,ScreenColor.g,ScreenColor.b,250))
					
					--Current ammo
					surface.SetFont("PrAmmoFont")
					local PrimaryAmmoW, PrimaryAmmoH = surface.GetTextSize(PrimaryAmmo)
					surface.SetTextPos((TEX_WIDTH/2)-(PrimaryAmmoW/2),TEX_HEIGHT/8)
					surface.DrawText(PrimaryAmmo)
				
					--Ammo of current type left
					surface.SetFont("TotalAmmoFont")
					local TotalAmmoW, TotalAmmoH = surface.GetTextSize(TotalAmmo)
					surface.SetTextPos((TEX_WIDTH/2)-(TotalAmmoW/2),TEX_HEIGHT/2.5)
					surface.DrawText(TotalAmmo)
					
					
				cam.End2D()
				
				render.SetRenderTarget( OldRT )
			end
		end
	end
end
hook.Add("RenderScreenspaceEffects", "DrawAmmoScreenTexture", DrawAmmoScreenTexture)

