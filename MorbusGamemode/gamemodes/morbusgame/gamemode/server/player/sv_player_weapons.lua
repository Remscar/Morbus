// Morbus - morbus.remscar.com
// Developed by Remscar
// and the Morbus dev team

/*--------------------------------------------
MORBUS WEAPON SYSTEM
--------------------------------------------*/


for k, w in pairs(weapons.GetList()) do
   if w && w.Classname then
      umsg.PoolString(w.ClassName)
   end
end

function GM:PlayerCanPickupWeapon(ply, wep)
   if not ValidEntity(wep) and not ValidEntity(ply) then return end
   local awep = ply:GetActiveWeapon()

   if ply:IsSwarm() and wep:GetClass() != "weapon_mor_swarm" then
   	return false
   elseif !ply:IsSwarm() and wep:GetClass() == "weapon_mor_crowbar" then
      return true
   elseif ValidEntity(awep) and awep:GetClass() == "weapon_mor_brood" then
   	return false
   elseif !ply:IsSwarm() and wep:GetClass() == "weapon_glowstick_special" then
      return true
   elseif wep:GetClass() == "weapon_mor_swarm" and !ply:IsSwarm() then
   	return false
   elseif wep:GetClass() == "weapon_mor_brood" and !ply:IsBrood() then
      return false
   elseif ply:HasWeapon(wep:GetClass()) then
   	return false
   elseif not ply:CanCarryWeapon(wep) then
   	return false
   elseif wep:GetClass() == "weapon_mor_brood" and ply:IsBrood() then
      return true
   elseif wep:GetClass() == "weapon_mor_swarm" and ply:IsSwarm() then
      return true
   elseif (not ply:KeyDown(IN_USE)) then
      return false
   end

   local tr = util.TraceEntity({start=wep:GetPos(), endpos=ply:GetShootPos(), mask=MASK_SOLID}, wep)
   if tr.Fraction == 1.0 or tr.Entity == ply then
      wep:SetPos(ply:GetShootPos())
   end

   return true
end


local function GetLoadoutWeapons(r)
      local tbl = {
         [ROLE_HUMAN] = {},
         [ROLE_BROOD]  = {},
		 [ROLE_SWARM]  = {},
      }

   table.insert(tbl[ROLE_HUMAN], "weapon_mor_crowbar")

   table.insert(tbl[ROLE_BROOD], "weapon_mor_crowbar")
   table.insert(tbl[ROLE_BROOD], "weapon_mor_brood")

   table.insert(tbl[ROLE_SWARM], "weapon_mor_swarm")

   local loadout_weapons = tbl

   return loadout_weapons[r]
end


function GiveLoadoutWeapons(ply)
   local r = ply:GetRole()
   local weps = GetLoadoutWeapons(r)
   
   if not weps then return end

   for _, cls in pairs(weps) do
      if not ply:HasWeapon(cls) then
         ply:Give(cls)
      end
   end
end


local function HasLoadoutWeapons(ply)
   if ply:IsSpec() then return true end

   local r = GetRoundState() == ROUND_PREP and ROLE_HUMAN or ply:GetRole()
   local weps = GetLoadoutWeapons(r)
   if not weps then return true end


   for _, cls in pairs(weps) do
      if not ply:HasWeapon(cls) then
         return false
      end
   end

   return true
end


local function LateLoadout(id)
   local ply = player.GetByID(id)
   if not ValidEntity(ply) then 
      timer.Destroy("lateloadout" .. id)
      return 
   end

   if not HasLoadoutWeapons(ply) then
      GiveLoadoutWeapons(ply)

      if HasLoadoutWeapons(ply) then
         timer.Destroy("lateloadout" .. id)
      end
   end
end


function GM:PlayerLoadout( ply )
   if IsValid(ply) and (not ply:IsSpec()) then


      GiveLoadoutWeapons(ply)

      if not HasLoadoutWeapons(ply) then
         MsgN("Could not spawn all loadout weapons for " .. ply:Nick() .. ", will retry.")
         timer.Create("lateloadout" .. ply:EntIndex(), 1, 0, function() LateLoadout(ply:EntIndex()) end)
      end
   end
end


function GM:UpdatePlayerLoadouts()
   for k, v in pairs(player.GetAll()) do
      GAMEMODE:PlayerLoadout(v)
   end
end


function WEPS.DropNotifiedWeapon(ply, wep)
   if ValidEntity(ply) and ValidEntity(wep) then
      -- Hack to tell the weapon it's about to be dropped and should do what it
      -- must right now
	  	if wep.AllowDrop == false then
			ply:StripWeapon(wep:GetClass())
			return
		end
		
	 if not IsValid(wep) then return end
	 
      if wep.PreDrop then
         wep:PreDrop()
      end
      wep.IsDropped = true

      ply:DropWeapon(wep)

      timer.Simple(0.1,function() wep:PhysWake() end )


      ply:SelectWeapon("weapon_mor_crowbar")
   end
end


local function DropActiveWeapon(ply)
   if not ValidEntity(ply) then return end

   local wep = ply:GetActiveWeapon()

   if not ValidEntity(wep) then return end

   if wep.AllowDrop == false then
      return
   end

   local tr = util.QuickTrace(ply:GetShootPos(), ply:GetAimVector() * 32, ply)

   if tr.HitWorld then
      ply:ChatPrint("You have no room here to drop your weapon!")
      return
   end

   WEPS.DropNotifiedWeapon(ply, wep)
end
concommand.Add("morbus_dropweapon", DropActiveWeapon)


function GM:WeaponEquip(wep)
   if ValidEntity(wep) then
      if not wep.Kind then
         ErrorNoHalt("Removing imcompatible gun")
        wep:Remove()
      end
   end
end

local function ForceWeaponSwitch(ply, cmd, args)
   -- Turns out even SelectWeapon refuses to switch to empty guns, gah.
   -- Worked around it by giving every weapon a single Clip2 round.
   -- Works because no weapon uses those.
   local wepname = args[1]
   local wep = ply:GetWeapon(wepname)
   if ValidEntity(wep) then
      -- Weapons apparently not guaranteed to have this
      if wep.SetClip2 then
         wep:SetClip2(1)
      end

      if (wep:GetClass() != "weapon_mor_brood") then
         ply:SelectWeapon(wepname)
      elseif ply.CanTransform then
         ply:SelectWeapon(wepname)
      end
      
   end
end
concommand.Add("wepswitch", ForceWeaponSwitch)


local function DropActiveAmmo(ply)
   if not ValidEntity(ply) then return end

   local wep = ply:GetActiveWeapon()
   if not ValidEntity(wep) then return end

   if not wep.AmmoEnt then return end

   local amt = wep:Clip1()
   if amt < 1 or amt <= (wep.Primary.ClipSize * 0.25) then
      return
   end

   local pos, ang = ply:GetShootPos(), ply:EyeAngles()
   local dir = (ang:Forward() * 32) + (ang:Right() * 6) + (ang:Up() * -5)

   local tr = util.QuickTrace(pos, dir, ply)
   if tr.HitWorld then return end

   wep:SetClip1(0)

   //ply:AnimPerformGesture(ACT_ITEM_GIVE)

   local box = ents.Create(wep.AmmoEnt)
   if not IsValid(box) then box:Remove() end

   box:SetPos(pos + dir)
   box:SetOwner(ply)
   box:Spawn()

   box:PhysWake()

   local phys = box:GetPhysicsObject()
   if IsValid(phys) then
      phys:ApplyForceCenter(ang:Forward() * 1000)
      phys:ApplyForceOffset(VectorRand(), vector_origin)
   end

   box.AmmoAmount = amt

   timer.Simple(2, function()
                      if IsValid(box) then
                         box:SetOwner(nil)
                      end
                   end)
end
concommand.Add("morbus_dropammo", DropActiveAmmo)