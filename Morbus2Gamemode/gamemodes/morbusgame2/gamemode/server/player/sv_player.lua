/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

function GM:PlayerInitialSpawn(ply)

end

function GM:PlayerSpawn(ply)

end

function GM:PlayerSetModel(ply)

end

function GM:CanPlayerSuicide(ply)
  return true
end

function GM:PlayerUse(ply, ent)
   return not ply:IsSpec()
end

function GM:ShowHelp(ply)

end

function GM:ShowTeam(ply)

end

function GM:ShowSpare1(ply)

end

function GM:GetFallDamage(ply, speed)
   return 1
end

function GM:OnPlayerHitGround(ply, in_water, on_floater, speed)

end