WEPS = {}

function WEPS.TypeForWeapon(class)
   local tbl = util.WeaponForClass(class)
   return tbl and tbl.Kind or WEAPON_NONE
end


function WEPS.IsEquipment(wep)
   return wep.Kind and wep.Kind >= WEAPON_ROLE
end

function WEPS.GetClass(wep)
   if type(wep) == "table" then
      return wep.ClassName or wep.Classname
   elseif IsValid(wep) then
      return wep:GetClass()
   end
end