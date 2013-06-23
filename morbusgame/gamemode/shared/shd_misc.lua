TYPE_KILL = 1
TYPE_INFECT = 2
TYPE_RDM = 3
TYPE_DIE = 4
TYPE_DAMAGE = 5

TypeName = {
  "Kill",
  "Infect",
  "RDM",
  "Die",
  "Damage"
}

TypeAction = {
  "killed",
  "infected",
  "RDM'd",
  "died",
  "damaged"
}

function Get_TypeName(type)
  return TypeName[type]
end
function Get_TypeAction(type)
  return TypeAction[type]
end

function GetRoleName(role)
  if (role == 1) then return "HUMAN"
  elseif (role == 2) then return "BROOD ALIEN"
  elseif (role == 3) then return "SWARM ALIEN" end

  return ""
end