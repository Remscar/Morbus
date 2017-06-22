/*------------------------------------
  Morbus 2
  Zachary Nawar - zachary.nawar.org
  ------------------------------------*/

if not Morbus.RoundEngine then
  Morbus.RoundEngine = {}
end

if not Morbus.RoundStates then
  Morbus.RoundStates = {}
end

local RoundEngine = Morbus.RoundEngine

function RoundEngine:GetStateTable(enum)
  if not enum then return nil end

  if not Morbus.RoundStates[enum] then
    Morbus.RoundStates[enum] = {}
  else
    return Morbus.RoundStates[enum]
  end

  local newState = Morbus.RoundStates[enum]
  newState.StateID = enum
  // newState.NetData = {}

  // local newStateMeta = {}

  /* Search inside of NetData to see if it exists first */
  // function newStateMeta:__index(key)
  //   if self.NetData[key] then
  //     return self.NetData[key]
  //   end

  //   return nil
  // end

  // function newStateMeta:__newindex(key, value)
  //   if self.NetData[key] then
  //     return self.NetData[key] = value
  //   end

  //   rawset(self, key, value)
  // end

  // setmetatable(newState, newStateMeta)
  return newState
end
