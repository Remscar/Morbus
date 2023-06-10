if ( CLIENT ) then
  SWEP.PrintName      = "Sticky Glow Sticks"
end

SWEP.Base = "weapon_mor_base_glowstick"

--EntName & FlyEntName overrides
SWEP.EntName 	= "ent_sglowstick"
SWEP.FlyEntName = "ent_sglowstick_fly"
SWEP.WepName 	= "weapon_glowstick_sticky"

--ViewModel and WorldModel overrides
SWEP.ViewModel      = "models/glowstick/v_glowstick_rng.mdl"
SWEP.WorldModel     = "models/glowstick/stick_rng.mdl"
