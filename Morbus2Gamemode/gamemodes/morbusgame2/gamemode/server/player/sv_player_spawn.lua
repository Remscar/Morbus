/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

function GM:IsSpawnpointSuitable(ply, spwn, force, rigged)
  return true
end

function GM:PlayerSelectSpawn(ply)
  return ply
end

function Morbus:GetSpawnEnts(shuffle, all)
  return {}
end