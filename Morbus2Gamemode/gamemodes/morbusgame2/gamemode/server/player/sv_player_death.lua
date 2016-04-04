/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

-- Return true if player can spawn
function GM:PlayerDeathThink(ply)
  return true
end

-- Returns whether default death sound should play
function GM:PlayerDeathSound(ply)
  return true
end

-- Handles player death
-- Player::Alive will still return true, but after this they are no longer alive
function GM:DoPlayerDeath(victim, killer, dmginfo)

end

-- Called when a player is killed (unless from KillSilent)
-- PostPlayerDeath is for when the player is 100% dead (?)
-- Inflictor and Killer are entities, not neccesarily players
function GM:PlayerDeath(victim, inflictor, killer)

end