if ( CLIENT ) then
	SWEP.PrintName			= "Grav Sticks"
end

SWEP.Base = "weapon_mor_base_glowstick"

--override these value for grav sticks
SWEP.PropelForwardSpeed	= 300
SWEP.UseGravity			= false
SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= 4

--EntName & FlyEntName overrides
SWEP.EntName 	= "ent_bglowstick"
SWEP.FlyEntName = "ent_bglowstick_fly"
SWEP.WepName 	= "weapon_glowstick_grav"

--ViewModel and WorldModel overrides
SWEP.ViewModel			= "models/glowstick/v_glowstick_lblu.mdl"
SWEP.WorldModel			= "models/glowstick/stick_lblu.mdl"
