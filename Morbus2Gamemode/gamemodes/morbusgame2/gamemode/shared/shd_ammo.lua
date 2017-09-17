--[[------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------]]

if Morbus.RegisteredAmmo then return end

for i, v in ipairs(EnumAmmo) do
  game.AddAmmoType( {
    name = v,
    tracer = TRACER_LINE_AND_WHIZ,
    minsplash = 0,
    maxsplash = 0
  } )

end


Morbus.RegisteredAmmo = true