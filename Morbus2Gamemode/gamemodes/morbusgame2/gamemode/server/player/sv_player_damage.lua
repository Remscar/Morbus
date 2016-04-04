

function GM:EntityTakeDamage(ent, dmginfo)
  if not IsValid(ent) then return end
  local attacker = dmginfo:GetAttacker()
  local inflictor = dmginfo:GetInflictor()

  if ent:IsPlayer() then
    self:PlayerTakeDamage(ent, inflictor, attacker, dmginfo)
  end
end

function GM:PlayerTakeDamage(ent, inflictor, attacker, dmginfo)

end

-- This function will get called by GMOD anyways, but we do it in PlayerTakeDamage ourselves
function GM:ScalePlayerDamage(ply, hitgroup, dmginfo, real)
  if not real then return end
end