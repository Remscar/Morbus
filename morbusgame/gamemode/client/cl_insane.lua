-- //insanity


-- SANITY_HIGH = 1 // 800
-- SANITY_MED = 2 // 600
-- SANITY_LOW = 3 // 400 

-- SANITY_LEVEL = {}
-- SANITY_LEVEL[SANITY_HIGH] = 800
-- SANITY_LEVEL[SANITY_MED] = 600
-- SANITY_LEVEL[SANITY_LOW] = 400

-- B_Sanity = {} //Base
-- B_Sanity[ "$pp_colour_addr" ] = 0
-- B_Sanity[ "$pp_colour_addg" ] = 0
-- B_Sanity[ "$pp_colour_addb" ] = 0
-- B_Sanity[ "$pp_colour_brightness" ] = 0
-- B_Sanity[ "$pp_colour_contrast" ] = 1
-- B_Sanity[ "$pp_colour_color" ] = 1
-- B_Sanity[ "$pp_colour_mulr" ] = 0
-- B_Sanity[ "$pp_colour_mulg" ] = 0
-- B_Sanity[ "$pp_colour_mulb" ] = 0

-- C_Sanity = {} //Current
-- C_Sanity[ "$pp_colour_addr" ] = 0
-- C_Sanity[ "$pp_colour_addg" ] = 0
-- C_Sanity[ "$pp_colour_addb" ] = 0
-- C_Sanity[ "$pp_colour_brightness" ] = 0
-- C_Sanity[ "$pp_colour_contrast" ] = 1
-- C_Sanity[ "$pp_colour_color" ] = 1
-- C_Sanity[ "$pp_colour_mulr" ] = 0
-- C_Sanity[ "$pp_colour_mulg" ] = 0
-- C_Sanity[ "$pp_colour_mulb" ] = 0

-- M_Sanity = {} //Multiplier
-- M_Sanity[ "$pp_colour_addr" ] = 0.15
-- M_Sanity[ "$pp_colour_addg" ] = 0.1
-- M_Sanity[ "$pp_colour_addb" ] = 0.1
-- M_Sanity[ "$pp_colour_brightness" ] = 0
-- M_Sanity[ "$pp_colour_contrast" ] = 0
-- M_Sanity[ "$pp_colour_color" ] = 0.5
-- M_Sanity[ "$pp_colour_mulr" ] = 0.15
-- M_Sanity[ "$pp_colour_mulg" ] = 0.05
-- M_Sanity[ "$pp_colour_mulb" ] = 0.05

-- -- LL_Sanity = {} //lower limit
-- -- LL_Sanity[ "$pp_colour_addr" ] = 0.15
-- -- LL_Sanity[ "$pp_colour_addg" ] = 0.1
-- -- LL_Sanity[ "$pp_colour_addb" ] = 0.1
-- -- LL_Sanity[ "$pp_colour_brightness" ] = 0
-- -- LL_Sanity[ "$pp_colour_contrast" ] = 0.5
-- -- LL_Sanity[ "$pp_colour_color" ] = 0.5
-- -- LL_Sanity[ "$pp_colour_mulr" ] = 0.15
-- -- LL_Sanity[ "$pp_colour_mulg" ] = 0.1
-- -- LL_Sanity[ "$pp_colour_mulb" ] = 0.1

-- UL_Sanity = {} //upper limit
-- UL_Sanity[ "$pp_colour_addr" ] = 1
-- UL_Sanity[ "$pp_colour_addg" ] = 1
-- UL_Sanity[ "$pp_colour_addb" ] = 1
-- UL_Sanity[ "$pp_colour_brightness" ] = 1.2
-- UL_Sanity[ "$pp_colour_contrast" ] = 1.2
-- UL_Sanity[ "$pp_colour_color" ] = 1.2
-- UL_Sanity[ "$pp_colour_mulr" ] = 0.3
-- UL_Sanity[ "$pp_colour_mulg" ] = 0.3
-- UL_Sanity[ "$pp_colour_mulb" ] = 0.3

-- C_Vol = 0

-- SANITY_EFFECT = {}
-- SANITY_EFFECT[SANITY_HIGH] = function(ply)
-- 	C_Vol = 0
-- 	B_Sanity[ "$pp_colour_addr" ] = 0
-- 	B_Sanity[ "$pp_colour_addg" ] = 0
-- 	B_Sanity[ "$pp_colour_addb" ] = 0
-- 	B_Sanity[ "$pp_colour_brightness" ] = 0
-- 	B_Sanity[ "$pp_colour_contrast" ] = 1
-- 	B_Sanity[ "$pp_colour_color" ] = 1
-- 	B_Sanity[ "$pp_colour_mulr" ] = 0
-- 	B_Sanity[ "$pp_colour_mulg" ] = 0
-- 	B_Sanity[ "$pp_colour_mulb" ] = 0
-- 	ResetInsanity()
-- end

-- SANITY_EFFECT[SANITY_MED] = function(ply)
-- 	C_Vol = 1
-- 	B_Sanity[ "$pp_colour_addr" ] = 0.03
-- 	B_Sanity[ "$pp_colour_addg" ] = 0
-- 	B_Sanity[ "$pp_colour_addb" ] = 0
-- 	B_Sanity[ "$pp_colour_brightness" ] = 0
-- 	B_Sanity[ "$pp_colour_contrast" ] = 1
-- 	B_Sanity[ "$pp_colour_color" ] = 1.05
-- 	B_Sanity[ "$pp_colour_mulr" ] = 0
-- 	B_Sanity[ "$pp_colour_mulg" ] = 0
-- 	B_Sanity[ "$pp_colour_mulb" ] = 0
-- 	ResetInsanity()
-- end

-- SANITY_EFFECT[SANITY_LOW] = function(ply)
-- 	C_Vol = 4
-- 	B_Sanity[ "$pp_colour_addr" ] = 0
-- 	B_Sanity[ "$pp_colour_addg" ] = 0
-- 	B_Sanity[ "$pp_colour_addb" ] = 0
-- 	B_Sanity[ "$pp_colour_brightness" ] = 0
-- 	B_Sanity[ "$pp_colour_contrast" ] = 1
-- 	B_Sanity[ "$pp_colour_color" ] = 1.1
-- 	B_Sanity[ "$pp_colour_mulr" ] = 0.01
-- 	B_Sanity[ "$pp_colour_mulg" ] = 0
-- 	B_Sanity[ "$pp_colour_mulb" ] = 0
-- 	ResetInsanity()
-- end



-- local function AddDefaults(tab)
-- 	//tab[ "$pp_colour_contrast" ] = 1 + tab[ "$pp_colour_contrast" ]
-- 	//tab[ "$pp_colour_color" ] = 1 + tab[ "$pp_colour_color" ]
-- end

-- function DrawInsanity()
-- 	local ply = LocalPlayer()
-- 	local base = B_Sanity
-- 	local current = C_Sanity
-- 	local smult = M_Sanity
-- 	local vol = C_Vol



-- 	if vol == 0 then return end

-- 	local mult = (math.sin(CurTime()/8) + math.cos(CurTime()/8))/2 * FrameTime()

-- 	for k,v in pairs(current) do
-- 		if math.random(0,10) < 9 then
-- 			current[k] = math.Clamp(current[k] + (mult * smult[k]), base[k] - (vol * smult[k]), base[k] + (vol * smult[k]) )
-- 			current[k] = math.Min(current[k],UL_Sanity[k])
-- 		end
-- 	end
	

-- 	AddDefaults(current)

	

-- 	DrawColorModify(current)

-- 	local i = 1
-- 	for k,v in pairs(current) do
-- 		draw.SimpleText(k.." = "..v, "Default", 10, 10 + (i*10), Color(255,255,255,255))
-- 		i = i + 1
-- 	end
-- end

-- function StartInsanity()
-- 	local ply = LocalPlayer()
-- 	local sanity = math.Round(ply:GetBaseSanity())
-- 	if sanity <= SANITY_LEVEL[SANITY_HIGH] then
-- 		if sanity <= SANITY_LEVEL[SANITY_MED] then
-- 			if sanity <= SANITY_LEVEL[SANITY_LOW] then
-- 				SANITY_EFFECT[SANITY_LOW](ply)
-- 				return
-- 			end
-- 			SANITY_EFFECT[SANITY_MED](ply)
-- 			return
-- 		end
-- 		SANITY_EFFECT[SANITY_MED](ply)
-- 		return
-- 	end
-- 	SANITY_EFFECT[SANITY_HIGH](ply)
-- end

-- function ResetInsanity()
-- 	C_Sanity = table.Copy(B_Sanity)
-- end

-- function SetSanity(level)
-- 	SANITY_EFFECT[level]()
-- end